import { PSYLLAMA_HOST } from "./config";

export type ListModelResponse = {
  name: string;
  digest: string;
  modified_at?: string;
  details?: {
    families?: string[];
  };
};

export type ListResponse = {
  models: ListModelResponse[];
};

export type ShowRequest = {
  model: string;
};

export type ShowResponse = {
  capabilities?: string[];
};

export const psyllamaClient = {
  async list(): Promise<ListResponse> {
    const res = await fetch(`${PSYLLAMA_HOST}/api/tags`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
      },
    });
    if (!res.ok) {
      throw new Error(`list failed: ${res.status}`);
    }
    return (await res.json()) as ListResponse;
  },

  async show(req: ShowRequest): Promise<ShowResponse> {
    const res = await fetch(`${PSYLLAMA_HOST}/api/show`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(req),
    });
    if (!res.ok) {
      throw new Error(`show failed: ${res.status}`);
    }
    return (await res.json()) as ShowResponse;
  },
};
