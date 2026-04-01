# NFS-e Endpoints — Nuvem Fiscal API

> Se algum endpoint ou campo não estiver documentado aqui, consulte:
> - https://dev.nuvemfiscal.com.br/docs/nfse/
> - https://dev.nuvemfiscal.com.br/docs/api
> - https://raw.githubusercontent.com/nuvem-fiscal/nuvemfiscal-sdk-net/main/api/openapi.yaml

---

## POST /nfse/dps — Emitir NFS-e (método atual)

Body completo `NfseDpsPedidoEmissao`:

```json
{
  "ambiente": "homologacao",
  "provedor": "padrao",
  "referencia": "ref-unica-123",
  "infDPS": {
    "dCompet": "2024-01-15",
    "serv": {
      "cServ": {
        "cTribMun": "01.01",
        "xDescServ": "Desenvolvimento de software sob encomenda"
      },
      "locPrest": {
        "cLocPrestacao": "3550308"
      }
    },
    "toma": {
      "CNPJ": "00000000000191",
      "xNome": "Banco do Brasil S/A",
      "end": {
        "xLgr": "Saun Quadra 5 Lote B Torres I",
        "nro": "S/N",
        "xBairro": "Asa Norte",
        "cMun": 5300108,
        "xMun": "Brasília",
        "CEP": "70040912",
        "cPais": 1058,
        "xPais": "Brasil",
        "UF": "DF"
      },
      "fone": "6134934000",
      "email": "contato@bb.com.br"
    },
    "valores": {
      "vServPrest": {
        "vServ": 1000.00
      },
      "trib": {
        "tribMun": {
          "tribISSQN": 1,
          "cNatOp": 1,
          "BM": {
            "tpBM": 1,
            "vBC": 1000.00,
            "pAliq": 2.00
          }
        }
      }
    }
  }
}
```

### Campos obrigatórios mínimos em `infDPS`:

| Campo | Tipo | Descrição |
|---|---|---|
| `dCompet` | date (YYYY-MM-DD) | Data de competência do serviço |
| `serv.cServ.xDescServ` | string | Descrição do serviço |
| `serv.locPrest.cLocPrestacao` | string | Código IBGE do município da prestação |
| `valores.vServPrest.vServ` | decimal | Valor bruto do serviço |

### Campos opcionais relevantes em `infDPS`:

| Campo | Descrição |
|---|---|
| `serv.cServ.cTribMun` | Código tributário municipal do serviço |
| `serv.cServ.CNAE` | CNAE do serviço |
| `serv.cServ.cNBS` | Código NBS |
| `serv.cServ.cTribNac` | Código tributário nacional |
| `toma.CPF` | CPF do tomador (PF) |
| `toma.CNPJ` | CNPJ do tomador (PJ) |
| `toma.xNome` | Nome/Razão social do tomador |
| `toma.email` | Email do tomador |
| `valores.vDedRed.vDR` | Valor de deduções/reduções |
| `valores.trib.tribMun.BM.pAliq` | Alíquota ISS (%) |
| `valores.trib.tribFed.piscofins` | PIS/COFINS |
| `valores.trib.tribFed.vRetCP` | Retenção INSS |
| `valores.trib.tribFed.vRetIRRF` | Retenção IRRF |
| `valores.trib.tribFed.vRetCSLL` | Retenção CSLL |
| `interm.xNome` | Nome do intermediário |
| `interm.CNPJ` ou `interm.CPF` | Documento do intermediário |

### Provedor:
- `"padrao"` → sistema padrão por município (maioria dos casos)
- `"nacional"` → Sistema Nacional NFS-e (ADN, ABRASF v3)

---

## Resposta — Objeto `Nfse`

```json
{
  "id": "uuid-da-nota",
  "created_at": "2024-01-15T10:30:00Z",
  "status": "autorizada",
  "numero": "1234",
  "codigo_verificacao": "ABC123",
  "link_url": "https://...",
  "data_emissao": "2024-01-15T10:31:00Z",
  "ambiente": "homologacao",
  "referencia": "ref-unica-123",
  "DPS": {
    "serie": "A",
    "nDPS": "1"
  },
  "mensagens": [
    { "codigo": "...", "descricao": "...", "correcao": "..." }
  ]
}
```

