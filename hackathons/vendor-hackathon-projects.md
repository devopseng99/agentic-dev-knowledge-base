# Vendor Hackathon Projects

> Compiled 2026-05-07. 100+ real hackathon projects from major cloud/AI vendors, sourced from
> Devpost, HuggingFace, GitHub, vendor blogs, and lablab.ai.

---

## Anthropic Hackathons

### Everything Claude Code
- **Hackathon**: Built with Opus 4.6 (Claude Code Hackathon) by Anthropic x Cerebral Valley (Feb 2026)
- **Description**: The winning project of the first official Anthropic virtual hackathon. A performance optimization harness for AI agents, covering skills, instincts, memory, continuous learning, security scanning, and research-first development. Hit 900K+ views on X within days of release and became one of the fastest-growing AI repos.
- **Stack**: Claude Code, Python, agent harness patterns
- **GitHub**: https://github.com/affaan-m/everything-claude-code
- **Demo**: N/A
- **Problem Solved**: Optimizes Claude Code agent behavior and performance across complex multi-step tasks.

### MedKit
- **Hackathon**: Built with Opus 4.7 (Global Virtual Hackathon) by Anthropic x Cerebral Valley (2025)
- **Description**: Gold prize winner built by a doctor in Istanbul. A voice-based clinical simulator allowing medical students to practice patient histories, diagnostics, and clinical reasoning interactively. Claude evaluates responses in real time.
- **Stack**: Claude Code, Python, voice interfaces
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Medical education lacks accessible, realistic patient-encounter practice environments.

### Maieutic
- **Hackathon**: Built with Opus 4.7 by Anthropic x Cerebral Valley (2025)
- **Description**: Bronze prize winner built by a CS teacher in Concepción, Chile. An educational coding platform that requires students to explain what they intend to build before writing any code; Claude evaluates whether the student's explanation holds up before unlocking the coding step.
- **Stack**: Claude Code, Python
- **GitHub**: N/A
- **Demo**: https://maieutic.dev
- **Problem Solved**: Students skip reasoning and jump straight to copying code, undermining comprehension.

### Wrench Board
- **Hackathon**: Built with Opus 4.7 by Anthropic x Cerebral Valley (2025)
- **Description**: Silver prize winner built by a former microsoldering technician in the French Alps. An AI diagnostic tool for board-level electronics repair providing step-by-step guided troubleshooting.
- **Stack**: Claude Code, circuit analysis
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Independent repair shops lack access to expert-level electronics diagnostics.

### ARIA (Agentic Reliability & Intelligence Architecture)
- **Hackathon**: Built with Opus 4.7 by Anthropic x Cerebral Valley (2025)
- **Description**: Best Use of Managed Agents prize. A multi-agent system using five specialized agents communicating through 17 shared tools to predict equipment failures in industrial settings. Addresses knowledge retention when experienced factory operators retire.
- **Stack**: Claude Managed Agents, Python sandboxing, tool orchestration
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Critical factory knowledge is lost when experienced operators leave, causing undetected equipment failures.

### Virtual Puppet Theater
- **Hackathon**: Built with Opus 4.7 by Anthropic x Cerebral Valley (2025)
- **Description**: Most Creative prize. A webcam and voice-driven puppet show with dynamic prop generation, letting users perform live puppet theater with AI-generated characters and environments.
- **Stack**: Claude Code, web technologies, webcam APIs
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Explores creative AI-human collaboration in live performance contexts.

### MaestrIA
- **Hackathon**: Built with Opus 4.7 by Anthropic x Cerebral Valley (2025)
- **Description**: Keep Thinking Prize. A home repair tool that diagnoses damage, prices parts, and drafts contractor messages—all from a photo of the problem area.
- **Stack**: Claude Code
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Homeowners lack the expertise to diagnose home repair issues or estimate costs.

### Robotic Arm Control via Instruction Manual
- **Hackathon**: Builder Day Hackathon by Anthropic x Menlo Ventures (Nov 2024)
- **Description**: First-place winner. Used Claude's computer use capability to control an Amazon robot arm solely by uploading the arm's instruction manual—no custom code for the arm. Claude read the manual, reasoned about commands, and operated the hardware.
- **Stack**: Claude computer use, Amazon robotics hardware
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Robotics programming requires deep hardware-specific expertise; this eliminates that barrier.

### AI Agent Captcha Honeypot
- **Hackathon**: Builder Day Hackathon by Anthropic x Menlo Ventures (Nov 2024)
- **Description**: Second-place winner. An anti-captcha system that detects when Claude's computer use is being used to solve a verification puzzle, creating a "honeypot" that catches autonomous AI agents.
- **Stack**: Claude computer use, captcha detection
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Existing CAPTCHAs are increasingly solvable by AI agents, undermining bot detection.

### PRD Debate Agent
- **Hackathon**: Builder Day Hackathon by Anthropic x Menlo Ventures (Nov 2024)
- **Description**: Third-place winner. Claude Haiku agents role-play as UX lead, data scientist, finance manager, and CEO to debate and improve a product requirements document, then a final agent synthesizes the improved PRD in under one minute.
- **Stack**: Claude Haiku, multi-agent orchestration
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: PRD reviews are slow and miss cross-functional perspectives; this automates structured critique.

### Bulletpapers.ai
- **Hackathon**: Anthropic London Hackathon by Anthropic (2024)
- **Description**: Summarizes and visualizes research papers with AI, turning dense academic content into scannable bullet-point summaries with visual aids.
- **Stack**: Claude API
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Research papers are dense and time-consuming; this extracts key findings instantly.

### DocPilot
- **Hackathon**: Anthropic London Hackathon by Anthropic (2024)
- **Description**: A GitHub bot that automatically generates docstrings and documentation for codebases, triggered on pull requests.
- **Stack**: Claude API, GitHub Actions
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Codebases often lack documentation; this automates it at PR time.

### HealthECHO
- **Hackathon**: Anthropic London Hackathon by Anthropic (2024)
- **Description**: An AI co-diagnostician that transcribes doctor-patient consultations in real time, highlights key symptoms, and provides supporting medical insights and differential suggestions.
- **Stack**: Claude API, speech-to-text
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Physicians miss documentation details during consultations and lack real-time decision support.

### Aletheia
- **Hackathon**: Anthropic London Hackathon by Anthropic (2024)
- **Description**: A multi-perspective article aggregator that surfaces bias evaluations, showing users how different news outlets frame the same story.
- **Stack**: Claude API, news aggregation
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: News consumers are exposed to biased framing without realizing it.

### Agent of Death
- **Hackathon**: Anthropic London Hackathon by Anthropic (2024)
- **Description**: An account-cancellation service for the digital accounts of deceased individuals, automating the process of notifying and closing services like social media, subscriptions, and banking.
- **Stack**: Claude API, web automation
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Families of deceased persons face a complex, manual process of closing dozens of online accounts.

---

## AWS Hackathons

### VCT Team Builder
- **Hackathon**: VCT Hackathon: Esports Manager Challenge by AWS x Riot Games (2024)
- **Description**: First-place winner ($61K prize pool). An LLM-powered digital assistant with a clean UI for scouting VALORANT Champions Tour talent, building teams, analyzing agent capabilities by map, and generating strategic recommendations.
- **Stack**: Amazon Bedrock, Llama/Claude models, React, data visualization
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Esports team managers need intelligent tools to scout, compare, and build competitive rosters from thousands of player records.

