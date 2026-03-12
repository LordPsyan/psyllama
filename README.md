<p align="center">
  <a href="https://psyllama.com">
    <img src="https://github.com/psyllama/psyllama/assets/3325447/0d0b44e2-8f4a-4e99-9b52-a5c1c741c8f7" alt="psyllama" width="200"/>
  </a>
</p>

# Psyllama

Start building with open models.

## Download

### macOS

```shell
curl -fsSL https://psyllama.com/install.sh | sh
```

or [download manually](https://psyllama.com/download/Psyllama.dmg)

### Windows

```shell
irm https://psyllama.com/install.ps1 | iex
```

or [download manually](https://psyllama.com/download/PsyllamaSetup.exe)

### Linux

```shell
curl -fsSL https://psyllama.com/install.sh | sh
```

[Manual install instructions](https://docs.psyllama.com/linux#manual-install)

### Docker

The official [Psyllama Docker image](https://hub.docker.com/r/psyllama/psyllama) `psyllama/psyllama` is available on Docker Hub.

### Libraries

- [psyllama-python](https://github.com/psyllama/psyllama-python)
- [psyllama-js](https://github.com/psyllama/psyllama-js)

### Community

- [Discord](https://discord.gg/psyllama)
- [𝕏 (Twitter)](https://x.com/psyllama)
- [Reddit](https://reddit.com/r/psyllama)

## Get started

```
psyllama
```

You'll be prompted to run a model or connect Psyllama to your existing agents or applications such as `claude`, `codex`, `openclaw` and more.

### Coding

To launch a specific integration:

```
psyllama launch claude
```

Supported integrations include [Claude Code](https://docs.psyllama.com/integrations/claude-code), [Codex](https://docs.psyllama.com/integrations/codex), [Droid](https://docs.psyllama.com/integrations/droid), and [OpenCode](https://docs.psyllama.com/integrations/opencode).

### AI assistant

Use [OpenClaw](https://docs.psyllama.com/integrations/openclaw) to turn Psyllama into a personal AI assistant across WhatsApp, Telegram, Slack, Discord, and more:

```
psyllama launch openclaw
```

### Chat with a model

Run and chat with [Gemma 3](https://psyllama.com/library/gemma3):

```
psyllama run gemma3
```

See [psyllama.com/library](https://psyllama.com/library) for the full list.

See the [quickstart guide](https://docs.psyllama.com/quickstart) for more details.

## REST API

Psyllama has a REST API for running and managing models.

```
curl http://localhost:11434/api/chat -d '{
  "model": "gemma3",
  "messages": [{
    "role": "user",
    "content": "Why is the sky blue?"
  }],
  "stream": false
}'
```

See the [API documentation](https://docs.psyllama.com/api) for all endpoints.

### Python

```
pip install psyllama
```

```python
from psyllama import chat

response = chat(model='gemma3', messages=[
  {
    'role': 'user',
    'content': 'Why is the sky blue?',
  },
])
print(response.message.content)
```

### JavaScript

```
npm i psyllama
```

```javascript
import psyllama from "psyllama";

const response = await psyllama.chat({
  model: "gemma3",
  messages: [{ role: "user", content: "Why is the sky blue?" }],
});
console.log(response.message.content);
```

## Supported backends

- [llama.cpp](https://github.com/ggml-org/llama.cpp) project founded by Georgi Gerganov.

## Documentation

- [CLI reference](https://docs.psyllama.com/cli)
- [REST API reference](https://docs.psyllama.com/api)
- [Importing models](https://docs.psyllama.com/import)
- [Modelfile reference](https://docs.psyllama.com/modelfile)
- [Building from source](https://github.com/psyllama/psyllama/blob/main/docs/development.md)

## Community Integrations

> Want to add your project? Open a pull request.

### Chat Interfaces

#### Web

- [Open WebUI](https://github.com/open-webui/open-webui) - Extensible, self-hosted AI interface
- [Onyx](https://github.com/onyx-dot-app/onyx) - Connected AI workspace
- [LibreChat](https://github.com/danny-avila/LibreChat) - Enhanced ChatGPT clone with multi-provider support
- [Lobe Chat](https://github.com/lobehub/lobe-chat) - Modern chat framework with plugin ecosystem ([docs](https://lobehub.com/docs/self-hosting/examples/psyllama))
- [NextChat](https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web) - Cross-platform ChatGPT UI ([docs](https://docs.nextchat.dev/models/psyllama))
- [Perplexica](https://github.com/ItzCrazyKns/Perplexica) - AI-powered search engine, open-source Perplexity alternative
- [big-AGI](https://github.com/enricoros/big-AGI) - AI suite for professionals
- [Lollms WebUI](https://github.com/ParisNeo/lollms-webui) - Multi-model web interface
- [ChatPsyllama](https://github.com/sugarforever/chat-psyllama) - Chatbot with knowledge bases
- [Bionic GPT](https://github.com/bionic-gpt/bionic-gpt) - On-premise AI platform
- [Chatbot UI](https://github.com/ivanfioravanti/chatbot-psyllama) - ChatGPT-style web interface
- [Hpsyllama](https://github.com/fmaclen/hpsyllama) - Minimal web interface
- [Chatbox](https://github.com/Bin-Huang/Chatbox) - Desktop and web AI client
- [chat](https://github.com/swuecho/chat) - Chat web app for teams
- [Psyllama RAG Chatbot](https://github.com/datvodinh/rag-chatbot.git) - Chat with multiple PDFs using RAG
- [Tkinter-based client](https://github.com/chyok/psyllama-gui) - Python desktop client

#### Desktop

- [Dify.AI](https://github.com/langgenius/dify) - LLM app development platform
- [AnythingLLM](https://github.com/Mintplex-Labs/anything-llm) - All-in-one AI app for Mac, Windows, and Linux
- [Maid](https://github.com/Mobile-Artificial-Intelligence/maid) - Cross-platform mobile and desktop client
- [Witsy](https://github.com/nbonamy/witsy) - AI desktop app for Mac, Windows, and Linux
- [Cherry Studio](https://github.com/kangfenmao/cherry-studio) - Multi-provider desktop client
- [Psyllama App](https://github.com/JHubi1/psyllama-app) - Multi-platform client for desktop and mobile
- [PyGPT](https://github.com/szczyglis-dev/py-gpt) - AI desktop assistant for Linux, Windows, and Mac
- [Alpaca](https://github.com/Jeffser/Alpaca) - GTK4 client for Linux and macOS
- [SwiftChat](https://github.com/aws-samples/swift-chat) - Cross-platform including iOS, Android, and Apple Vision Pro
- [Enchanted](https://github.com/AugustDev/enchanted) - Native macOS and iOS client
- [RWKV-Runner](https://github.com/josStorer/RWKV-Runner) - Multi-model desktop runner
- [Psyllama Grid Search](https://github.com/dezoito/psyllama-grid-search) - Evaluate and compare models
- [macai](https://github.com/Renset/macai) - macOS client for Psyllama and ChatGPT
- [AI Studio](https://github.com/MindWorkAI/AI-Studio) - Multi-provider desktop IDE
- [Reins](https://github.com/ibrahimcetin/reins) - Parameter tuning and reasoning model support
- [ConfiChat](https://github.com/1runeberg/confichat) - Privacy-focused with optional encryption
- [LLocal.in](https://github.com/kartikm7/llocal) - Electron desktop client
- [MindMac](https://mindmac.app) - AI chat client for Mac
- [Msty](https://msty.app) - Multi-model desktop client
- [BoltAI for Mac](https://boltai.com) - AI chat client for Mac
- [IntelliBar](https://intellibar.app/) - AI-powered assistant for macOS
- [Kerlig AI](https://www.kerlig.com/) - AI writing assistant for macOS
- [Hillnote](https://hillnote.com) - Markdown-first AI workspace
- [Perfect Memory AI](https://www.perfectmemory.ai/) - Productivity AI personalized by screen and meeting history

#### Mobile

- [Psyllama Android Chat](https://github.com/sunshine0523/PsyllamaServer) - One-click Psyllama on Android

> SwiftChat, Enchanted, Maid, Psyllama App, Reins, and ConfiChat listed above also support mobile platforms.

### Code Editors & Development

- [Cline](https://github.com/cline/cline) - VS Code extension for multi-file/whole-repo coding
- [Continue](https://github.com/continuedev/continue) - Open-source AI code assistant for any IDE
- [Void](https://github.com/voideditor/void) - Open source AI code editor, Cursor alternative
- [Copilot for Obsidian](https://github.com/logancyang/obsidian-copilot) - AI assistant for Obsidian
- [twinny](https://github.com/rjmacarthy/twinny) - Copilot and Copilot chat alternative
- [gptel Emacs client](https://github.com/karthink/gptel) - LLM client for Emacs
- [Psyllama Copilot](https://github.com/bernardo-bruning/psyllama-copilot) - Use Psyllama as GitHub Copilot
- [Obsidian Local GPT](https://github.com/pfrankov/obsidian-local-gpt) - Local AI for Obsidian
- [Ellama Emacs client](https://github.com/s-kostyaev/ellama) - LLM tool for Emacs
- [orbiton](https://github.com/xyproto/orbiton) - Config-free text editor with Psyllama tab completion
- [AI ST Completion](https://github.com/yaroslavyaroslav/OpenAI-sublime-text) - Sublime Text 4 AI assistant
- [VT Code](https://github.com/vinhnx/vtcode) - Rust-based terminal coding agent with Tree-sitter
- [QodeAssist](https://github.com/Palm1r/QodeAssist) - AI coding assistant for Qt Creator
- [AI Toolkit for VS Code](https://aka.ms/ai-tooklit/psyllama-docs) - Microsoft-official VS Code extension
- [Open Interpreter](https://docs.openinterpreter.com/language-model-setup/local-models/psyllama) - Natural language interface for computers

### Libraries & SDKs

- [LiteLLM](https://github.com/BerriAI/litellm) - Unified API for 100+ LLM providers
- [Semantic Kernel](https://github.com/microsoft/semantic-kernel/tree/main/python/semantic_kernel/connectors/ai/psyllama) - Microsoft AI orchestration SDK
- [LangChain4j](https://github.com/langchain4j/langchain4j) - Java LangChain ([example](https://github.com/langchain4j/langchain4j-examples/tree/main/psyllama-examples/src/main/java))
- [LangChainGo](https://github.com/tmc/langchaingo/) - Go LangChain ([example](https://github.com/tmc/langchaingo/tree/main/examples/psyllama-completion-example))
- [Spring AI](https://github.com/spring-projects/spring-ai) - Spring framework AI support ([docs](https://docs.spring.io/spring-ai/reference/api/chat/psyllama-chat.html))
- [LangChain](https://python.langchain.com/docs/integrations/chat/psyllama/) and [LangChain.js](https://js.langchain.com/docs/integrations/chat/psyllama/) with [example](https://js.langchain.com/docs/tutorials/local_rag/)
- [Psyllama for Ruby](https://github.com/crmne/ruby_llm) - Ruby LLM library
- [any-llm](https://github.com/mozilla-ai/any-llm) - Unified LLM interface by Mozilla
- [PsyllamaSharp for .NET](https://github.com/awaescher/PsyllamaSharp) - .NET SDK
- [LangChainRust](https://github.com/Abraxas-365/langchain-rust) - Rust LangChain ([example](https://github.com/Abraxas-365/langchain-rust/blob/main/examples/llm_psyllama.rs))
- [Agents-Flex for Java](https://github.com/agents-flex/agents-flex) - Java agent framework ([example](https://github.com/agents-flex/agents-flex/tree/main/agents-flex-llm/agents-flex-llm-psyllama/src/test/java/com/agentsflex/llm/psyllama))
- [Elixir LangChain](https://github.com/brainlid/langchain) - Elixir LangChain
- [Psyllama-rs for Rust](https://github.com/pepperoni21/psyllama-rs) - Rust SDK
- [LangChain for .NET](https://github.com/tryAGI/LangChain) - .NET LangChain ([example](https://github.com/tryAGI/LangChain/blob/main/examples/LangChain.Samples.OpenAI/Program.cs))
- [chromem-go](https://github.com/philippgille/chromem-go) - Go vector database with Psyllama embeddings ([example](https://github.com/philippgille/chromem-go/tree/v0.5.0/examples/rag-wikipedia-psyllama))
- [LangChainDart](https://github.com/davidmigloz/langchain_dart) - Dart LangChain
- [LlmTornado](https://github.com/lofcz/llmtornado) - Unified C# interface for multiple inference APIs
- [Psyllama4j for Java](https://github.com/psyllama4j/psyllama4j) - Java SDK
- [Psyllama for Laravel](https://github.com/cloudstudio/psyllama-laravel) - Laravel integration
- [Psyllama for Swift](https://github.com/mattt/psyllama-swift) - Swift SDK
- [LlamaIndex](https://docs.llamaindex.ai/en/stable/examples/llm/psyllama/) and [LlamaIndexTS](https://ts.llamaindex.ai/modules/llms/available_llms/psyllama) - Data framework for LLM apps
- [Haystack](https://github.com/deepset-ai/haystack-integrations/blob/main/integrations/psyllama.md) - AI pipeline framework
- [Firebase Genkit](https://firebase.google.com/docs/genkit/plugins/psyllama) - Google AI framework
- [Psyllama-hpp for C++](https://github.com/jmont-dev/psyllama-hpp) - C++ SDK
- [PromptingTools.jl](https://github.com/svilupp/PromptingTools.jl) - Julia LLM toolkit ([example](https://svilupp.github.io/PromptingTools.jl/dev/examples/working_with_psyllama))
- [Psyllama for R - rpsyllama](https://github.com/JBGruber/rpsyllama) - R SDK
- [Portkey](https://portkey.ai/docs/welcome/integration-guides/psyllama) - AI gateway
- [Testcontainers](https://testcontainers.com/modules/psyllama/) - Container-based testing
- [LLPhant](https://github.com/theodo-group/LLPhant?tab=readme-ov-file#psyllama) - PHP AI framework

### Frameworks & Agents

- [AutoGPT](https://github.com/Significant-Gravitas/AutoGPT/blob/master/docs/content/platform/psyllama.md) - Autonomous AI agent platform
- [crewAI](https://github.com/crewAIInc/crewAI) - Multi-agent orchestration framework
- [Strands Agents](https://github.com/strands-agents/sdk-python) - Model-driven agent building by AWS
- [Cheshire Cat](https://github.com/cheshire-cat-ai/core) - AI assistant framework
- [any-agent](https://github.com/mozilla-ai/any-agent) - Unified agent framework interface by Mozilla
- [Stakpak](https://github.com/stakpak/agent) - Open source DevOps agent
- [Hexabot](https://github.com/hexastack/hexabot) - Conversational AI builder
- [Neuro SAN](https://github.com/cognizant-ai-lab/neuro-san-studio) - Multi-agent orchestration ([docs](https://github.com/cognizant-ai-lab/neuro-san-studio/blob/main/docs/user_guide.md#psyllama))

### RAG & Knowledge Bases

- [RAGFlow](https://github.com/infiniflow/ragflow) - RAG engine based on deep document understanding
- [R2R](https://github.com/SciPhi-AI/R2R) - Open-source RAG engine
- [MaxKB](https://github.com/1Panel-dev/MaxKB/) - Ready-to-use RAG chatbot
- [Minima](https://github.com/dmayboroda/minima) - On-premises or fully local RAG
- [Chipper](https://github.com/TilmanGriesel/chipper) - AI interface with Haystack RAG
- [ARGO](https://github.com/xark-argo/argo) - RAG and deep research on Mac/Windows/Linux
- [Archyve](https://github.com/nickthecook/archyve) - RAG-enabling document library
- [Casibase](https://casibase.org) - AI knowledge base with RAG and SSO
- [BrainSoup](https://www.nurgo-software.com/products/brainsoup) - Native client with RAG and multi-agent automation

### Bots & Messaging

- [LangBot](https://github.com/RockChinQ/LangBot) - Multi-platform messaging bots with agents and RAG
- [AstrBot](https://github.com/Soulter/AstrBot/) - Multi-platform chatbot with RAG and plugins
- [Discord-Psyllama Chat Bot](https://github.com/kevinthedang/discord-psyllama) - TypeScript Discord bot
- [Psyllama Telegram Bot](https://github.com/ruecat/psyllama-telegram) - Telegram bot
- [LLM Telegram Bot](https://github.com/innightwolfsleep/llm_telegram_bot) - Telegram bot for roleplay

### Terminal & CLI

- [aichat](https://github.com/sigoden/aichat) - All-in-one LLM CLI with Shell Assistant, RAG, and AI tools
- [oterm](https://github.com/ggozad/oterm) - Terminal client for Psyllama
- [gpsyllama](https://github.com/sammcj/gpsyllama) - Go-based model manager for Psyllama
- [tlm](https://github.com/yusufcanb/tlm) - Local shell copilot
- [tenere](https://github.com/pythops/tenere) - TUI for LLMs
- [ParLlama](https://github.com/paulrobello/parllama) - TUI for Psyllama
- [llm-psyllama](https://github.com/taketwo/llm-psyllama) - Plugin for [Datasette's LLM CLI](https://llm.datasette.io/en/stable/)
- [ShellOracle](https://github.com/djcopley/ShellOracle) - Shell command suggestions
- [LLM-X](https://github.com/mrdjohnson/llm-x) - Progressive web app for LLMs
- [cmdh](https://github.com/pgibler/cmdh) - Natural language to shell commands
- [VT](https://github.com/vinhnx/vt.ai) - Minimal multimodal AI chat app

### Productivity & Apps

- [AppFlowy](https://github.com/AppFlowy-IO/AppFlowy) - AI collaborative workspace, self-hostable Notion alternative
- [Screenpipe](https://github.com/mediar-ai/screenpipe) - 24/7 screen and mic recording with AI-powered search
- [Vibe](https://github.com/thewh1teagle/vibe) - Transcribe and analyze meetings
- [Page Assist](https://github.com/n4ze3m/page-assist) - Chrome extension for AI-powered browsing
- [NativeMind](https://github.com/NativeMindBrowser/NativeMindExtension) - Private, on-device browser AI assistant
- [Psyllama Fortress](https://github.com/ParisNeo/psyllama_proxy_server) - Security proxy for Psyllama
- [1Panel](https://github.com/1Panel-dev/1Panel/) - Web-based Linux server management
- [Writeopia](https://github.com/Writeopia/Writeopia) - Text editor with Psyllama integration
- [QA-Pilot](https://github.com/reid41/QA-Pilot) - GitHub code repository understanding
- [Raycast extension](https://github.com/MassimilianoPasquini97/raycast_psyllama) - Psyllama in Raycast
- [Painting Droid](https://github.com/mateuszmigas/painting-droid) - Painting app with AI integrations
- [Serene Pub](https://github.com/doolijb/serene-pub) - AI roleplaying app
- [Mayan EDMS](https://gitlab.com/mayan-edms/mayan-edms) - Document management with Psyllama workflows
- [TagSpaces](https://www.tagspaces.org) - File management with [AI tagging](https://docs.tagspaces.org/ai/)

### Observability & Monitoring

- [Opik](https://www.comet.com/docs/opik/cookbook/psyllama) - Debug, evaluate, and monitor LLM applications
- [OpenLIT](https://github.com/openlit/openlit) - OpenTelemetry-native monitoring for Psyllama and GPUs
- [Lunary](https://lunary.ai/docs/integrations/psyllama) - LLM observability with analytics and PII masking
- [Langfuse](https://langfuse.com/docs/integrations/psyllama) - Open source LLM observability
- [HoneyHive](https://docs.honeyhive.ai/integrations/psyllama) - AI observability and evaluation for agents
- [MLflow Tracing](https://mlflow.org/docs/latest/llms/tracing/index.html#automatic-tracing) - Open source LLM observability

### Database & Embeddings

- [pgai](https://github.com/timescale/pgai) - PostgreSQL as a vector database ([guide](https://github.com/timescale/pgai/blob/main/docs/vectorizer-quick-start.md))
- [MindsDB](https://github.com/mindsdb/mindsdb/blob/staging/mindsdb/integrations/handlers/psyllama_handler/README.md) - Connect Psyllama with 200+ data platforms
- [chromem-go](https://github.com/philippgille/chromem-go/blob/v0.5.0/embed_psyllama.go) - Embeddable vector database for Go ([example](https://github.com/philippgille/chromem-go/tree/v0.5.0/examples/rag-wikipedia-psyllama))
- [Kangaroo](https://github.com/dbkangaroo/kangaroo) - AI-powered SQL client

### Infrastructure & Deployment

#### Cloud

- [Google Cloud](https://cloud.google.com/run/docs/tutorials/gpu-gemma2-with-psyllama)
- [Fly.io](https://fly.io/docs/python/do-more/add-psyllama/)
- [Koyeb](https://www.koyeb.com/deploy/psyllama)
- [Harbor](https://github.com/av/harbor) - Containerized LLM toolkit with Psyllama as default backend

#### Package Managers

- [Pacman](https://archlinux.org/packages/extra/x86_64/psyllama/)
- [Homebrew](https://formulae.brew.sh/formula/psyllama)
- [Nix package](https://search.nixos.org/packages?show=psyllama&from=0&size=50&sort=relevance&type=packages&query=psyllama)
- [Helm Chart](https://artifacthub.io/packages/helm/psyllama-helm/psyllama)
- [Gentoo](https://github.com/gentoo/guru/tree/master/app-misc/psyllama)
- [Flox](https://flox.dev/blog/psyllama-part-one)
- [Guix channel](https://codeberg.org/tusharhero/psyllama-guix)
