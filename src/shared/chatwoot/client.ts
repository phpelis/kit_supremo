import axios, { AxiosInstance } from 'axios';
import { 
  ChatwootContact, 
  ChatwootConversation, 
  ChatwootMessage, 
  CreateContactPayload, 
  CreateMessagePayload 
} from './types';

/**
 * Chatwoot API Client for Kit Supremo
 */
export class ChatwootClient {
  private axios: AxiosInstance;
  private accountId: number;

  constructor(config: { 
    apiUrl: string, 
    apiToken: string, 
    accountId: number 
  }) {
    this.accountId = config.accountId;
    this.axios = axios.create({
      baseURL: `${config.apiUrl}/api/v1/accounts/${config.accountId}`,
      headers: {
        'api_access_token': config.apiToken,
        'Content-Type': 'application/json'
      }
    });
  }

  // --- CONTACTS ---

  async searchContacts(query: string): Promise<ChatwootContact[]> {
    const { data } = await this.axios.get(`/contacts/search?q=${query}`);
    return data.payload;
  }

  async createContact(payload: CreateContactPayload): Promise<ChatwootContact> {
    const { data } = await this.axios.post('/contacts', payload);
    return data.payload;
  }

  async updateContact(id: number, payload: Partial<ChatwootContact>): Promise<ChatwootContact> {
    const { data } = await this.axios.put(`/contacts/${id}`, payload);
    return data.payload;
  }

  // --- CONVERSATIONS ---

  async listConversations(params?: { status?: string }): Promise<ChatwootConversation[]> {
    const { data } = await this.axios.get('/conversations', { params });
    return data.payload;
  }

  async createConversation(contactId: number, inboxId: number): Promise<ChatwootConversation> {
    const { data } = await this.axios.post('/conversations', { 
      contact_id: contactId, 
      inbox_id: inboxId 
    });
    return data;
  }

  async setConversationStatus(id: number, status: 'open' | 'resolved' | 'pending'): Promise<any> {
    const { data } = await this.axios.post(`/conversations/${id}/toggle_status`, { status });
    return data;
  }

  // --- MESSAGES ---

  async sendMessage(conversationId: number, payload: CreateMessagePayload): Promise<ChatwootMessage> {
    const { data } = await this.axios.post(`/conversations/${conversationId}/messages`, payload);
    return data;
  }

  async listMessages(conversationId: number): Promise<ChatwootMessage[]> {
    const { data } = await this.axios.get(`/conversations/${conversationId}/messages`);
    return data.payload;
  }
}

/**
 * Singleton / Default Instance for quick use
 * Requires process.env variables to be set
 */
export const chatwoot = new ChatwootClient({
  apiUrl: process.env.CHATWOOT_API_URL || 'https://app.chatwoot.com',
  apiToken: process.env.CHATWOOT_API_TOKEN || '',
  accountId: Number(process.env.CHATWOOT_ACCOUNT_ID) || 1
});
