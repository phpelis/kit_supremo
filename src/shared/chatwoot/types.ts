export interface ChatwootContact {
  id: number;
  name: string;
  email: string;
  phone_number: string;
  thumbnail: string;
  identifier: string | null;
  additional_attributes: Record<string, any>;
  custom_attributes: Record<string, any>;
}

export interface ChatwootConversation {
  id: number;
  contact_id: number;
  inbox_id: number;
  status: 'open' | 'resolved' | 'pending' | 'snoozed';
  additional_attributes: Record<string, any>;
  custom_attributes: Record<string, any>;
  agent_id: number | null;
}

export interface ChatwootMessage {
  id: number;
  content: string;
  message_type: 'incoming' | 'outgoing' | 'template'; // 0 = incoming, 1 = outgoing
  content_type: string;
  created_at: number;
  conversation_id: number;
}

export interface ChatwootInbox {
  id: number;
  name: string;
  channel_id: number;
  channel_type: string;
  account_id: number;
}

export interface CreateContactPayload {
  inbox_id: number;
  name?: string;
  email?: string;
  phone_number?: string;
  custom_attributes?: Record<string, any>;
  identifier?: string;
}

export interface CreateMessagePayload {
  content: string;
  message_type: 'outgoing';
  private?: boolean;
  content_type?: 'text' | 'input_select' | 'cards' | 'article';
}
