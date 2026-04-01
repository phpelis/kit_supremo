---
name: integrations-nuvem-fiscal
description: >
  Integração com a API Nuvem Fiscal para emissão de NFS-e (Nota Fiscal de Serviço Eletrônica), cadastro 
  e gestão de empresas, consulta de CNPJ/CEP e documentos fiscais eletrônicos. Use quando o usuário mencionar 
  Nuvem Fiscal, NFS-e, nota fiscal de serviço, emissão de nota, cancelamento de nota, cadastro de empresa 
  na Nuvem Fiscal, DPS, RPS, DANFSE, ou quando o projeto usar as variáveis NUVEM_FISCAL_CLIENT_ID / NUVEM_FISCAL_CLIENT_SECRET. 
  NÃO acionar para NF-e de produtos, CT-e ou MDF-e, a menos que explicitamente solicitado.
---

# Skill: Nuvem Fiscal API

## Contexto e Credenciais

Todo projeto usa `.env.local` na raiz com as credenciais:

```env
NUVEM_FISCAL_CLIENT_ID=seu_client_id
NUVEM_FISCAL_CLIENT_SECRET=seu_client_secret
NUVEM_FISCAL_ENV=sandbox   # ou: producao
```

- `NUVEM_FISCAL_ENV=sandbox` → base URL: `https://api.sandbox.nuvemfiscal.com.br`
- `NUVEM_FISCAL_ENV=producao` → base URL: `https://api.nuvemfiscal.com.br`

**SEMPRE leia `.env.local` antes de qualquer operação para descobrir o ambiente correto.**

---

## Autenticação OAuth2 (Client Credentials)

**Token endpoint:** `POST https://auth.nuvemfiscal.com.br/oauth/token`

```http
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials
&client_id=<NUVEM_FISCAL_CLIENT_ID>
&client_secret=<NUVEM_FISCAL_CLIENT_SECRET>
&scope=empresa nfse nfe cnpj cep conta
```

Resposta:
```json
{ "access_token": "eyJ...", "token_type": "bearer", "expires_in": 3600 }
```

Use em todas as requests: `Authorization: Bearer <access_token>`

> O token expira em 1h. Armazene e reutilize dentro da sessão.

---

## Fluxo Principal: Emissão de NFS-e

```
1. Ler .env.local → obter CLIENT_ID, CLIENT_SECRET, ENV
2. Autenticar → obter access_token
3. Verificar empresa cadastrada (GET /empresas/{cpf_cnpj})
4. Verificar configuração NFS-e (GET /empresas/{cpf_cnpj}/nfse)
5. Emitir NFS-e via DPS (POST /nfse/dps)
6. Verificar status (GET /nfse/{id})
7. Baixar PDF/XML se necessário
```

### Passo 3 — Cadastro de Empresa

Se empresa não existir, cadastrar primeiro:
```http
POST {BASE_URL}/empresas
Authorization: Bearer <token>
Content-Type: application/json

{
  "cpf_cnpj": "72645363000112",
  "nome_razao_social": "Empresa LTDA",
  "nome_fantasia": "Empresa",
  "email": "contato@empresa.com.br",
  "fone": "11999999999",
  "inscricao_municipal": "123456",
  "endereco": {
    "logradouro": "Rua Exemplo",
    "numero": "100",
    "complemento": "Sala 1",
    "bairro": "Centro",
    "codigo_municipio": "3550308",
    "cidade": "São Paulo",
    "uf": "SP",
    "cep": "01310100",
    "codigo_pais": "1058",
    "pais": "Brasil"
  }
}
```

### Passo 4 — Configurar NFS-e na Empresa

**OBRIGATÓRIO antes de emitir.** Verificar e configurar:
```http
PUT {BASE_URL}/empresas/{cpf_cnpj}/nfse
Authorization: Bearer <token>
Content-Type: application/json

{
  "ambiente": "homologacao",
  "rps": {
    "lote": 1,
    "serie": "A",
    "numero": 1
  },
  "regTrib": {
    "opSimpNac": 1
  }
}
```

