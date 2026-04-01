import crypto from 'crypto';

/**
 * Webhook validation logic for Chatwoot
 * 
 * Signature: The x-chatwoot-signature header contains the HMAC-SHA256 signature
 * calculated using the webhook secret.
 */
export class ChatwootWebhooks {
  /**
   * Validates the HMAC signature sent by Chatwoot
   * 
   * @param payload Stringified body of the webhook
   * @param signature The x-chatwoot-signature header value
   * @param secret The webhook secret from Chatwoot settings
   */
  static validateSignature(payload: string, signature: string, secret: string): boolean {
    if (!signature || !secret) return false;

    const hash = crypto
      .createHmac('sha256', secret)
      .update(payload)
      .digest('hex');

    // Use timingSafeEqual to prevent timing attacks
    const hashBuffer = Buffer.from(hash, 'hex');
    const signatureBuffer = Buffer.from(signature, 'hex');

    if (hashBuffer.length !== signatureBuffer.length) return false;

    return crypto.timingSafeEqual(hashBuffer, signatureBuffer);
  }

  /**
   * Identifies the event type of the incoming webhook
   */
  static getEvent(body: any): string | undefined {
    return body?.event;
  }
}

/**
 * Common payload interfaces for convenient destructing
 */

export interface ChatwootWebhookPayload {
  event: 'message_created' | 'conversation_created' | 'contact_created' | 'conversation_status_changed';
  account: { id: number };
  inbox: { id: number, name: string };
  conversation: { id: number, status: string };
  contact: { id: number, name: string, email: string };
}