**Status possíveis:**
- `processando` — sendo processada pela prefeitura
- `autorizada` — emitida com sucesso
- `negada` — rejeitada pela prefeitura (ver `mensagens`)
- `cancelada` — cancelada com sucesso
- `substituida` — substituída por outra nota
- `erro` — erro de transmissão (usar `/sincronizar` para reprocessar)

---

## GET /nfse — Listar NFS-e

```
GET {BASE_URL}/nfse?cpf_cnpj={cnpj}&ambiente={ambiente}&$top=10&$skip=0&$inlinecount=true
```

Query params:
- `cpf_cnpj` (required) — sem máscara
- `ambiente` (required) — `homologacao` ou `producao`
- `$top` (1-100, default 10)
- `$skip` (default 0)
- `$inlinecount` (bool) — inclui `@count` no retorno
- `referencia` — filtrar por referência
- `chave` — filtrar pela chave de acesso
- `serie` — filtrar por série

---

## GET /nfse/{id} — Consultar NFS-e

Retorna o objeto `Nfse` completo. Usar para verificar status após emissão.

---

## POST /nfse/{id}/cancelamento — Cancelar NFS-e

```json
{
  "codigo": "2",
  "motivo": "Erro na emissão"
}
```

`codigo` e `motivo` são opcionais, mas alguns municípios exigem.

Resposta `NfseCancelamento`:
```json
{
  "id": "uuid",
  "status": "pendente|concluido|rejeitado|erro",
  "codigo": "2",
  "motivo": "Erro na emissão",
  "data_hora": "2024-01-15T11:00:00Z",
  "mensagens": []
}
```

---

## POST /nfse/{id}/sincronizar — Sincronizar Status

Usar quando nota está em `processando` ou `erro` mas pode ter sido autorizada na prefeitura:

```json
{
  "identificador": "chave-ou-numero-nfse"
}
```

---

## GET /nfse/{id}/pdf — Baixar DANFSE

```
GET {BASE_URL}/nfse/{id}/pdf?logotipo=true&mensagem_rodape=Texto|Centro|Direita
```

Retorna: binário PDF (`Content-Type: application/pdf`)

---

## GET /nfse/{id}/xml — Baixar XML

Retorna: XML binário da NFS-e autorizada.

## GET /nfse/{id}/xml/dps — Baixar XML DPS

Retorna: XML binário do DPS enviado.

---

## POST /nfse/dps/lotes — Emitir Lote

```json
{
  "ambiente": "homologacao",
  "cpf_cnpj": "72645363000112",
  "dps": [
    { /* mesmo schema de infDPS */ },
    { /* ... */ }
  ]
}
```

Resposta `RpsLote`:
```json
{
  "id": "uuid-do-lote",
  "status": "pendente|processando|processado|erro",
  "created_at": "2024-01-15T10:00:00Z",
  "notas": [ /* array de Nfse */ ]
}
```

## GET /nfse/lotes/{id} — Consultar Lote

---

## GET /nfse/cidades — Cidades Atendidas

Lista todos os municípios onde a emissão de NFS-e está disponível.

## GET /nfse/cidades/{codigo_ibge} — Metadados do Município

Verifica disponibilidade e detalhes de emissão para um município específico.

---

## Erros Comuns na NFS-e

| Situação | Causa provável | Solução |
|---|---|---|
| `status: negada` | CNPJ do tomador inválido | Verificar CNPJ |
| `status: negada` | Serviço não cadastrado na prefeitura | Verificar código tributário municipal |
| `status: erro` | Timeout na prefeitura | Usar `/sincronizar` |
| 422 | Campo obrigatório ausente | Ver `mensagens[]` no retorno |
| `negada` + código ISS | Alíquota incorreta | Verificar tabela do município |
| `negada` + IM | Inscrição municipal inválida | Corrigir em `/empresas/{cnpj}` |

---

## Nota sobre municípios com login/senha

Alguns municípios não usam certificado digital e requerem login/senha da prefeitura. Configurar em:

```http
PUT {BASE_URL}/empresas/{cpf_cnpj}/nfse

{
  "ambiente": "homologacao",
  "rps": { "lote": 1, "serie": "A", "numero": 1 },
  "prefeitura": {
    "login": "usuario_prefeitura",
    "senha": "senha_prefeitura",
    "token": "token_se_necessario"
  }
}
```
