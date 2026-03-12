import { Psyllama } from "psyllama/browser";
import { PSYLLAMA_HOST } from "./config";

let _psyllamaClient: Psyllama | null = null;

export const psyllamaClient = new Proxy({} as Psyllama, {
  get(_target, prop) {
    if (!_psyllamaClient) {
      _psyllamaClient = new Psyllama({
        host: PSYLLAMA_HOST,
      });
    }
    const value = _psyllamaClient[prop as keyof Psyllama];
    return typeof value === "function" ? value.bind(_psyllamaClient) : value;
  },
});
