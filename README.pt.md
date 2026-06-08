# 🔍 Conecta o Claude ao Google Search Console em 5 Minutos

> Sem dashboards. Sem exportar CSV. Sem ferramentas de SEO. Só perguntar ao Claude diretamente.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Funciona com Claude Desktop](https://img.shields.io/badge/Claude-Desktop-orange)](https://claude.ai/download)
[![Compatível com MCP](https://img.shields.io/badge/MCP-Compatible-blue)](https://modelcontextprotocol.io)
[![English](https://img.shields.io/badge/Read%20in-English%20%F0%9F%87%BA%F0%9F%87%B8-0057b7)](README.md)

---

## Este repo cobre duas coisas

**[Parte 1](#parte-1--conecta-o-claude-ao-google-search-console)** — Conecta o Claude aos seus dados de tráfego em tempo real via Google Search Console (configuração de 5 minutos)

**[Parte 2](#parte-2--deixa-o-claude-auditar-seu-projeto)** — Deixa o Claude ler os arquivos reais do seu projeto e encontrar o que está quebrando seu SEO antes que o Google perceba (sem configuração extra)

Usados juntos, o Claude vira um loop completo de auditoria SEO + dev: ele vê o que está machucando seu tráfego *e* encontra a causa raiz no seu código.

---

## Parte 1 — Conecta o Claude ao Google Search Console

### O que você pode perguntar

```
"Por que o tráfego da minha homepage caiu 80% esse mês?"

"Quais páginas têm as piores taxas de clique?"

"Estou em 1º lugar para algumas palavras-chave mas não recebo cliques — o que está acontecendo?"

"Encontra os conteúdos que estão decaindo antes que caiam de vez."

"Quais são os ganhos rápidos mais fáceis essa semana?"

"Alguma página minha está competindo com ela mesma pela mesma busca?"
```

### O que você precisa

| Requisito | Observação |
|---|---|
| [Claude Desktop](https://claude.ai/download) | O plano gratuito funciona |
| [Node.js](https://nodejs.org) v18+ | Só instalar, ~30 segundos |
| Google Search Console | Qualquer propriedade que você gerencia |
| ~5 minutos | Sério |

### Como configurar

**Passo 1 — Instala o Node.js** (pula se já tiver)

Baixa em [nodejs.org](https://nodejs.org) e roda o instalador.

**Passo 2 — Cria as credenciais OAuth do Google**

1. Vai em [Google Cloud Console](https://console.cloud.google.com)
2. Cria um novo projeto (nome qualquer — "Claude GSC" funciona)
3. **APIs e Serviços → Biblioteca** → busca **Google Search Console API** → Ativa
4. **APIs e Serviços → Credenciais → + Criar Credenciais → ID do cliente OAuth 2.0**
5. Escolhe **Aplicativo de desktop**, coloca qualquer nome, clica em **Criar**
6. Clica em **Baixar JSON** — salva em algum lugar que você vai lembrar

**Passo 3 — Roda o script de configuração**

Windows: clica duas vezes em `setup.bat` — Mac/Linux: `chmod +x setup.sh && ./setup.sh`

O script verifica o Node.js, pede o caminho do JSON do OAuth e a URL do seu site, e escreve a config do Claude automaticamente.

**Passo 4 — Reinicia o Claude e autoriza**

O Claude vai pedir para autorizar o Google na primeira vez. Segue o link, aprova e pronto.

### Exemplo de resultado

```
📊 Visão Geral (últimos 28 dias)
   Cliques: 1.247  |  Impressões: 18.432  |  CTR: 6,8%  |  Posição média: 14,2

🚨 Problema Crítico Encontrado
   Sua homepage caiu 81% em cliques em 3 semanas.
   A posição está estável em 2,9 — é problema de CTR, não de ranking.
   O título "Bem-vindo ao nosso site" não corresponde ao que as pessoas buscaram.

⚡ Ganhos Rápidos (essa semana)
   3 páginas na posição 6-10 com muitas impressões e CTR baixo.
   Ajustar os títulos pode recuperar ~40 cliques/semana sem link building.
```

### O que o Claude consegue verificar

| Análise | O que verifica |
|---|---|
| **Quedas de tráfego** | Compara 3 períodos, isola páginas e buscas que caíram |
| **Oportunidades de CTR** | Onde seu ranking vs taxa de clique está abaixo do esperado |
| **Ganhos rápidos** | Buscas na posição 6-15 com potencial de melhoria fácil |
| **Decaimento de conteúdo** | Páginas com queda consistente há 3+ meses |
| **Canibalização** | Múltiplas URLs competindo pela mesma busca |
| **Lacunas de conteúdo** | Buscas onde você rankeia mas não tem conteúdo real |
| **Auditoria de sitemap** | Erros de cobertura, páginas faltando |
| **Inspeção de URL** | Status de indexação, mobile, data do último crawl |

### Instala a Skill GSC Analyst (usuários do Cowork)

**[Baixar gsc-analyst.skill](./gsc-analyst.skill)**

No Cowork: Configurações → Skills → Instalar de arquivo → `gsc-analyst.skill`

---

## Parte 2 — Deixa o Claude Auditar seu Projeto

> Sem configuração extra. O Claude lê seus arquivos diretamente e encontra o que está quebrado antes que o Google perceba.

Isso é o que a maioria das "ferramentas de IA para SEO" erra: **o problema nem sempre está nos dados de tráfego — está no código.**

Canonical tags erradas. Sitemap apontando para URLs com `.html` que redirecionam. Títulos que parecem certos até você checar o que o Google realmente indexou. Redirects de autenticação que criam loops no mobile. Iframes que carregam antes da autenticação e quebram a página de login inteira.

O Claude consegue ler os arquivos do seu projeto e cruzar com os dados do GSC para encontrar a causa raiz — não só o sintoma.

### Como fica na prática

No **Claude Cowork**: Configurações → seleciona sua pasta de projeto. Depois pergunta:

> *"Audita o SEO do meu site — verifica o código e cruza com meus dados do Search Console"*

O Claude vai:
1. Mapear a estrutura do projeto
2. Ler os arquivos HTML e verificar title, meta, canonical, OG tags, schema markup
3. Ler o sitemap e verificar o formato e status de cada URL
4. Escanear o JavaScript em busca de erros de sintaxe, lógica de redirect quebrada, problemas de auth
5. Cruzar com os dados do GSC para ver quais problemas estão realmente machucando o tráfego
6. Entregar uma lista de correções priorizada

### O que o Claude encontra que você jamais acharia manualmente

| Problema | Onde se esconde |
|---|---|
| Canonical apontando para URL com `.html` | `<link rel="canonical">` no HTML |
| Sitemap listando páginas inativas/deletadas | Seu `sitemap.xml` |
| Redirect de auth criando loop de login | Redirect JS dentro da função de inicialização mobile |
| Título não corresponde às buscas do GSC | Verificado cruzando código com dados do GSC |
| Schema markup faltando campos obrigatórios | `<script type="application/ld+json">` |
| Iframe carregando página de auth antes do usuário abrir | `src=` em container com `display:none` |
| Páginas faltando no sitemap | Rotas do projeto vs entradas do sitemap comparadas |
| Edição aplicada na source mas não no deploy | Diff entre `source/` e `_release/` |

### Exemplo de resultado

```
🚨 CRÍTICO — Corrigir antes do próximo deploy

   [empregos/index.html] Canonical aponta para /empregos/index.html
   O Google está indexando a versão .html. Toda a autoridade de link está dividida.
   Correção: <link rel="canonical" href="https://seusite.com/empregos/">

   [servicos/index.html linha 8189] Risco de loop de redirect
   mobStart() redireciona todos os prestadores autenticados para /servicos/?painel=prestador
   — incluindo usuários desktop. Isso dispara em cada carregamento de página, não só mobile.
   Correção: adicionar verificação de dispositivo antes do redirect.

⚠️  ALTO — Corrigir essa semana

   [sitemap.xml] 3 URLs usam extensão .html — deveriam ser URLs limpas
   [empregos/empresa.html] Acessível via ?slug= com valor vazio — retorna 200
   Deveria redirecionar para /empregos/ com 301.
```

### Instala a Skill de Auditoria de Projeto (usuários do Cowork)

**[Baixar project-auditor.skill](./project-auditor.skill)**

No Cowork: Configurações → Skills → Instalar de arquivo → `project-auditor.skill`

---

## Como funciona

**Parte 1 (GSC)** usa o [suganthan-gsc-mcp](https://www.npmjs.com/package/suganthan-gsc-mcp) — um servidor MCP local rodando via `npx`. Autentica com OAuth do Google e expõe 20 ferramentas do Search Console para o Claude. Seus dados nunca saem da sua máquina.

**Parte 2 (Auditoria de código)** usa o acesso a arquivos nativo do Claude no Cowork ou Claude Code. Sem MCP extra. O Claude lê seus arquivos diretamente e roda análises em ambiente Linux isolado.

```
Parte 1: Claude ←→ Servidor MCP (local) ←→ API do Google Search Console
Parte 2: Claude ←→ Pasta do seu projeto (acesso direto a arquivos)
Ambos:  Claude cruza dados do GSC + achados no código
```

---

## Solução de problemas (Parte 1)

**"MCP server not connected"** → Reinicia o Claude Desktop depois de rodar o script.

**"Authorization error"** → Refaz o fluxo OAuth. Às vezes precisa de uma segunda tentativa.

**"Site not found"** → Verifica `GSC_SITE_URL` na config. Propriedades de domínio: `sc-domain:seudominio.com`. URL prefix: `https://seudominio.com/`.

**Node.js não encontrado após instalar** → Fecha e reabre o terminal depois de instalar.

---

## Contribuir

Encontrou um prompt de análise melhor? Um padrão de bug que vale adicionar ao auditor? Abre um PR.

---

## Licença

MIT — usa, faz fork, compartilha.

---

*Feito por [Fernandes](https://github.com/sabnck) enquanto fazia análise de SEO real e auditoria de código com o Claude.*  
*Os problemas nos exemplos acima foram encontrados em um site de produção real.*
