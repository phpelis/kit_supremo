# Exemplos de Código — Nuvem Fiscal API

---

## Cliente HTTP Genérico (JavaScript/Node.js)

```javascript
// lib/nuvemFiscal.js
import 'dotenv/config';

const clientId     = process.env.NUVEM_FISCAL_CLIENT_ID;
const clientSecret = process.env.NUVEM_FISCAL_CLIENT_SECRET;
const env          = process.env.NUVEM_FISCAL_ENV ?? 'sandbox';

export const BASE_URL = env === 'producao'
  ? 'https://api.nuvemfiscal.com.br'
  : 'https://api.sandbox.nuvemfiscal.com.br';

export const AMBIENTE = env === 'producao' ? 'producao' : 'homologacao';

let cachedToken = null;
let tokenExpiry = null;

export async function getToken() {
  if (cachedToken && tokenExpiry && Date.now() < tokenExpiry) {
    return cachedToken;
  }

  const params = new URLSearchParams({
    grant_type:    'client_credentials',
    client_id:     clientId,
    client_secret: clientSecret,
    scope:         'empresa nfse cnpj cep conta',
  });

  const res = await fetch('https://auth.nuvemfiscal.com.br/oauth/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: params.toString(),
  });

  if (!res.ok) throw new Error(`Auth failed: ${res.status}`);

  const data = await res.json();
  cachedToken = data.access_token;
  tokenExpiry = Date.now() + (data.expires_in - 60) * 1000; // 60s buffer
  return cachedToken;
}

export async function apiFetch(path, options = {}) {
  const token = await getToken();
  const res = await fetch(`${BASE_URL}${path}`, {
    ...options,
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json',
      ...options.headers,
    },
  });

  if (!res.ok) {
    const body = await res.text();
    throw new Error(`NuvemFiscal API error ${res.status}: ${body}`);
  }

  if (res.status === 204) return null;
  return res.json();
}
```

---

## Cadastrar Empresa

```javascript
import { apiFetch, AMBIENTE } from './lib/nuvemFiscal.js';

async function cadastrarEmpresa(dados) {
  return apiFetch('/empresas', {
    method: 'POST',
    body: JSON.stringify(dados),
  });
}

// Uso:
const empresa = await cadastrarEmpresa({
  cpf_cnpj: '72645363000112',
  nome_razao_social: 'Minha Empresa LTDA',
  email: 'contato@empresa.com.br',
  inscricao_municipal: '123456',
  endereco: {
    logradouro: 'Rua Exemplo',
    numero: '100',
    bairro: 'Centro',
    codigo_municipio: '3550308',
    cidade: 'São Paulo',
    uf: 'SP',
    cep: '01310100',
    codigo_pais: '1058',
    pais: 'Brasil',
  },
});
```

---

## Configurar NFS-e na Empresa

```javascript
async function configurarNfse(cpfCnpj) {
  return apiFetch(`/empresas/${cpfCnpj}/nfse`, {
    method: 'PUT',
    body: JSON.stringify({
      ambiente: AMBIENTE,
      rps: { lote: 1, serie: 'A', numero: 1 },
      regTrib: { opSimpNac: 1 },
    }),
  });
}
```

---

## Emitir NFS-e

```javascript
import { apiFetch, AMBIENTE } from './lib/nuvemFiscal.js';

async function emitirNfse({
  cpfCnpjEmitente,
  cpfCnpjTomador,
  nomeTomador,
  emailTomador,
  enderecoTomador,
  descricaoServico,
  valorServico,
  codigoMunicipioPrestacao,
  codigoTributarioMunicipal,
  aliquotaIss = 2.0,
  dataCompetencia = new Date().toISOString().split('T')[0],
  referencia = null,
}) {
  const body = {
    ambiente: AMBIENTE,
    referencia,
    infDPS: {
      dCompet: dataCompetencia,
      serv: {
        cServ: {
          cTribMun: codigoTributarioMunicipal,
          xDescServ: descricaoServico,
        },
        locPrest: {
          cLocPrestacao: codigoMunicipioPrestacao,
        },
      },
      toma: {
        CNPJ: cpfCnpjTomador,
        xNome: nomeTomador,
        email: emailTomador,
        end: enderecoTomador,
      },
      valores: {
        vServPrest: { vServ: valorServico },
        trib: {
          tribMun: {
            tribISSQN: 1,
            cNatOp: 1,
            BM: {
              tpBM: 1,
              vBC: valorServico,
              pAliq: aliquotaIss,
            },
          },
        },
      },
    },
  };

  return apiFetch('/nfse/dps', {
    method: 'POST',
    body: JSON.stringify(body),
  });
}

// Uso:
const nfse = await emitirNfse({
  cpfCnpjEmitente: '72645363000112',
  cpfCnpjTomador: '00000000000191',
  nomeTomador: 'Banco do Brasil S/A',
  emailTomador: 'contato@bb.com.br',
  enderecoTomador: {
    xLgr: 'Saun Quadra 5 Lote B',
    nro: 'S/N',
    xBairro: 'Asa Norte',
    cMun: 5300108,
    xMun: 'Brasília',
    CEP: '70040912',
    cPais: 1058,
    xPais: 'Brasil',
    UF: 'DF',
  },
  descricaoServico: 'Desenvolvimento de software',
  valorServico: 1000.00,
  codigoMunicipioPrestacao: '3550308',
  codigoTributarioMunicipal: '01.01',
  aliquotaIss: 2.0,
  referencia: `nfse-${Date.now()}`,
});

console.log('NFS-e emitida:', nfse.id, 'Status:', nfse.status);
```