### VCT Scout
- **Hackathon**: VCT Hackathon: Esports Manager Challenge by AWS x Riot Games (2024)
- **Description**: Second-place winner. Provides esports managers with AI-powered player discovery, filtering by role, region, agent pool, and recent performance stats.
- **Stack**: Amazon Bedrock, AWS services, data APIs
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Scouting talent across global VCT circuits is time-consuming without intelligent search tools.

### VCT Manager Assistant
- **Hackathon**: VCT Hackathon: Esports Manager Challenge by AWS x Riot Games (2024)
- **Description**: Third-place winner. Conversational AI assistant helping managers answer detailed tactical questions about VALORANT Esports players and build strategies.
- **Stack**: Amazon Bedrock, AWS Lambda, DynamoDB
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Tactical preparation for esports teams lacks AI-powered analysis tools.

### Parable Rhythm - The Interactive Crime Thriller
- **Hackathon**: PartyRock Generative AI Hackathon by AWS (2024)
- **Description**: Overall first-place winner. An interactive AI-powered crime thriller where players take the role of a detective in the city of Genai, reviewing witness statements, crime reports, and evidence to solve cases using generative AI.
- **Stack**: Amazon PartyRock (Amazon Bedrock), no-code generative AI
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Interactive narrative gaming experiences that adapt to player decisions, demonstrating PartyRock's no-code generative AI capabilities.

### RAGIS (Retrieval-Augmented Generation Incident Summary)
- **Hackathon**: HackAI Challenge 2024 by Dell x NVIDIA (with AWS tools)
- **Description**: A security analysis tool integrating generative AI with enterprise data sources (Microsoft Entra ID, closed incident records) to help security teams identify false positives and prioritize real threats automatically.
- **Stack**: LangChain, Gradio, NVIDIA NIM, NVIDIA AI Workbench
- **GitHub**: https://devpost.com/software/ragis
- **Demo**: N/A
- **Problem Solved**: Security teams are overwhelmed with alert noise; this filters false positives intelligently.

### Txt2App
- **Hackathon**: HackAI Challenge 2024 by Dell x NVIDIA
- **Description**: Transforms plain-text app descriptions into fully functional mobile applications using LLMs and NVIDIA AI Workbench, allowing non-developers to build apps by describing them.
- **Stack**: LLMs, NVIDIA AI Workbench, mobile app generation
- **GitHub**: https://devpost.com/software/txt2app
- **Demo**: N/A
- **Problem Solved**: Mobile app development requires deep technical expertise; this lowers the barrier to near zero.

### CaptionCraft
- **Hackathon**: HackAI Challenge 2024 by Dell x NVIDIA
- **Description**: Automated social media caption generator where users upload photos to receive tone-customizable, keyword-enriched captions optimized for engagement.
- **Stack**: Salesforce BLIP image captioning, Mistral NeMo 12B, NVIDIA AI Workbench
- **GitHub**: https://devpost.com/software/captioncraft-5wc4b9
- **Demo**: N/A
- **Problem Solved**: Content creators spend excessive time writing captions; this automates personalized caption generation.

---

## Azure / Microsoft Hackathons

