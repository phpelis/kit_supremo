"""Skill discovery and tool registration helpers."""

import importlib.util
import inspect
import os
from pathlib import Path
from typing import Any, Callable


_SKILLS_CACHE: dict[str, tuple[dict[str, Callable[..., Any]], str]] = {}


def _verbose() -> bool:
    """Return whether skill loading should print diagnostics."""
    return os.environ.get("AG_SKILLS_VERBOSE", "0").strip().lower() in {"1", "true", "yes"}


def load_skills(agent_tools: dict[str, Callable[..., Any]]) -> str:
    """
    Scans for skill packages in multiple locations:
    1. Engine-internal skills directory (antigravity_engine/skills/)
    2. Project-local skills directory (.agents/skills/) - Project-local skills override engine ones.

    For each skill found:
    1. Looks for tools.py: Registers public functions as tools.
    2. Looks for SKILL.md: Reads documentation content.
    
    Args:
        agent_tools: The dictionary of tools to update with new skill-based tools.
        
    Returns:
        A combined string of all SKILL.md contents to be injected into context.
    """
    # 1. Determine skill search paths (Internal first, then Local to allow override)
    internal_skills_dir = Path(__file__).parent.resolve()
    # Path.cwd() is used as fallback for PROJECT_ROOT if not set in env
    project_root = Path(os.environ.get("WORKSPACE_PATH", str(Path.cwd())))
    local_skills_dir = project_root / ".agents" / "skills"
    
    search_paths = [internal_skills_dir]
    if local_skills_dir.exists() and local_skills_dir.is_dir():
        search_paths.append(local_skills_dir)
        
    cache_key = ":".join(str(p) for p in search_paths)
    cached = _SKILLS_CACHE.get(cache_key)
    if cached is not None:
        cached_tools, cached_docs = cached
        agent_tools.update(cached_tools)
        return cached_docs

    skill_docs: dict[str, str] = {}
    discovered_tools: dict[str, Callable[..., Any]] = {}
    verbose = _verbose()
    
    if verbose:
        print(f"📦 Scanning for skills in: {[str(p) for p in search_paths]}")

    for skills_dir in search_paths:
        if not skills_dir.exists():
            continue
            
        for skill_path in skills_dir.iterdir():
            if not skill_path.is_dir() or skill_path.name.startswith("_") or skill_path.name == "__pycache__":
                continue
                
            skill_name = skill_path.name
            if verbose:
                print(f"   ► Processing skill: {skill_name} ({'local' if '.agents' in str(skill_path) else 'internal'})")
            
            # 1. Load Tools (tools.py)
            tools_file = skill_path / "tools.py"
            if tools_file.exists():
                try:
                    # Unique module name to avoid conflicts during import
                    module_key = f"antigravity_engine.skills.{skill_name}.tools"
                    if ".agents" in str(skill_path):
                        module_key = f"project_local.skills.{skill_name}.tools"
                        
                    spec = importlib.util.spec_from_file_location(module_key, tools_file)
                    if spec and spec.loader:
                        module = importlib.util.module_from_spec(spec)
                        spec.loader.exec_module(module)
                        
                        count = 0
                        for name, obj in inspect.getmembers(module, inspect.isfunction):
                            if not name.startswith("_") and obj.__module__ == module.__name__:
                                discovered_tools[name] = obj
                                count += 1
                        if verbose:
                            print(f"     ✓ Loaded {count} tools from tools.py")
                except Exception as e:
                    if verbose:
                        print(f"     ❌ Failed to load tools: {e}")
            
            # 2. Load Documentation (SKILL.md)
            doc_file = skill_path / "SKILL.md"
            if doc_file.exists():
                try:
                    content = doc_file.read_text(encoding="utf-8").strip()
                    if content:
                        # Local documentation replaces internal documentation for the same skill name
                        skill_docs[skill_name] = f"\n--- SKILL: {skill_name} ---\n{content}"
                        if verbose:
                            print(f"     ✓ Loaded documentation from SKILL.md")
                except Exception as e:
                    if verbose:
                        print(f"     ❌ Failed to load docs: {e}")

    final_docs = "\n".join(skill_docs.values())
    _SKILLS_CACHE[cache_key] = (discovered_tools, final_docs)
    agent_tools.update(discovered_tools)
    return final_docs