---

## Aguardar Autorização (Polling)

```javascript
async function aguardarAutorizacao(id, maxTentativas = 10, intervalMs = 3000) {
  for (let i = 0; i < maxTentativas; i++) {
    const nfse = await apiFetch(`/nfse/${id}`);

    if (nfse.status === 'autorizada') return nfse;
    if (nfse.status === 'erro' || nfse.status === 'negada') {
      const msgs = nfse.mensagens?.map(m => m.descricao).join('; ');
      throw new Error(`NFS-e ${nfse.status}: ${msgs}`);
    }

    // status: 'processando' — aguardar e tentar novamente
    await new Promise(r => setTimeout(r, intervalMs));
  }
  throw new Error('Timeout aguardando autorização da NFS-e');
}

// Uso:
const nfse = await emitirNfse({ /* ... */ });
const nfseAutorizada = await aguardarAutorizacao(nfse.id);
console.log('Número:', nfseAutorizada.numero);
```

---

## Baixar PDF da NFS-e

```javascript
async function baixarPdfNfse(id, outputPath) {
  const token = await getToken();
  const res = await fetch(`${BASE_URL}/nfse/${id}/pdf?logotipo=true`, {
    headers: { Authorization: `Bearer ${token}` },
  });

  if (!res.ok) throw new Error(`Erro ao baixar PDF: ${res.status}`);

  const buffer = await res.arrayBuffer();
  await fs.writeFile(outputPath, Buffer.from(buffer));
}
```

---

## Cancelar NFS-e

```javascript
async function cancelarNfse(id, motivo = 'Erro na emissão') {
  return apiFetch(`/nfse/${id}/cancelamento`, {
    method: 'POST',
    body: JSON.stringify({ motivo }),
  });
}
```

---

## Consultar CEP

```javascript
async function consultarCep(cep) {
  return apiFetch(`/cep/${cep.replace(/\D/g, '')}`);
}

// Retorna: { cep, logradouro, bairro, cidade, uf, ibge }
```

---

## Consultar CNPJ

```javascript
async function consultarCnpj(cnpj) {
  return apiFetch(`/cnpj/${cnpj.replace(/\D/g, '')}`);
}

// Retorna dados completos: razão social, endereço, atividades, etc.
```

---

## Exemplo PHP Completo

```php
<?php
// lib/NuvemFiscal.php

class NuvemFiscal {
    private string $clientId;
    private string $clientSecret;
    private string $baseUrl;
    private string $ambiente;
    private ?string $token = null;
    private int $tokenExpiry = 0;

    public function __construct() {
        $this->clientId     = $_ENV['NUVEM_FISCAL_CLIENT_ID'];
        $this->clientSecret = $_ENV['NUVEM_FISCAL_CLIENT_SECRET'];
        $env                = $_ENV['NUVEM_FISCAL_ENV'] ?? 'sandbox';
        $this->baseUrl      = $env === 'producao'
            ? 'https://api.nuvemfiscal.com.br'
            : 'https://api.sandbox.nuvemfiscal.com.br';
        $this->ambiente     = $env === 'producao' ? 'producao' : 'homologacao';
    }

    public function getAmbiente(): string {
        return $this->ambiente;
    }

    private function getToken(): string {
        if ($this->token && time() < $this->tokenExpiry) {
            return $this->token;
        }

        $ch = curl_init('https://auth.nuvemfiscal.com.br/oauth/token');
        curl_setopt_array($ch, [
            CURLOPT_POST           => true,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POSTFIELDS     => http_build_query([
                'grant_type'    => 'client_credentials',
                'client_id'     => $this->clientId,
                'client_secret' => $this->clientSecret,
                'scope'         => 'empresa nfse cnpj cep conta',
            ]),
            CURLOPT_HTTPHEADER => ['Content-Type: application/x-www-form-urlencoded'],
        ]);

        $data = json_decode(curl_exec($ch), true);
        curl_close($ch);

        $this->token       = $data['access_token'];
        $this->tokenExpiry = time() + $data['expires_in'] - 60;
        return $this->token;
    }

    public function request(string $method, string $path, ?array $body = null): mixed {
        $token = $this->getToken();
        $ch = curl_init($this->baseUrl . $path);

        $headers = [
            'Authorization: Bearer ' . $token,
            'Content-Type: application/json',
            'Accept: application/json',
        ];

        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_CUSTOMREQUEST  => $method,
            CURLOPT_HTTPHEADER     => $headers,
        ]);

        if ($body !== null) {
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($body));
        }

        $response   = curl_exec($ch);
        $statusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($statusCode >= 400) {
            throw new Exception("NuvemFiscal API error {$statusCode}: {$response}");
        }

        return $statusCode === 204 ? null : json_decode($response, true);
    }

    public function emitirNfse(array $infDPS, ?string $referencia = null): array {
        return $this->request('POST', '/nfse/dps', [
            'ambiente'  => $this->ambiente,
            'referencia' => $referencia,
            'infDPS'    => $infDPS,
        ]);
    }

    public function consultarNfse(string $id): array {
        return $this->request('GET', "/nfse/{$id}");
    }

    public function cancelarNfse(string $id, string $motivo = ''): array {
        return $this->request('POST', "/nfse/{$id}/cancelamento", [
            'motivo' => $motivo,
        ]);
    }
}
```