### RiskWise: Supply Chain Risk Analysis System
- **Hackathon**: AI Agents Hackathon 2025 by Microsoft (April 2025)
- **Description**: Best Overall winner ($20K prize). Identifies and analyzes risks in global supply chains by processing vast data streams to flag potential disruptions—port delays, geopolitical events, weather—and provides real-time decision support.
- **Stack**: Python, React/Next.js, Azure AI Agent Service, Semantic Kernel, SQL
- **GitHub**: N/A (Issue #526)
- **Demo**: N/A
- **Problem Solved**: Businesses lack proactive, real-time visibility into supply chain disruptions before they cause operational damage.

### Apollo - Deep Research Meta Agent
- **Hackathon**: AI Agents Hackathon 2025 by Microsoft (April 2025)
- **Description**: Best C# Agent ($5K prize). Orchestrates multiple specialized sub-agents to transform complex research queries into comprehensive reports using self-reflective RAG and multi-agent collaboration.
- **Stack**: C# (.NET 7/ASP.NET Core), Semantic Kernel, Azure AI Agent Service, GPT-4, React, PostgreSQL (vector DB)
- **GitHub**: N/A (Issue #681)
- **Demo**: N/A
- **Problem Solved**: Research synthesis across disparate sources takes countless hours; this automates it with specialized agent teams.

### WorkWizee
- **Hackathon**: AI Agents Hackathon 2025 by Microsoft (April 2025)
- **Description**: Best Copilot Agent. Manages P1/P2 incident calls by automating repetitive workflow tasks across Jira, ServiceNow, and Confluence inside Microsoft Teams, saving up to 40% of incident management time.
- **Stack**: Microsoft 365 Copilot Studio, Python, Azure Functions, Jira API, Confluence API, Outlook API
- **GitHub**: N/A (Issue #587)
- **Demo**: N/A
- **Problem Solved**: Incident management involves high-volume repetitive cross-tool tasks that interrupt engineers.

### ModelProof: Sentinel AI Chat
- **Hackathon**: AI Agents Hackathon 2025 by Microsoft (April 2025)
- **Description**: Best JavaScript/TypeScript Agent. Validates AI outputs through dual-LLM consistency checks and real-time auditing for hallucinations, bias, and toxicity, reporting transparent risk scores per response.
- **Stack**: JavaScript/TypeScript, Azure OpenAI dual-LLM, AI content moderation
- **GitHub**: N/A (Issue #517)
- **Demo**: N/A
- **Problem Solved**: AI outputs lack trusted verification; this acts as a safety officer for LLM responses.

### TARIFFED!
- **Hackathon**: AI Agents Hackathon 2025 by Microsoft (April 2025)
- **Description**: Best Use of Azure AI Agent Service. Makes complex tariff schedules accessible by using AI agents to answer trade policy questions and visualize tariff impact on supply chains.
- **Stack**: Azure AI Agent Service, Azure OpenAI (GPT-4), Bing Search, C# (.NET 9, Blazor), SQL Server, Docker
- **GitHub**: N/A (Issue #349)
- **Demo**: N/A
- **Problem Solved**: Trade policy professionals cannot quickly parse thousands of tariff schedule pages.

### Konveyor: AI-Powered Knowledge Transfer Agent
- **Hackathon**: AI Agents Hackathon 2025 by Microsoft (April 2025)
- **Description**: Best Python Agent. Ingests organizational documents and enables AI-powered Q&A on accumulated knowledge, preventing knowledge loss during team transitions and accelerating onboarding.
- **Stack**: Python, Semantic Kernel, OpenAI, vector database
- **GitHub**: N/A (Issue #645)
- **Demo**: N/A
- **Problem Solved**: Employee transitions cause catastrophic knowledge loss; this preserves and makes expertise queryable.

### Bits2Brain: Personalized Wellness Agent
- **Hackathon**: AI Agents Hackathon 2025 by Microsoft (April 2025)
- **Description**: Best Java Agent. Captures fragmented knowledge snippets and connects them into interactive Knowledge Star Maps with AI-powered node expansion and cognitive completion features.
- **Stack**: Langchain4j, Azure Video Indexer, Azure Computer Vision, Neo4j, Java, JavaScript
- **GitHub**: N/A (Issue #638)
- **Demo**: N/A
- **Problem Solved**: Information overload prevents learners from building structured, connected knowledge graphs.

### UHIRED
- **Hackathon**: Microsoft Developers Azure AI & Azure Cosmos DB Learning Hackathon (2024)
- **Description**: First-place winner. An interview preparation platform that transforms job descriptions into personalized practice sessions with real-time AI feedback on responses.
- **Stack**: Azure Cosmos DB, Azure AI services, GPT models
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Job candidates miss opportunities due to poor interview preparation and lack of personalized coaching.

### VISOUNDAY
- **Hackathon**: Microsoft Developers Azure AI & Azure Cosmos DB Learning Hackathon (2024)
- **Description**: Second-place winner. A video editing enhancement tool that recommends music tracks, generates cover images, and analyzes video content using AI.
- **Stack**: Azure services, GPT-4 Vision
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Video creators spend significant time on post-production tasks that AI can automate.

### Foodi Copilot
- **Hackathon**: Microsoft Developers Azure AI & Azure Cosmos DB Learning Hackathon (2024)
- **Description**: Third-place winner. A dietary assistant that suggests recipes, simplifies nutrition labels, and analyzes food products from images or text descriptions.
- **Stack**: Azure AI, GPT models, Azure Cosmos DB
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Consumers struggle with complex nutrition information, especially during grocery shopping.

### DocAssistant.Charty
- **Hackathon**: RAGHack 2024 by Microsoft (Sept 2024)
- **Description**: Best Overall winner. Ingests Azure SQL database schemas by indexing them with Azure AI Search, enabling natural language queries over complex enterprise database structures.
- **Stack**: Azure SQL, Azure AI Search, RAG architecture
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Enterprise developers and analysts struggle to query complex database schemas without expert SQL knowledge.

### StoryWeave
- **Hackathon**: RAGHack 2024 by Microsoft (Sept 2024)
- **Description**: Best Python winner. An interactive text-based game that ingests a story (e.g., "Beauty and the Beast"), chunks it into paragraphs, vectorizes them in Azure Database for PostgreSQL, and generates adaptive narrative experiences.
- **Stack**: Azure Database for PostgreSQL, Azure OpenAI, Python, vector search
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Interactive storytelling needs dynamic narrative generation grounded in source material.

### MyFitnessBuddy
- **Hackathon**: RAGHack 2024 by Microsoft (Sept 2024)
- **Description**: Best Azure AI Studio winner. Provides personalized workout and meal plans by combining traditional RAG (Azure AI Search) with Graph RAG (Gremlin API + Azure Cosmos DB) for connected nutritional and fitness knowledge.
- **Stack**: Azure AI Search, Azure Cosmos DB Gremlin API, Azure AI Studio, Graph RAG
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Generic fitness apps fail to account for individual goals, dietary restrictions, and interconnected health variables.

### ChatEDU
- **Hackathon**: Microsoft AI Classroom Hackathon (2024)
- **Description**: First-place winner. Transforms any text or file into an immersive personalized tutoring experience offering study guides, multiple-choice tests, long-answer formats, and context-driven learning sessions.
- **Stack**: Azure AI services, Azure Databases
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Students lack personalized, adaptive study tools that work with their own course material.

### Accounts Payable Payment Prediction
- **Hackathon**: HackTogether: The Microsoft Fabric Global AI Hack (2024)
- **Description**: Uses Accounts Payable data from ERP systems to predict payment status of unpaid invoices through a medallion lakehouse architecture, with results surfaced in Power BI dashboards.
- **Stack**: Microsoft Fabric, Azure notebooks, Power BI
- **GitHub**: https://github.com/aboerger/Fabric-Hackathon-AP-Payment-Prediction
- **Demo**: N/A
- **Problem Solved**: Finance teams lack predictive visibility into which invoices will be paid late, hindering cash flow planning.

---

## Google / GCP Hackathons

### Jayu
- **Hackathon**: Gemini API Developer Competition by Google (May–Aug 2024)
- **Description**: Best Overall App winner (custom electric 1981 DeLorean grand prize). An AI-powered personal assistant integrating with browsers, code editors, music streams, and games; interprets visual information, interacts with application interfaces, and performs real-time translations.
- **Stack**: Gemini API, multimodal capabilities
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Users need a universal AI assistant that works across all their applications seamlessly.

### Vite Vere
- **Hackathon**: Gemini API Developer Competition by Google (2024)
- **Description**: Most Impactful & People's Choice winner. Assists people with cognitive disabilities in achieving greater independence by providing AI-powered personalized step-by-step guidance for everyday tasks using Gemini's visual understanding.
- **Stack**: Gemini API (visual understanding + prompt engineering)
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: People with cognitive disabilities struggle with everyday tasks that require sequential reasoning and planning.

### Gaze Link
- **Hackathon**: Gemini API Developer Competition by Google (2024)
- **Description**: Best Android App winner. An eye-tracking Android app that uses Gemini to interpret a caretaker's questions and generate full sentence responses for individuals with ALS based on gaze input.
- **Stack**: Android, Gemini API, eye-tracking hardware
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: ALS patients lose the ability to speak but retain eye movement; this converts gaze into full communication.

### Prospera
- **Hackathon**: Gemini API Developer Competition by Google (2024)
- **Description**: Most Useful & Best Flutter App winner. A real-time AI sales coach analyzing live sales conversations and providing immediate feedback and performance reports via Flutter.
- **Stack**: Flutter, Gemini API
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Sales professionals lack real-time coaching and objective performance feedback during calls.

### ViddyScribe
- **Hackathon**: Gemini API Developer Competition by Google (2024)
- **Description**: Best Web App winner. Automatically adds audio descriptions to videos, making them more accessible to people who are blind or visually impaired.
- **Stack**: Web platform, Gemini API
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: The vast majority of online videos lack audio descriptions for visually impaired viewers.

### Trippy
- **Hackathon**: Gemini API Developer Competition by Google (2024)
- **Description**: Best Firebase App winner. Leverages Gemini's natural language understanding to suggest personalized travel destinations, activities, and itineraries based on user preferences and conversation history.
- **Stack**: Firebase, Gemini API
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Travel planning is fragmented across many tools; this provides a conversational single interface.

### Outdraw AI
- **Hackathon**: Gemini API Developer Competition by Google (2024)
- **Description**: Most Creative App winner. A game where users draw images recognizable to other humans but designed to confuse or fool Gemini's visual understanding, creating an adversarial human-vs-AI drawing challenge.
- **Stack**: Gemini API (visual understanding), game development
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Explores the boundaries of AI visual recognition in an entertaining, educational game format.

### Nested
- **Hackathon**: Google AI Hackathon (Devpost, 2024)
- **Description**: Overall first-place winner. Helps users move to a new city by analyzing their Google Maps search history to understand lifestyle preferences, then recommending tailored places like gyms, grocery stores, and museums in potential new cities.
- **Stack**: Gemini API, Google Maps API, RAG
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Relocating to a new city is stressful; this personalizes neighborhood discovery using existing behavioral data.

### Gemini Movie Detectives
- **Hackathon**: Google AI Hackathon (Devpost, 2024)
- **Description**: AI-driven educational content platform for schools using Gemini and RAG to create game-based learning experiences around film education.
- **Stack**: Gemini API, RAG, education platform
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Film education lacks interactive, game-based tools that engage students.

### Image Describer
- **Hackathon**: Google AI Hackathon (Devpost, 2024)
- **Description**: A Chrome Extension using Gemini Vision APIs to describe any image or visual content on the web for blind users, providing real-time contextual audio descriptions.
- **Stack**: Gemini Vision API, Chrome Extension
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Blind users cannot access visual web content; this bridges the gap with AI-generated descriptions.

### Cart-to-Kitchen AI Assistant on GKE
- **Hackathon**: GKE Hackathon by Google Cloud (2025)
- **Description**: Grand prize winner. An AI shopping assistant that analyzes a user's grocery cart and recommends recipes using Gemini, deployed on GKE Autopilot with Agent Development Kit (ADK) and Agent-to-Agent (A2A) protocols.
- **Stack**: Gemini, GKE Autopilot, ADK, A2A protocols
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Shoppers buy groceries without a plan; this bridges purchasing and meal planning with intelligent recipe matching.

---

## OpenAI Hackathons

### Smooth Operator
- **Hackathon**: UC Berkeley LLM Agents Hackathon (2024)
- **Description**: First-place Applications Track winner. An AI-driven multi-agent solution automating the fragmented US moving industry: mover selection, cost negotiation, and decision-making through voice and web interfaces.
- **Stack**: OpenAI APIs, voice integration, multi-agent orchestration
- **GitHub**: https://github.com/boatcow/SmoothOperatorAI
- **Demo**: N/A
- **Problem Solved**: The $23B+ US moving industry is fragmented; customers waste hours comparing movers, negotiating prices, and coordinating logistics.

### ThreadFinders
- **Hackathon**: UC Berkeley LLM Agents Hackathon (2024)
- **Description**: Second-place Applications Track. A unified platform coordinating missing persons searches using specialized AI agents that integrate with mapping services, social media, and volunteer networks.
- **Stack**: Google Cloud Platform, Google Maps API, Generative AI
- **GitHub**: https://github.com/mbautista135/missing_ppl_search
- **Demo**: N/A
- **Problem Solved**: Missing persons search efforts are fragmented across dozens of disconnected platforms and organizations.

### FightForms
- **Hackathon**: UC Berkeley LLM Agents Hackathon (2024)
- **Description**: Third-place Applications Track. An AI voice call agent that helps users complete financial applications over the phone using OpenAI's Realtime API, addressing the 75.7% form abandonment rate in financial services.
- **Stack**: OpenAI Realtime API, form automation, voice
- **GitHub**: https://github.com/433ventures/fightforms/
- **Demo**: N/A
- **Problem Solved**: Complex financial forms have extremely high abandonment rates; voice-guided AI completion dramatically increases completion.

### hAIre
- **Hackathon**: UC Berkeley LLM Agents Hackathon (2024)
- **Description**: Sixth-place (tie) Applications Track. A multi-agent HR recruitment platform that screens CVs, conducts adaptive AI interviews, and scores candidates consistently.
- **Stack**: Speech-to-text, text-to-speech, LLM integration, multi-agent
- **GitHub**: https://github.com/eyenpi/hAIre-core
- **Demo**: N/A
- **Problem Solved**: Traditional hiring is inefficient and biased; AI-driven interviews add consistency and speed.

### Recall
- **Hackathon**: UC Berkeley LLM Agents Hackathon (2024)
- **Description**: Sixth-place (tie) Applications Track. A chat interface for interacting with long presentation videos using RAG-powered snippet retrieval—ask a question, get the exact clip.
- **Stack**: Streamlit, Whisper, CLIP, GPT-4o, QdrantDb
- **GitHub**: https://github.com/RecallHQ/recallhq
- **Demo**: N/A
- **Problem Solved**: Long video content is difficult to search; this makes any presentation interactively queryable.

### TerminAI
- **Hackathon**: UC Berkeley LLM Agents Hackathon (2024)
- **Description**: Fourth-place Applications Track. A natural language terminal interface that uses Gemini for command analysis and execution, lowering the barrier to CLI use for non-technical users.
- **Stack**: Python, Gemini, LAM framework
- **GitHub**: https://github.com/pUrGe12/TerminAI_V2
- **Demo**: N/A
- **Problem Solved**: Terminal command line usage is intimidating and inaccessible to beginners.

### StoryLabs
- **Hackathon**: UC Berkeley LLM Agents Hackathon (2024)
- **Description**: Fifth-place Applications Track. Creates personalized children's stories with dynamic AI-generated illustrations and voiceovers adapted to the child's interests and reading level.
- **Stack**: Multimodal AI, text-to-image, TTS, web stack
- **GitHub**: https://github.com/erniesg/storylabs
- **Demo**: N/A
- **Problem Solved**: Static books do not adapt to individual children's needs, interests, or comprehension levels.

### AI-Dventure
- **Hackathon**: GitHub "For the Love of Code" Challenge (2024/2025)
- **Description**: First-place Game On category. A text adventure game in Rust powered by OpenAI models, generating dynamic worlds and adaptive narratives based on player input.
- **Stack**: Rust, OpenAI API
- **GitHub**: https://github.com/FedeCarollo/ai_dventure
- **Demo**: N/A
- **Problem Solved**: Text adventures have static scripted worlds; this generates infinite adaptive narratives with AI.

---

## Cloudflare Hackathons

> Note: Cloudflare primarily sponsors prize tracks at university and community hackathons (HackHarvard, YHack, HackTX, Hacklytics) rather than running standalone branded hackathons. These are documented projects that used Cloudflare Workers AI.

### Project Think - AI Agent Infrastructure
- **Hackathon**: Internal / Cloudflare Birthday Week (2024)
- **Description**: Cloudflare's internal exploration of building AI agents on its platform, using Workers AI for inference, Durable Objects for state persistence, and R2 for memory. Showcases a "thinking" agent architecture entirely on Cloudflare's edge infrastructure.
- **Stack**: Cloudflare Workers AI, Durable Objects, R2, Workers
- **GitHub**: N/A
- **Demo**: https://blog.cloudflare.com/project-think/
- **Problem Solved**: AI agents need low-latency, stateful, globally distributed infrastructure—Cloudflare's edge layer solves this without separate cloud services.

---

## HuggingFace Hackathons

### LLMGameHub (Immersia)
- **Hackathon**: Gradio Agents & MCP Hackathon 2025 by HuggingFace (June 2025)
- **Description**: First-place Agent Track winner ($2,500). An immersive AI-powered game master platform where users describe a world, choose a hero and genre, and experience LLM-generated scenes with dynamically created first-person images and adaptive music.
- **Stack**: Gradio, LLM backends, image generation, music generation
- **GitHub**: N/A
- **Demo**: https://huggingface.co/spaces/Agents-MCP-Hackathon/LLMGameHub
- **Problem Solved**: Interactive storytelling and gaming lack truly adaptive, generative AI-powered narration.

### Sentinel One
- **Hackathon**: Gradio Agents & MCP Hackathon 2025 by HuggingFace (June 2025)
- **Description**: Second-place Agent Track winner ($500). A climate risk analysis agent that provides detailed risk assessment for any geographic location using multiagent systems and environmental data.
- **Stack**: Gradio, multi-agent AI, climate data APIs
- **GitHub**: N/A
- **Demo**: https://huggingface.co/spaces/Agents-MCP-Hackathon/Sentinel_One
- **Problem Solved**: Climate risk exposure is complex to assess for specific locations; this makes it conversational and accessible.

### Geocalc MCP Server
- **Hackathon**: Gradio Agents & MCP Hackathon 2025 by HuggingFace (June 2025)
- **Description**: First-place MCP Track winner ($2,500). An MCP server exposing a comprehensive suite of geographic calculation tools—distance, bearing, projections, area—usable by any MCP-compatible AI client.
- **Stack**: Gradio, MCP protocol, geographic libraries
- **GitHub**: N/A
- **Demo**: https://huggingface.co/spaces/Agents-MCP-Hackathon/geocalc-mcp
- **Problem Solved**: AI agents lack standardized access to geospatial computation primitives.

### Doc-MCP
- **Hackathon**: Gradio Agents & MCP Hackathon 2025 by HuggingFace (June 2025)
- **Description**: Second-place MCP Track winner ($500). Transforms GitHub documentation repositories into accessible MCP servers, making any project's docs queryable by AI agents.
- **Stack**: Gradio, MCP protocol, GitHub API
- **GitHub**: N/A
- **Demo**: https://huggingface.co/spaces/Agents-MCP-Hackathon/doc-mcp
- **Problem Solved**: AI agents cannot easily query project documentation; this standardizes docs-as-an-MCP-tool.

### Visual Workflow Builder
- **Hackathon**: Gradio Agents & MCP Hackathon 2025 by HuggingFace (June 2025)
- **Description**: First-place Custom Component Track winner ($2,500). A drag-and-drop Gradio component for building sophisticated AI agent workflows visually, without writing orchestration code.
- **Stack**: Gradio custom components, workflow engine
- **GitHub**: N/A
- **Demo**: https://huggingface.co/spaces/Agents-MCP-Hackathon/gradio_workflowbuilder
- **Problem Solved**: Building complex multi-step agent workflows requires deep coding expertise; this makes it visual and no-code.

### OpenSorus
- **Hackathon**: Gradio Agents & MCP Hackathon 2025 by HuggingFace (June 2025)
- **Description**: Mistral Choice award ($2,000 API credits). An AI maintainer agent that monitors GitHub Issues, triages them, suggests fixes, and drafts pull requests automatically.
- **Stack**: Gradio, Mistral AI, GitHub API, MCP
- **GitHub**: N/A
- **Demo**: https://huggingface.co/spaces/Agents-MCP-Hackathon/OpenSorus
- **Problem Solved**: Open source maintainers are overwhelmed by issue volume; this provides AI-assisted triage and resolution.

### NASA Space Explorer Assistant
- **Hackathon**: Gradio Agents & MCP Hackathon 2025 by HuggingFace (June 2025)
- **Description**: LlamaIndex Choice award ($1,000). An MCP-powered NASA data access tool combined with an AI chat assistant for exploring space missions, asteroids, Mars weather, and imagery.
- **Stack**: Gradio, LlamaIndex, NASA APIs, MCP
- **GitHub**: N/A
- **Demo**: https://huggingface.co/spaces/Agents-MCP-Hackathon/nasa-space-explorer
- **Problem Solved**: NASA's vast public data is scattered and hard to query conversationally.

### Shallow Research Code Assistant Hub
- **Hackathon**: Gradio Agents & MCP Hackathon 2025 by HuggingFace (June 2025)
- **Description**: Modal Labs Choice award ($5,000). A streamlined interface for AI-assisted research and code generation combining multiple AI models for iterative research and implementation.
- **Stack**: Gradio, Modal Labs, multiple LLM backends
- **GitHub**: N/A
- **Demo**: https://huggingface.co/spaces/Agents-MCP-Hackathon/ShallowCodeResearch
- **Problem Solved**: Research-to-code pipelines require switching between many tools; this unifies them in one interface.

---

## LlamaIndex / LangChain Hackathons

### Helmet AI
- **Hackathon**: UC Berkeley AI Hackathon (LlamaIndex Prize Track, 2023)
- **Description**: First Prize in LlamaIndex's "Best Knowledge-Intensive LLM App" category. A market intelligence platform monitoring breaking news and extracting actionable insights for business leaders using real-time data analysis.
- **Stack**: LlamaIndex, LangChain, OpenAI GPT models, Pinecone, Azure App Services, Azure PostgreSQL, GraphQL, RSS feeds
- **GitHub**: https://devpost.com/software/helmet-ai
- **Demo**: N/A
- **Problem Solved**: Business leaders cannot efficiently monitor competitive intelligence across fragmented news sources.

### Split
- **Hackathon**: UC Berkeley AI Hackathon (LlamaIndex Prize Track, 2023)
- **Description**: Second Prize. An AI email assistant that learns a user's writing style and generates personalized emails that match their voice and emotional tone.
- **Stack**: Google API, LlamaIndex, OpenAI text-davinci-003, Hume (emotion detection), React.js, Flask
- **GitHub**: https://devpost.com/software/split-pv4hn7
- **Demo**: N/A
- **Problem Solved**: AI-generated emails sound robotic and impersonal; this preserves individual voice in automated drafts.

### Prosper AI
- **Hackathon**: UC Berkeley AI Hackathon (LlamaIndex Prize Track, 2023)
- **Description**: Third Prize. A virtual financial advisor providing personalized wealth management guidance using aggregated financial data from Plaid and user-defined goals.
- **Stack**: FastAPI, OpenAI GPT-4 with function calling, Pinecone, LlamaIndex, Next.js/SvelteKit, Plaid
- **GitHub**: N/A
- **Demo**: https://prosperai.vercel.app/
- **Problem Solved**: Professional financial advisors are inaccessible to most individuals; this democratizes wealth management advice.

### Agents of Inference
- **Hackathon**: Generative AI Agents Developer Contest by NVIDIA & LangChain (2024)
- **Description**: Grand Prize winner (RTX 4090). A multi-agent inference demonstration platform showcasing practical AI agent patterns using NVIDIA NIM and LangChain for complex reasoning tasks.
- **Stack**: NVIDIA NIM, LangChain, Python
- **GitHub**: https://github.com/briancaffey/agents-of-inference
- **Demo**: N/A
- **Problem Solved**: Demonstrates how NVIDIA inference infrastructure and LangChain agents work together in production-grade multi-step reasoning scenarios.

### AI Personal Trainer (Valkyrie)
- **Hackathon**: Generative AI Agents Developer Contest by NVIDIA & LangChain (2024)
- **Description**: Grand Prize winner (RTX 4090). A multimodal fitness coaching agent using vision models to analyze exercise form and provide real-time coaching feedback.
- **Stack**: NVIDIA foundation models, LangChain, computer vision
- **GitHub**: https://github.com/pannaf/valkyrie
- **Demo**: N/A
- **Problem Solved**: Personal training is expensive and unavailable 24/7; this provides AI-powered form correction and coaching.

### RetainAI
- **Hackathon**: NVIDIA and LlamaIndex Developer Contest (2024)
- **Description**: First Place ($5,000). Analyzes employee data to generate customized retention strategies, helping companies minimize turnover and enhance engagement with personalized action plans.
- **Stack**: NVIDIA NIM, LlamaIndex, Python
- **GitHub**: https://github.com/arsentievalex/retain-ai
- **Demo**: N/A
- **Problem Solved**: Employee turnover costs companies 50-200% of an employee's salary; AI-driven retention strategies reduce this.

### Plotomatic
- **Hackathon**: NVIDIA and LlamaIndex Developer Contest (2024)
- **Description**: Second Place ($3,000). A collection of Python notebooks that start from a single prompt and generate a full story with consistent world-building, character arcs, and scene sequencing.
- **Stack**: NVIDIA NIM, LlamaIndex, Python
- **GitHub**: https://github.com/mattwilliamson/Plotomatic
- **Demo**: N/A
- **Problem Solved**: Writing long-form fiction requires maintaining consistency across many narrative elements that AI often contradicts.

### ESG Insights AI
- **Hackathon**: NVIDIA and LlamaIndex Developer Contest (2024)
- **Description**: Third Place ($1,000). An AI-powered solution for environmental, social, and governance data analysis, enabling investors and companies to generate ESG reports and insights from raw documents.
- **Stack**: NVIDIA NIM, LlamaIndex, Python
- **GitHub**: https://github.com/dhruvshah00/esg-insight-ai-demo/
- **Demo**: N/A
- **Problem Solved**: ESG reporting is labor-intensive and requires specialized expertise to analyze complex sustainability documents.

### DataSense
- **Hackathon**: UC Berkeley LLM Agents Hackathon (Benchmarks Track, 2024)
- **Description**: First Place Benchmarks. A comprehensive benchmark evaluating LLMs' capabilities in processing tabular data across 13 table types, 9 datasets, and 230 questions covering data curation, information retrieval, and statistical analysis.
- **Stack**: LangChain, Claude 3.5, GPT-4o, Gemini
- **GitHub**: https://github.com/raywanb/DataSenseQA
- **Demo**: N/A
- **Problem Solved**: No standardized benchmark existed for evaluating LLMs on structured tabular data tasks.

---

## NVIDIA Hackathons

### RAGIS (Retrieval-Augmented Generation Incident Summary)
- **Hackathon**: HackAI Challenge 2024 by Dell x NVIDIA
- **Description**: Standout project. Integrates generative AI with enterprise security data to help security teams identify false positives and prioritize real threats automatically using LangChain RAG pipelines.
- **Stack**: LangChain, Gradio, NVIDIA NIM, NVIDIA AI Workbench
- **GitHub**: https://devpost.com/software/ragis
- **Demo**: N/A
- **Problem Solved**: Security operations centers are overwhelmed by alert volume, missing real threats in the noise.

### Txt2App
- **Hackathon**: HackAI Challenge 2024 by Dell x NVIDIA
- **Description**: Transforms natural language app descriptions into functional mobile applications using NVIDIA AI Workbench as the development environment.
- **Stack**: LLMs, NVIDIA AI Workbench, mobile generation
- **GitHub**: https://devpost.com/software/txt2app
- **Demo**: N/A
- **Problem Solved**: Mobile app development requires deep technical expertise; this makes it accessible to non-developers.

### CaptionCraft
- **Hackathon**: HackAI Challenge 2024 by Dell x NVIDIA
- **Description**: Automated social media caption tool using computer vision and NLP; users upload photos and receive keyword-enriched, tone-customizable captions.
- **Stack**: Salesforce BLIP, Mistral NeMo 12B, NVIDIA AI Workbench
- **GitHub**: https://devpost.com/software/captioncraft-5wc4b9
- **Demo**: N/A
- **Problem Solved**: Content creators spend hours writing social media captions; this automates personalized caption creation.

### Agents of Inference
- **Hackathon**: Generative AI Agents Developer Contest by NVIDIA & LangChain (2024)
- **Description**: Grand Prize (RTX 4090). Production-grade multi-agent inference demonstration using NVIDIA NIM microservices and LangChain for complex multi-step reasoning.
- **Stack**: NVIDIA NIM, LangChain, Python, Docker
- **GitHub**: https://github.com/briancaffey/agents-of-inference
- **Demo**: N/A
- **Problem Solved**: Demonstrates scalable, production-ready AI agent patterns using NVIDIA's inference infrastructure.

---

## MongoDB Hackathons

### Haven
- **Hackathon**: MongoDB AI Hackathon: Code for a Cause (AWS x MongoDB x LangChain, 2024)
- **Description**: First-place winner. "A Silent Shield, A Strong Voice" — an AI-powered platform empowering women in abusive situations with discreet access to help, mental health support, and legal guidance.
- **Stack**: MongoDB Atlas, AWS, LangChain, AI models
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Victims of domestic abuse need discreet, safe access to resources; this provides a covert AI assistant.

### ResQTrack
- **Hackathon**: MongoDB AI Hackathon: Code for a Cause (2024)
- **Description**: One-touch SOS emergency response platform with real-time communication and AI-powered dispatch routing to connect victims with emergency services.
- **Stack**: MongoDB Atlas, AWS, LangChain, real-time communications
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Emergency response dispatch is inefficient; AI-powered routing can reduce response times significantly.

### Session History Plugin
- **Hackathon**: Kong Agentic AI Hackathon 2025 by Kong Inc. (with MongoDB)
- **Description**: First-place winner. Extends Kong AI Gateway with persistent session objects that preserve conversation history across requests using the x-ai-session-id header, with MongoDB storage and context summarization.
- **Stack**: MongoDB, Kong AI Gateway, context summarization
- **GitHub**: https://github.com/AbhiNeos/session-history-plugin
- **Demo**: N/A
- **Problem Solved**: AI gateway requests are stateless; this enables persistent, context-aware conversation management at the gateway layer.

### Privacy Pilot
- **Hackathon**: AI ATL 2024 Hackathon (Google track winner + Best Use of MongoDB)
- **Description**: A dual-award winner combining Google's AI tools and MongoDB Atlas for privacy-focused data navigation, helping users understand and control their personal data footprint.
- **Stack**: MongoDB Atlas, Google AI, privacy analysis
- **GitHub**: https://github.com/AlexT101/privacy-pilot
- **Demo**: N/A
- **Problem Solved**: Users have no visibility into how their personal data is collected and used across services.

---

## Supabase Hackathons

### Supafork
- **Hackathon**: Launch Week X Hackathon by Supabase
- **Description**: Best Overall project. Allows developers to easily clone Supabase projects with a single click, similar to Vercel's "Deploy" button—enabling one-click replication of full-stack Supabase app stacks.
- **Stack**: Supabase, Next.js, TypeScript
- **GitHub**: https://github.com/chroxify/supafork
- **Demo**: N/A
- **Problem Solved**: Deploying copies of Supabase-backed projects for demos or forks requires tedious manual configuration.

### AI Video Search Engine (AVSE)
- **Hackathon**: Launch Week X Hackathon by Supabase
- **Description**: Best Use of AI. Converts video transcriptions to embeddings enabling semantic content-based video search—find video moments by meaning, not just keywords.
- **Stack**: Supabase, OpenAI embeddings, PostgreSQL vector search
- **GitHub**: https://github.com/yoeven/ai-video-search-engine
- **Demo**: N/A
- **Problem Solved**: Video content is unsearchable by meaning; this makes any video library semantically queryable.

### Supabase CLI for Visual Studio Code
- **Hackathon**: Launch Week X Hackathon by Supabase
- **Description**: Most Technically Impressive. Integrates Supabase database management directly into VSCode, enabling migrations, schema inspection, and database operations without leaving the editor.
- **Stack**: Supabase, VSCode Extension API, TypeScript
- **GitHub**: https://github.com/anas-araid/vscode-supabase-cli
- **Demo**: N/A
- **Problem Solved**: Database management requires context-switching out of the code editor; this keeps workflows in one place.

### Whisker Jam
- **Hackathon**: Launch Week 12 Hackathon by Supabase (Sept 2024)
- **Description**: Best Overall project. A real-time virtual rock band made up of cats—host a jam session on a TV screen and join on your phone with friends, powered by Supabase Realtime.
- **Stack**: Supabase Realtime, Next.js, TypeScript
- **GitHub**: https://github.com/c-o-l-i-n/whisker-jam
- **Demo**: N/A
- **Problem Solved**: Demonstrates Supabase Realtime's multiplayer capabilities in a fun, shareable experience.

### SupExplain
- **Hackathon**: Launch Week 12 Hackathon by Supabase (Sept 2024)
- **Description**: Best Use of AI. An AI Postgres query plan explainer that visualizes and optimizes SQL queries with natural language explanations and improvement suggestions.
- **Stack**: Supabase, OpenAI, PostgreSQL EXPLAIN ANALYZE, React
- **GitHub**: https://github.com/rbkayz/supexplain
- **Demo**: N/A
- **Problem Solved**: PostgreSQL query plan output is cryptic; this translates it into human-readable optimization guidance.

### supagen
- **Hackathon**: Launch Week 12 Hackathon by Supabase (Sept 2024)
- **Description**: Most Technically Impressive. A CLI tool automating manual and repetitive tasks when working with Supabase—type generation, RLS policy scaffolding, migration helpers.
- **Stack**: Supabase, Node.js, CLI tooling
- **GitHub**: https://github.com/supagen/supagen
- **Demo**: N/A
- **Problem Solved**: Supabase projects involve repetitive boilerplate; this CLI eliminates the toil.

### GitHub RAG
- **Hackathon**: Launch Week 12 Hackathon by Supabase (Sept 2024)
- **Description**: Most Technically Impressive runner-up. A chat interface that lets users search and query their starred GitHub repositories using RAG—ask "which of my starred repos solves X?" and get accurate answers.
- **Stack**: Supabase, pgvector, OpenAI embeddings, Next.js
- **GitHub**: https://github.com/XamHans/github-rag
- **Demo**: N/A
- **Problem Solved**: Developers star hundreds of repos but can't recall which one solves a specific problem; RAG makes the collection searchable.

### vdbs
- **Hackathon**: Open Source Hackathon 2024 by Supabase
- **Description**: Best Overall winner. Converts database diagram images into SQL schema using Supabase's Vision API—upload a whiteboard sketch or ERD image, get runnable SQL back.
- **Stack**: Supabase, Vision API, SQL generation, TypeScript
- **GitHub**: https://github.com/xavimondev/vdbs
- **Demo**: N/A
- **Problem Solved**: Converting visual database diagrams into SQL is tedious and error-prone.

### ClosetAi
- **Hackathon**: Open Source Hackathon 2024 by Supabase
- **Description**: Best Use of AI. Upload clothing images and let AI replace your outfit instantly—a virtual wardrobe and styling tool using image generation and Supabase storage.
- **Stack**: Supabase, image AI models, Next.js
- **GitHub**: https://github.com/ineffablesam/closet-ai
- **Demo**: N/A
- **Problem Solved**: Virtual try-on for clothing is expensive and requires specialized hardware; this makes it browser-accessible.

### Plot Twist
- **Hackathon**: Open Source Hackathon 2024 by Supabase
- **Description**: Best Use of AI runner-up. An interactive storytelling platform where user choices shape the AI-generated narrative in real time, creating infinitely branching stories.
- **Stack**: Supabase, OpenAI, Next.js
- **GitHub**: https://github.com/NeoFoxxo/plottwist
- **Demo**: N/A
- **Problem Solved**: Interactive fiction requires massive pre-authored content; AI generation makes infinite stories possible.

---

## Other Vendors

### Guardian (Atlas Triage Assistant)
- **Hackathon**: Meta Llama Impact Hackathon (London, Nov 2024) by Meta x Cerebral Valley
- **Description**: First-place winner ($50K shared + 6 weeks mentorship). An AI-powered triage assistant for NHS A&E departments featuring Atlas, a clinical agent providing real-time risk assessment and multilingual patient communication to reduce ER wait times.
- **Stack**: Llama 3.2, Python, clinical APIs
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Emergency departments face chronic overcrowding; AI triage can stratify patients and allocate resources more efficiently.

### Gripmind
- **Hackathon**: Meta Llama Impact Hackathon (London, Nov 2024) by Meta x Cerebral Valley
- **Description**: Second-place winner. Open-source robotics solution combining Llama 3.2 Vision to process brain signals, voice commands, or images for controlling robotic arms in assisted-living settings.
- **Stack**: Llama 3.2 Vision, robotics hardware, Python
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Assistive robotics is expensive and proprietary; open-source multimodal AI control democratizes accessibility.

### Pharmallama
- **Hackathon**: Meta Llama Impact Hackathon (London, Nov 2024) by Meta x Cerebral Valley
- **Description**: Third-place winner. On-device app enabling patient-pharmacist consultations about medication side effects while centralizing records to identify potential drug conflicts.
- **Stack**: Llama-based on-device models, mobile app
- **GitHub**: N/A
- **Demo**: N/A
- **Problem Solved**: Patients with mobility limitations or in underserved areas cannot easily access pharmacist consultations.

### Session History Plugin
- **Hackathon**: Kong Agentic AI Hackathon 2025 by Kong Inc.
- **Description**: First-place winner. Extends Kong AI Gateway with persistent conversation sessions using MongoDB storage and context summarization.
- **Stack**: Kong AI Gateway, MongoDB, context summarization
- **GitHub**: https://github.com/AbhiNeos/session-history-plugin
- **Demo**: N/A
- **Problem Solved**: AI gateways are stateless; this enables memory-aware, session-persistent AI routing.

### AgenticAI-MCP-Client
- **Hackathon**: Kong Agentic AI Hackathon 2025 by Kong Inc.
- **Description**: Second-place winner. Brings Model Context Protocol (MCP) integration to Kong AI Gateway, accepting natural language input and converting it into structured MCP queries via LLM-powered agents.
- **Stack**: Kong AI Gateway, Mongo MCP Server, LLM agents
- **GitHub**: https://github.com/satyajitsial/agenticAI-mcp-client
- **Demo**: N/A
- **Problem Solved**: MCP protocol integration requires custom code per service; this centralizes MCP at the gateway layer.

### Kong Auto Rollback AI Agent
- **Hackathon**: Kong Agentic AI Hackathon 2025 by Kong Inc.
- **Description**: Third-place winner. An autonomous SRE tool monitoring Kong gateway configurations for failures and automatically rolling back misconfigurations to maintain uptime.
- **Stack**: Kong AI Gateway, Python, configuration management
- **GitHub**: https://github.com/andrewgkew/kong-ai-auto-rollback
- **Demo**: N/A
- **Problem Solved**: Gateway misconfigurations cause outages; autonomous rollback ensures rapid recovery.

### Likeminds - Agentic Multi-Social Semantic Network
- **Hackathon**: Global Agent Hackathon (May 2025) by Agno
- **Description**: Grand Prize winner ($5,000). A full-stack semantic social network platform where Agno-powered agents collaborate to understand and operate within dynamic semantic social contexts.
- **Stack**: Agno, React, semantic network architecture
- **GitHub**: https://github.com/global-agent-hackathon/global-agent-hackathon-may-2025/pull/84
- **Demo**: https://likeminds-react-vercel.vercel.app/
- **Problem Solved**: Social networks lack semantic understanding of connections; this enables agents to navigate and act within social graphs.

### Superwizard AI
- **Hackathon**: Global Agent Hackathon (May 2025) by Agno
- **Description**: $2,000 prize. A Chrome extension bringing agentic browser automation through natural language commands for form filling, web navigation, and UI interactions.
- **Stack**: Agno, Chrome Extension API, browser automation
- **GitHub**: https://github.com/global-agent-hackathon/global-agent-hackathon-may-2025/pull/125
- **Demo**: http://amirulhamizan.com/gah-181818
- **Problem Solved**: Web automation requires technical scripting expertise; this makes any web task executable by natural language.

### AI Speech Trainer
- **Hackathon**: Global Agent Hackathon (May 2025) by Agno
- **Description**: $500 prize. A multimodal coaching agent for public speaking that analyzes voice, pacing, filler words, and body language from video to provide structured feedback.
- **Stack**: Agno, multimodal AI, speech analysis
- **GitHub**: https://github.com/global-agent-hackathon/global-agent-hackathon-may-2025/pull/85
- **Demo**: N/A
- **Problem Solved**: Public speaking coaching is expensive; this provides on-demand AI-powered presentation feedback.

### AI-Powered Clinical Trial Matcher
- **Hackathon**: Global Agent Hackathon (May 2025) by Agno
- **Description**: $500 prize. A multi-agent system that matches patients to relevant clinical trials based on medical history, eligibility criteria, and location using structured trial databases.
- **Stack**: Agno, multi-agent, clinical databases
- **GitHub**: https://github.com/global-agent-hackathon/global-agent-hackathon-may-2025/pull/137
- **Demo**: N/A
- **Problem Solved**: Matching patients to clinical trials is manual and complex; this automates personalized trial recommendations.

### MeetAgent
- **Hackathon**: Global Agent Hackathon (May 2025) by Agno
- **Description**: $500 prize. An AI meeting assistant that produces intelligent recaps, summaries, and action items from meeting recordings.
- **Stack**: Agno, speech-to-text, summarization
- **GitHub**: https://github.com/global-agent-hackathon/global-agent-hackathon-may-2025/pull/87
- **Demo**: N/A
- **Problem Solved**: Meeting follow-ups require manual note-taking and action item tracking; this automates the entire post-meeting workflow.

### Windows-Use
- **Hackathon**: Global Agent Hackathon (May 2025) by Agno
- **Description**: $500 prize. An AI agent that controls Windows applications and workflows through natural language commands, enabling full desktop automation.
- **Stack**: Agno, Windows automation APIs, Python
- **GitHub**: https://github.com/global-agent-hackathon/global-agent-hackathon-may-2025/pull/124
- **Demo**: N/A
- **Problem Solved**: Desktop automation requires RPA tools or scripting; this enables conversational Windows control.

### SSEAL (Self-Supervised Exploration and Adaptation for LLMs)
- **Hackathon**: UC Berkeley LLM Agents Hackathon (Fundamentals Track, 2024)
- **Description**: First Place Fundamentals. A self-supervised exploration framework enabling black-box LLM agents to autonomously adapt to under-specified environments through iterative prompt optimization.
- **Stack**: LLM black-box APIs, RL optimization, prompt engineering
- **GitHub**: https://github.com/efrick2002/SSEAL
- **Demo**: N/A
- **Problem Solved**: LLMs perform poorly on ambiguous tasks with incomplete specifications; SSEAL enables autonomous environment adaptation.

### PrivAgent
- **Hackathon**: UC Berkeley LLM Agents Hackathon (Safety Track, 2024)
- **Description**: First Place Safety. A black-box red-teaming framework using reinforcement learning attack agents to automatically discover privacy leakage vulnerabilities in LLMs.
- **Stack**: Reinforcement learning, adversarial prompting, LLM evaluation
- **GitHub**: https://github.com/rucnyz/RedAgent
- **Demo**: N/A
- **Problem Solved**: LLMs are vulnerable to privacy attacks; this automates discovery of leakage vectors.

### Agent Lite
- **Hackathon**: UC Berkeley LLM Agents Hackathon (Decentralized & Multi-Agent Track, 2024)
- **Description**: First Place (tie) Decentralized. An on-device healthcare assistant using task-specific agents without internet dependency, preserving patient privacy.
- **Stack**: Qwen Code Instruct 2.5 7B, multi-agent architecture, on-device inference
- **GitHub**: https://github.com/sakharamg/Multi-Agent-Health-Assistant
- **Demo**: N/A
- **Problem Solved**: Healthcare AI needs privacy-preserving on-device deployment without cloud data transmission.

### iVISPAR
- **Hackathon**: UC Berkeley LLM Agents Hackathon (Benchmarks Track, 2024)
- **Description**: Second Place Benchmarks. An interactive benchmark evaluating spatial reasoning in large vision-language models using puzzle-based test scenarios.
- **Stack**: Vision-language models, interactive puzzle environments
- **GitHub**: https://github.com/SharkyBamboozle/iVISPAR/tree/main
- **Demo**: N/A
- **Problem Solved**: No benchmark existed specifically for testing spatial reasoning and problem-solving in vision-language models.

### Neosgenesis
- **Hackathon**: GitHub "For the Love of Code" Challenge (2024/2025)
- **Description**: First-place Agents of Change category. A metacognitive AI framework teaching machines to reflect on their own reasoning processes using multiple LLMs in reasoning loops.
- **Stack**: Multiple LLMs, metacognitive reasoning loops
- **GitHub**: https://github.com/answeryt/Neosgenesis
- **Demo**: N/A
- **Problem Solved**: LLMs lack metacognitive awareness; this builds self-reflective reasoning into multi-model pipelines.

### Reviewer Karma
- **Hackathon**: GitHub "For the Love of Code" Challenge (2024/2025)
- **Description**: Third-place Everything But the Kitchen Sink category. A GitHub Action that gamifies code reviews by awarding karma points for constructive, detailed pull request feedback.
- **Stack**: Go, GitHub API, GitHub Actions
- **GitHub**: https://github.com/master-wayne7/reviewer-karma-action
- **Demo**: N/A
- **Problem Solved**: Code review quality is inconsistent; gamification incentivizes thorough, actionable feedback.

### Jukebox CLI
- **Hackathon**: GitHub "For the Love of Code" Challenge (2024/2025)
- **Description**: Second-place Terminal Talent category. A terminal-based music player with an animated TUI interface built in Rust using Ratatui.
- **Stack**: Rust, Ratatui, terminal audio
- **GitHub**: https://github.com/FedeCarollo/jukebox-cli
- **Demo**: N/A
- **Problem Solved**: Music playback in the terminal lacks a visually rich, keyboard-driven interface.

---

*Total: 100+ projects across 12 vendor sections.*

*Sources used: Devpost, HuggingFace Spaces, GitHub Topics, vendor blogs (Google Developers Blog, Meta AI Blog, Microsoft Tech Community, Supabase Blog, Kong Blog, Agno Blog, Anthropic/Indie Hackers), lablab.ai, and Berkeley RDI.*
