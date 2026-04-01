# Autenticação e Ambientes — Nuvem Fiscal

## Leitura do .env.local

Sempre leia o arquivo `.env.local` na raiz do projeto:

```env
NUVEM_FISCAL_CLIENT_ID=p8aUwZ4ZiB4m1CGa65Na
NUVEM_FISCAL_CLIENT_SECRET=dMxLJr5893cv1uBAxLuuMbfGUjaePBfQadyRAxam
NUVEM_FISCAL_ENV=sandbox
```

| `NUVEM_FISCAL_ENV` | Base URL da API | `ambiente` nos requests |
|---|---|---|
| `sandbox` | `https://api.sandbox.nuvemfiscal.com.br` | `"homologacao"` |
| `producao` | `https://api.nuvemfiscal.com.br` | `"producao"` |

> O campo `ambiente` nos bodies de request deve ser `"homologacao"` para sandbox e `"producao"` para produção.

---

## Obtenção do Token OAuth2

**URL:** `POST https://auth.nuvemfiscal.com.br/oauth/token`
(sempre a mesma URL, independente do ambiente)

**Headers:**
```
Content-Type: application/x-www-form-urlencoded
```

**Body (form-encoded):**
```
grant_type=client_credentials
client_id=<NUVEM_FISCAL_CLIENT_ID>
client_secret=<NUVEM_FISCAL_CLIENT_SECRET>
scope=empresa nfse nfe nfce cte mdfe cnpj cep conta
```

**Scopes disponíveis:**
- `empresa` — gerenciar empresas e configurações
- `nfse` — emitir e consultar NFS-e
- `nfe` — NF-e de produtos
- `nfce` — NFC-e
- `cte` — CT-e
- `mdfe` — MDF-e
- `cnpj` — consultar CNPJ
- `cep` — consultar CEP
- `conta` — consultar cotas da conta

**Resposta:**
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_in": 3600,
  "scope": "empresa nfse cnpj cep conta"
}
```

**Uso em todas as requests:**
```
Authorization: Bearer <access_token>
```

**Validade:** 3600 segundos (1 hora). Reutilize o token dentro da sessão; só renove após expirar.

---

## Exemplo em JavaScript/Node.js

```javascript
import 'dotenv/config'; // ou usar dotenv para carregar .env.local

const clientId = process.env.NUVEM_FISCAL_CLIENT_ID;
const clientSecret = process.env.NUVEM_FISCAL_CLIENT_SECRET;
const env = process.env.NUVEM_FISCAL_ENV; // 'sandbox' ou 'producao'

const BASE_URL = env === 'producao'
  ? 'https://api.nuvemfiscal.com.br'
  : 'https://api.sandbox.nuvemfiscal.com.br';

const AMBIENTE = env === 'producao' ? 'producao' : 'homologacao';

async function getToken() {
  const params = new URLSearchParams({
    grant_type: 'client_credentials',
    client_id: clientId,
    client_secret: clientSecret,
    scope: 'empresa nfse cnpj cep conta',
  });

  const res = await fetch('https://auth.nuvemfiscal.com.br/oauth/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: params.toString(),
  });

  const data = await res.json();
  return data.access_token;
}
```

## Exemplo em PHP

```php
$clientId     = $_ENV['NUVEM_FISCAL_CLIENT_ID'];
$clientSecret = $_ENV['NUVEM_FISCAL_CLIENT_SECRET'];
$env          = $_ENV['NUVEM_FISCAL_ENV'] ?? 'sandbox';

$baseUrl  = $env === 'producao'
    ? 'https://api.nuvemfiscal.com.br'
    : 'https://api.sandbox.nuvemfiscal.com.br';
$ambiente = $env === 'producao' ? 'producao' : 'homologacao';

function getToken(string $clientId, string $clientSecret): string {
    $ch = curl_init('https://auth.nuvemfiscal.com.br/oauth/token');
    curl_setopt_array($ch, [
        CURLOPT_POST => true,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_POSTFIELDS => http_build_query([
            'grant_type'    => 'client_credentials',
            'client_id'     => $clientId,
            'client_secret' => $clientSecret,
            'scope'         => 'empresa nfse cnpj cep conta',
        ]),
        CURLOPT_HTTPHEADER => ['Content-Type: application/x-www-form-urlencoded'],
    ]);
    $response = json_decode(curl_exec($ch), true);
    curl_close($ch);
    return $response['access_token'];
}
```
