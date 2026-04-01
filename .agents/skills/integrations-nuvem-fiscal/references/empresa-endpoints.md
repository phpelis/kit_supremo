# Empresa Endpoints — Nuvem Fiscal API

> Se algum endpoint não estiver aqui, consulte:
> - https://dev.nuvemfiscal.com.br/docs/empresas
> - https://dev.nuvemfiscal.com.br/docs/api

---

## POST /empresas — Cadastrar Empresa

```json
{
  "cpf_cnpj": "72645363000112",
  "nome_razao_social": "Minha Empresa LTDA",
  "nome_fantasia": "Minha Empresa",
  "email": "contato@minhaempresa.com.br",
  "fone": "11999999999",
  "inscricao_estadual": "123456789",
  "inscricao_municipal": "987654",
  "endereco": {
    "logradouro": "Rua das Flores",
    "numero": "100",
    "complemento": "Sala 10",
    "bairro": "Jardim Paulista",
    "codigo_municipio": "3550308",
    "cidade": "São Paulo",
    "uf": "SP",
    "cep": "01310100",
    "codigo_pais": "1058",
    "pais": "Brasil"
  }
}
```

**Campos obrigatórios:** `cpf_cnpj`, `nome_razao_social`, `email`, `endereco`

**Código IBGE do município:** usar o código de 7 dígitos do IBGE.
Consultar via: `GET /cnpj/{cnpj}` → retorna `municipio.codigo_ibge`
Ou via: `GET /cep/{cep}` → retorna `ibge`

---

## GET /empresas — Listar Empresas

```
GET {BASE_URL}/empresas?$top=10&$skip=0&$inlinecount=true&cpf_cnpj=72645363000112
```

Query params:
- `$top` (1-100, default 10)
- `$skip` (default 0)
- `$inlinecount` (bool)
- `cpf_cnpj` (filtro opcional)

---

## GET /empresas/{cpf_cnpj} — Consultar Empresa

Retorna o objeto `Empresa` completo. `cpf_cnpj` sem máscara.

---

## PUT /empresas/{cpf_cnpj} — Atualizar Empresa

Mesma estrutura do POST. **Atenção:** semântica PUT — campos ausentes são apagados.

---

## DELETE /empresas/{cpf_cnpj} — Excluir Empresa

---

## Configuração NFS-e da Empresa

### GET /empresas/{cpf_cnpj}/nfse

Retorna `EmpresaConfigNfse`:
```json
{
  "ambiente": "homologacao",
  "rps": {
    "lote": 1,
    "serie": "A",
    "numero": 1
  },
  "regTrib": {
    "opSimpNac": 1,
    "regApTribSN": null,
    "regEspTrib": 0
  },
  "prefeitura": {
    "login": null,
    "senha": null,
    "token": null
  },
  "incentivo_fiscal": false
}
```

### PUT /empresas/{cpf_cnpj}/nfse

**OBRIGATÓRIO antes de emitir NFS-e pela primeira vez.**

```json
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

**`opSimpNac` (Regime Simples Nacional):**
- `1` — Não Optante
- `2` — MEI
- `3` — ME/EPP (Micro/Pequeno Porte)

**`regApTribSN`** (apenas quando `opSimpNac=3`):
- `1` — Tributação normal pelo Simples
- `2` — Excesso de sublimite — tributação normal IRPJ/CSLL/PIS/COFINS
- `3` — Excesso de sublimite — ISSQN tributado pelo município

**`regEspTrib`:**
- `0` — Nenhum
- `1` — Cooperativa
- `2` — Estimativa
- `3` — Sociedade de Profissionais
- `4` — Concessionária
- `5` — MEI do Simples Nacional
- `6` — ME/EPP do Simples Nacional

---

## Certificado Digital

### PUT /empresas/{cpf_cnpj}/certificado — Upload base64

```json
{
  "certificado": "<base64 do arquivo .pfx ou .p12>",
  "password": "senha_do_certificado"
}
```

### PUT /empresas/{cpf_cnpj}/certificado/upload — Upload multipart

```
Content-Type: multipart/form-data

file: <binário do .pfx/.p12>
password: <senha>
```

### GET /empresas/{cpf_cnpj}/certificado — Consultar certificado

Retorna `EmpresaCertificado`:
```json
{
  "cpf_cnpj": "72645363000112",
  "serie": "...",
  "cnpj_emitido_para": "...",
  "nome_emitido_para": "...",
  "validade": "2025-12-31T23:59:59Z"
}
```

### DELETE /empresas/{cpf_cnpj}/certificado — Remover certificado

---

## Logotipo

### PUT /empresas/{cpf_cnpj}/logotipo — Upload logo

```
Content-Type: multipart/form-data
file: <binário PNG ou JPEG, max 200KB>
```

### GET /empresas/{cpf_cnpj}/logotipo — Download logo (binário)

### DELETE /empresas/{cpf_cnpj}/logotipo — Remover logo

---

## Outras Configurações por Tipo de Documento

| Documento | Consultar | Atualizar |
|---|---|---|
| NFS-e | `GET /empresas/{cnpj}/nfse` | `PUT /empresas/{cnpj}/nfse` |
| NF-e | `GET /empresas/{cnpj}/nfe` | `PUT /empresas/{cnpj}/nfe` |
| NFC-e | `GET /empresas/{cnpj}/nfce` | `PUT /empresas/{cnpj}/nfce` |
| CT-e | `GET /empresas/{cnpj}/cte` | `PUT /empresas/{cnpj}/cte` |
| MDF-e | `GET /empresas/{cnpj}/mdfe` | `PUT /empresas/{cnpj}/mdfe` |

---

## Fluxo Completo de Cadastro

1. Consultar CNPJ: `GET /cnpj/{cnpj}` para obter dados cadastrais e código IBGE
2. Cadastrar empresa: `POST /empresas`
3. Fazer upload do certificado: `PUT /empresas/{cnpj}/certificado`
4. Configurar NFS-e: `PUT /empresas/{cnpj}/nfse` (definir ambiente, RPS e regime tributário)
5. (Opcional) Upload de logotipo: `PUT /empresas/{cnpj}/logotipo`
6. Emitir nota: `POST /nfse/dps`
