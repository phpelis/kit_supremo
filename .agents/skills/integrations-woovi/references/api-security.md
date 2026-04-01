# Woovi API: Segurança e Validação de Assinaturas

A Woovi utiliza assinaturas digitais para garantir que os Webhooks recepcionados venham de origens confiáveis e não foram alterados.

## 1. Validação RSA-SHA256 (Mestre)
O header `x-webhook-signature` contém a assinatura RSA-SHA256 do payload. Esta validação garante que a Woovi (detentora da chave privada) enviou o webhook.

### Chave Pública da Woovi (PEM)
```
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC/+NtIkjzevvqD+I3MMv3bLXDt
pvxBjY4BsRrSdca3rtAwMcRYYvxSnd7jagVLpctMiOxQO8ieUCKLSWHpsMAjO/zZ
WMKbqoG8MNpi/u3fp6zz0mcHCOSqYsPUUG19buW8bis5ZZ2IZgBObWSpTvJ0cnj6
HKBAA82Jln+lGwS1MwIDAQAB
-----END PUBLIC KEY-----
```

### Exemplo de Validação (Node.js)
```javascript
const crypto = require('crypto');

function verifyWooviSignature(payload, signatureBase64) {
  const publicKeyStr = `-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC/+NtIkjzevvqD+I3MMv3bLXDt
pvxBjY4BsRrSdca3rtAwMcRYYvxSnd7jagVLpctMiOxQO8ieUCKLSWHpsMAjO/zZ
WMKbqoG8MNpi/u3fp6zz0mcHCOSqYsPUUG19buW8bis5ZZ2IZgBObWSpTvJ0cnj6
HKBAA82Jln+lGwS1MwIDAQAB
-----END PUBLIC KEY-----`;

  const verify = crypto.createVerify('SHA256');
  verify.update(payload); // payload deve ser o body bruto (string)
  verify.end();

  return verify.verify(publicKeyStr, signatureBase64, 'base64');
}
```

## 2. Validação HMAC-SHA256 (Webhook Individual)
O header `X-OpenPix-Signature` contém o HMAC assinado com o seu `Webhook Secret`. Isso valida que o webhook pertence à sua configuração específica.

### Exemplo de Validação (Node.js)
```javascript
const crypto = require('crypto');

function verifyHMAC(payload, receivedHmac, secretKey) {
  const generatedHmac = crypto
    .createHmac('sha256', secretKey)
    .update(payload)
    .digest('base64');

  return crypto.timingSafeEqual(
    Buffer.from(generatedHmac),
    Buffer.from(receivedHmac)
  );
}
```

## Melhores Práticas de Segurança
- **Sempre utilize o Body Bruto**: Não tente validar o JSON parseado, pois a ordem das chaves pode mudar e quebrar a assinatura.
- **Timing Safe Comparison**: Use `crypto.timingSafeEqual` para evitar ataques de timing na validação do HMAC.
- **Secret Hygiene**: Nunca exponha o seu Webhook Secret no frontend ou em repositórios públicos.
