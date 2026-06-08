# 🔍 Conecta o Claude ao Google Search Console em 5 Minutos

> Sem dashboards. Sem exportar CSV. Sem ferramentas de SEO. Só perguntar ao Claude diretamente.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Funciona com Claude Desktop](https://img.shields.io/badge/Claude-Desktop-orange)](https://claude.ai/download)
[![Compatível com MCP](https://img.shields.io/badge/MCP-Compatible-blue)](https://modelcontextprotocol.io)

---

## O que é isso

Uma configuração de 5 minutos que conecta o **Claude Desktop** (gratuito) aos seus dados do **Google Search Console** usando MCP (Model Context Protocol).

Depois de conectado, o Claude consegue ver os seus números reais de tráfego e responder como um analista de SEO sênior — sem assinatura, sem dashboard, sem curva de aprendizado.

---

## O que você pode perguntar

```
"Por que o tráfego da minha homepage caiu 80% esse mês?"

"Quais páginas têm as piores taxas de clique?"

"Estou em 1º lugar para algumas palavras-chave mas não recebo cliques — o que está acontecendo?"

"Encontra os conteúdos que estão decaindo antes que caiam de vez."

"Quais são os ganhos rápidos mais fáceis essa semana?"

"Alguma página minha está competindo com ela mesma pela mesma busca?"
```

O Claude puxa os dados reais do Search Console e explica o que está acontecendo — em linguagem simples.

---

## O que você precisa

| Requisito | Observação |
|---|---|
| [Claude Desktop](https://claude.ai/download) | O plano gratuito funciona |
| [Node.js](https://nodejs.org) v18+ | Só instalar, ~30 segundos |
| Google Search Console | Qualquer propriedade que você gerencia |
| ~5 minutos | Sério |

---

## Como configurar

### Passo 1 — Instala o Node.js (pula se já tiver)

Baixa em [nodejs.org](https://nodejs.org) e roda o instalador. Só isso.

### Passo 2 — Cria as credenciais OAuth do Google

1. Vai em [Google Cloud Console](https://console.cloud.google.com)
2. Cria um novo projeto (pode chamar de qualquer coisa — "Claude GSC" funciona)
3. **APIs e Serviços → Biblioteca** → busca **Google Search Console API** → Ativa
4. **APIs e Serviços → Credenciais → + Criar Credenciais → ID do cliente OAuth 2.0**
5. Escolhe **Aplicativo de desktop**, coloca qualquer nome, clica em **Criar**
6. Clica em **Baixar JSON** — salva o arquivo em algum lugar que você vai lembrar

> **Primeira vez no Google Cloud Console?** O script vai te guiar em cada tela.

### Passo 3 — Roda o script de configuração

**Windows:**
```
Clica duas vezes em setup.bat
```

**Mac / Linux:**
```bash
chmod +x setup.sh && ./setup.sh
```

O script vai:
- Verificar se o Node.js está instalado
- Pedir o caminho do arquivo JSON do OAuth que você baixou
- Pedir a URL do seu site
- Escrever tudo no config do Claude automaticamente
- Te dizer exatamente o que fazer a seguir

### Passo 4 — Reinicia o Claude e autoriza

Quando o Claude abrir, vai pedir para autorizar o Google. Segue o link, aprova as permissões e pronto.

---

## Exemplo de resultado

Depois de configurar, abre o Claude e digita:

> *"Faz uma análise completa de SEO do meu site"*

O Claude vai rodar várias verificações automaticamente e responder com algo assim:

```
📊 Visão Geral (últimos 28 dias)
   Cliques: 1.247  |  Impressões: 18.432  |  CTR: 6,8%  |  Posição média: 14,2

🚨 Problema Crítico Encontrado
   Sua homepage caiu 81% em cliques nas últimas 3 semanas.
   A posição está estável em 2,9 — é um problema de CTR, não de ranking.
   O título "Bem-vindo ao nosso site" não corresponde ao que as pessoas buscaram.

⚡ Ganhos Rápidos (essa semana)
   3 páginas na posição 6-10 com muitas impressões mas CTR baixo.
   Ajustar os títulos pode recuperar ~40 cliques/semana sem link building.

📉 Decaimento de Conteúdo
   2 artigos perdendo tráfego há mais de 4 meses.
   Eles rankeiam para buscas informacionais que agora têm AI Overviews acima.
```

---

## O que o Claude consegue fazer com seus dados do GSC

| Análise | O que verifica |
|---|---|
| **Quedas de tráfego** | Compara 3 períodos, isola páginas e buscas que caíram |
| **Oportunidades de CTR** | Páginas onde seu ranking vs taxa de clique está abaixo do esperado |
| **Ganhos rápidos** | Buscas na posição 6 a 15 onde pequenas melhorias = grandes ganhos |
| **Decaimento de conteúdo** | Páginas com queda consistente há 3+ meses |
| **Canibalização** | Múltiplas URLs competindo pela mesma busca |
| **Lacunas de conteúdo** | Buscas onde você tem impressões mas não tem conteúdo real |
| **Auditoria de sitemap** | Erros, páginas faltando, problemas de cobertura |
| **Inspeção de URL** | Status de indexação, usabilidade mobile, data do último crawl |

---

## Instala a Skill Companion (usuários do Claude Cowork)

Se você usa **Claude Cowork**, instala a skill companion. Ela ensina o Claude a:
- Te guiar pela configuração passo a passo
- Rodar as análises certas automaticamente para a sua situação
- Entregar um relatório estruturado em vez de um dump de dados brutos

**[Baixar gsc-analyst.skill](./gsc-analyst.skill)**

No Cowork: Configurações → Skills → Instalar de arquivo → seleciona `gsc-analyst.skill`

---

## Como funciona (técnico)

Usa o [suganthan-gsc-mcp](https://www.npmjs.com/package/suganthan-gsc-mcp), um servidor MCP local que roda na sua máquina via `npx`. Ele se autentica com o Google usando suas credenciais OAuth e expõe 20 ferramentas do Search Console para o Claude via Model Context Protocol.

**Seus dados nunca saem da sua máquina.** O servidor MCP roda localmente, fala direto com a API do Google, e passa os dados para o Claude Desktop (também local). Nada passa por nenhum serviço de terceiros.

```
Claude Desktop ←→ Servidor MCP (local, npx) ←→ API do Google Search Console
```

---

## Solução de problemas

**"MCP server not connected" no Claude**
→ Certifica que reiniciou o Claude Desktop depois de rodar o script.

**"Authorization error" na primeira conexão**
→ Refaz o fluxo de autorização do Google. Às vezes precisa de uma segunda tentativa.

**"Site not found" ou dados errados**
→ Abre o arquivo de config do Claude e verifica o valor de `GSC_SITE_URL`. Propriedades de domínio usam `sc-domain:seudominio.com`, propriedades de prefixo de URL usam `https://seudominio.com/`.

**Node.js não encontrado após instalar**
→ Fecha e reabre o terminal/prompt de comando depois de instalar o Node.js.

---

## Contribuir

Encontrou um prompt melhor? Uma análise mais útil? Abre um PR — isso foi feito para crescer.

---

## Licença

MIT — usa, faz fork, compartilha.

---

*Feito por [Fernandes](https://github.com/sabnck) enquanto fazia análise de SEO real com o Claude.*  
*As análises nos exemplos acima são resultados reais de uma auditoria de site ao vivo.*