> `ambiente` deve bater com `NUVEM_FISCAL_ENV`: `sandbox` → `"homologacao"`, `producao` → `"producao"`.

### Passo 5 — Emitir NFS-e (POST /nfse/dps)

Endpoint preferido (atual, não deprecado):
```http
POST {BASE_URL}/nfse/dps
Authorization: Bearer <token>
Content-Type: application/json
```

Ver detalhes completos do payload em → [references/nfse-endpoints.md](references/nfse-endpoints.md)

### Passo 6 — Verificar Status

```http
GET {BASE_URL}/nfse/{id}
```

Status possíveis: `processando | autorizada | negada | cancelada | substituida | erro`

- `processando`: aguardar e consultar novamente em alguns segundos
- `autorizada`: sucesso — baixar PDF/XML se necessário
- `erro` ou `negada`: verificar `mensagens[]` para detalhes e correção

---

## Endpoints de Referência Rápida

| Ação | Método | Path |
|---|---|---|
| Listar empresas | GET | `/empresas` |
| Cadastrar empresa | POST | `/empresas` |
| Consultar empresa | GET | `/empresas/{cpf_cnpj}` |
| Atualizar empresa | PUT | `/empresas/{cpf_cnpj}` |
| Excluir empresa | DELETE | `/empresas/{cpf_cnpj}` |
| Config NFS-e da empresa | GET/PUT | `/empresas/{cpf_cnpj}/nfse` |
| Upload certificado | PUT | `/empresas/{cpf_cnpj}/certificado` |
| Upload logo | PUT | `/empresas/{cpf_cnpj}/logotipo` |
| **Emitir NFS-e (atual)** | POST | `/nfse/dps` |
| Emitir lote NFS-e | POST | `/nfse/dps/lotes` |
| Listar NFS-e | GET | `/nfse` |
| Consultar NFS-e | GET | `/nfse/{id}` |
| Cancelar NFS-e | POST | `/nfse/{id}/cancelamento` |
| Sincronizar status | POST | `/nfse/{id}/sincronizar` |
| Baixar PDF (DANFSE) | GET | `/nfse/{id}/pdf` |
| Baixar XML | GET | `/nfse/{id}/xml` |
| Cidades atendidas | GET | `/nfse/cidades` |
| Consultar município | GET | `/nfse/cidades/{codigo_ibge}` |
| Consultar CEP | GET | `/cep/{cep}` |
| Consultar CNPJ | GET | `/cnpj/{cnpj}` |

---

## Tratamento de Erros

- **401**: token inválido ou expirado → reautenticar
- **404**: recurso não encontrado → verificar CNPJ/ID
- **422**: dados inválidos → verificar `mensagens[]` no body de resposta
- **429**: rate limit → aguardar e tentar novamente
- **`status: erro`** na NFS-e: ler `mensagens[].descricao` e `mensagens[].correcao`

### Se uma função/endpoint não for encontrado nesta skill:
**OBRIGATÓRIO**: consultar a documentação oficial antes de implementar:
- Docs gerais: `https://dev.nuvemfiscal.com.br/docs`
- Referência da API: `https://dev.nuvemfiscal.com.br/docs/api`
- OpenAPI YAML: `https://raw.githubusercontent.com/nuvem-fiscal/nuvemfiscal-sdk-net/main/api/openapi.yaml`

---

## Referências Detalhadas

- [Autenticação e Ambientes](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-nuvem-fiscal/references/auth.md)
- [Endpoints NFS-e completos + schemas](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-nuvem-fiscal/references/nfse-endpoints.md)
- [Endpoints Empresa completos + schemas](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-nuvem-fiscal/references/empresa-endpoints.md)
- [Exemplos de código](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-nuvem-fiscal/references/code-examples.md)
