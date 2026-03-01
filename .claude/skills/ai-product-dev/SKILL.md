---
name: ai-product-dev
description: AI/ML product development - LLM integration, RAG, embeddings, prompt engineering, agent architecture, evaluation, AI API usage (OpenAI, Anthropic, Google)
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch
---

# AI Product Development Skill

## LLM Integration Patterns

### API Client Best Practices
- Always implement retry with exponential backoff for rate limits
- Use streaming for long responses (better UX)
- Set `max_tokens` explicitly to control costs
- Log prompt + completion for debugging (redact PII)
- Implement request queuing for rate limit management
- Use structured output (JSON mode, tool use) over free-text parsing

### Provider Abstraction
```typescript
// Abstract provider interface for easy switching
interface LLMProvider {
  chat(messages: Message[], options: LLMOptions): AsyncGenerator<string>;
  embed(texts: string[]): Promise<number[][]>;
  estimateTokens(text: string): number;
}
```

## RAG Architecture

```
Query → Embed → Vector Search → Rerank → Context Assembly → LLM → Answer
         │          │              │              │
         └─ Same    └─ pgvector    └─ Cohere      └─ Token budget
           model      Qdrant        cross-encoder    management
                      Pinecone
```

### RAG Checklist
- [ ] Chunking strategy (semantic > fixed-size)
- [ ] Chunk overlap (10-20% of chunk size)
- [ ] Metadata in chunks (source, date, section)
- [ ] Hybrid search (vector + keyword BM25)
- [ ] Reranking step for precision
- [ ] Citation/source tracking
- [ ] Evaluation pipeline (retrieval recall, answer quality)

## Agent Architecture

### Tool-use Pattern
```
User Input → Plan → [Tool Call → Observe → Think]* → Final Answer
```

### Agent Design Rules
1. Define clear tool descriptions (LLM reads them)
2. Limit tool count per call (5-10 max for quality)
3. Implement tool call validation before execution
4. Set max iterations to prevent infinite loops
5. Log every step for debugging
6. Human-in-the-loop for destructive actions

## Prompt Engineering

### Structure Template
```
<system>
Role definition + constraints + output format
</system>

<context>
Retrieved documents, user history, relevant data
</context>

<instructions>
Step-by-step task description
</instructions>

<examples>
Few-shot examples of input → output
</examples>

<input>
Actual user input
</input>
```

### Anti-patterns to Avoid
- Vague instructions ("be helpful")
- No output format specification
- Missing edge case handling
- No examples for complex tasks
- Prompt injection vulnerability (unsanitized user input in system prompt)

## Evaluation Framework

| What to Evaluate | How | Tools |
|-----------------|-----|-------|
| Retrieval quality | Recall@K, MRR, NDCG | RAGAS, custom |
| Answer quality | LLM-as-judge, human eval | Braintrust, Langsmith |
| Latency | P50, P95, P99 | Custom metrics |
| Cost | $/query, tokens/query | Provider dashboards |
| Safety | Red teaming, boundary tests | Promptfoo |
| Regression | Golden dataset comparison | CI/CD eval pipeline |

## Cost Optimization

- Cache frequent queries (semantic cache with embeddings)
- Use smaller models for classification/routing
- Batch embedding requests
- Implement token budget per request
- Route simple queries to cheaper models (Haiku/GPT-4o-mini)
- Pre-compute common RAG retrievals

## Production Checklist

- [ ] Rate limiting on AI endpoints (per user)
- [ ] Token/cost tracking per request
- [ ] Fallback model if primary is down
- [ ] Content moderation on input AND output
- [ ] PII detection and redaction in logs
- [ ] A/B testing framework for prompt variants
- [ ] Graceful degradation when AI is slow/down
- [ ] User feedback collection (thumbs up/down)
