# 🔍 Deixa o Claude Corrigir seu Site — Dados de Tráfego + Auditoria de Código + Correções, Tudo de Uma Vez

> Você não precisa saber o que está errado. O Claude encontra, explica e corrige.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Funciona com Claude Desktop](https://img.shields.io/badge/Claude-Desktop-orange)](https://claude.ai/download)
[![Compatível com MCP](https://img.shields.io/badge/MCP-Compatible-blue)](https://modelcontextprotocol.io)
[![English](https://img.shields.io/badge/Read%20in-English%20%F0%9F%87%BA%F0%9F%87%B8-0057b7)](README.md)

---

## O que é isso

Você dá ao Claude duas coisas: acesso ao seu **Google Search Console** (dados de tráfego em tempo real) e acesso à sua **pasta de projeto** (seus arquivos reais). Depois pergunta "o que está errado no meu site?"

O Claude faz o resto, tudo ao mesmo tempo. Lê seus dados de tráfego e seu código simultaneamente, conecta os pontos, encontra o que está te prejudicando e já corrige diretamente nos arquivos.

Uma conversa. Sem precisar saber de SEO. Sem precisar saber de programação.

---

## O que acontece depois da configuração

Você pergunta: *"O que está errado no meu site?"*

O Claude, trabalhando em paralelo:

- Puxa 28 dias de dados do Google Search Console: cliques, impressões, posições, alertas
- Lê seus arquivos HTML: títulos, meta descrições, canonical, tags OG, schema markup
- Lê seu sitemap e verifica cada URL em busca de problemas
- Escaneia seu JavaScript: erros de sintaxe, lógica de redirect, fluxos de autenticação que podem estar em loop
- Cruza os dados de tráfego com o código, encontrando onde o problema que o Google vê corresponde a um bug nos seus arquivos

Depois te diz exatamente o que encontrou, por que importa, e ou corrige diretamente ou mostra a mudança exata a fazer.

---

## Exemplo real

Aqui está um trecho do que o Claude retornou em uma auditoria real:

**Dos dados de tráfego (Google Search Console):**
```
🚨 Cliques da homepage caíram 63% em 4 semanas.
   A posição está estável em 3,1. É problema de CTR, não de ranking.
   Título "Ajudamos Empresas a Crescer" não combina com nenhuma busca específica.
   Correção: substituir por um título que descreva o que você faz e para quem.
```

**Dos arquivos de código, encontrado ao mesmo tempo:**
```
🚨 [blog/index.html] Canonical aponta para /blog/index.html
   O Google vê duas versões desta página. A autoridade de link está dividida.
   Correção: <link rel="canonical" href="https://seusite.com/blog/">

🚨 [contact/index.html, linha 312] Redirect dispara para todos os usuários
   Código feito para redirecionar visitantes mobile também pega usuários desktop.
   Metade das visitas à página de contato saem antes da página carregar.
   Correção: adicionar verificação de largura de tela antes do redirect rodar.

⚠️  [sitemap.xml] 5 URLs usam extensão .html, o Google prefere URLs limpas
⚠️  [products/] 12 páginas de produtos estão completamente fora do sitemap
```

O Claude aplicou a correção do canonical, limpou as entradas do sitemap e adicionou a verificação de dispositivo. Tudo na mesma conversa.

---

## Configuração (5 minutos)

### Passo 1 — Instala o Node.js

Baixa em [nodejs.org](https://nodejs.org), roda o instalador, pronto. Pula se já tiver.

### Passo 2 — Cria as credenciais OAuth do Google

É isso que dá permissão ao Claude de ler seus dados do Search Console. Fica na sua máquina e nada passa por nenhum serviço de terceiros.

1. Vai em [console.cloud.google.com](https://console.cloud.google.com)
2. Cria um projeto (clica no dropdown no topo, Novo Projeto, qualquer nome)
3. **APIs e Serviços > Biblioteca**, busca "Google Search Console API", Ativa
4. **APIs e Serviços > Credenciais > + Criar Credenciais > ID do cliente OAuth 2.0**
5. Escolhe **Aplicativo de desktop**, coloca qualquer nome, Criar
6. **Baixar JSON**, salva em algum lugar permanente (não na pasta Downloads)

> Se aparecer "O Google não verificou este app": clica em **Avançado > Continuar**. É sua própria chave acessando seus próprios dados.

### Passo 3 — Roda o script de configuração

**Windows:** clica duas vezes em `setup.bat`

**Mac / Linux:** `chmod +x setup.sh && ./setup.sh`

O script pede o caminho do arquivo JSON e a URL do seu site, depois escreve tudo na config do Claude automaticamente.

### Passo 4 — Reinicia o Claude e autoriza

Na primeira vez que abrir, o Claude vai mostrar um link de autorização. Abre, entra com o Google, aprova. Pronto.

### Passo 5 — Conecta sua pasta de projeto (opcional, mas poderoso)

No **Claude Cowork**: Configurações, seleciona sua pasta de projeto.

É isso que destrava a auditoria de código. O Claude lê seus arquivos HTML, sitemaps e JavaScript e cruza com os dados de tráfego. Pode pular isso se quiser só a análise de tráfego.

---

## O que o Claude consegue verificar

| Área | O que verifica |
|---|---|
| **Quedas de tráfego** | Compara 3 períodos para isolar quando e o que caiu |
| **Problemas de CTR** | Onde sua posição é boa mas ninguém clica |
| **Ganhos rápidos** | Buscas na posição 6-15 que podem melhorar com pequenas correções |
| **Decaimento de conteúdo** | Páginas que perdem tráfego há meses |
| **Canibalização** | Múltiplas páginas competindo pela mesma busca |
| **Tags canonical** | URL errada, extensão `.html`, apontando para página errada |
| **Sitemap** | URLs mortas, páginas faltando, inconsistências de formato |
| **JavaScript** | Erros de sintaxe, loops de redirect, problemas de auth |
| **Schema markup** | Campos obrigatórios faltando para resultados ricos |
| **Consistência de deploy** | Se a source e a cópia de produção estão realmente sincronizadas |

---

## Quer que o Claude também teste seu site visualmente?

O Claude pode instalar o **Playwright**, uma ferramenta que abre um navegador real em segundo plano, e de fato carregar suas páginas, seguir redirects e tirar screenshots dos resultados para confirmar que as correções funcionaram.

Quando você pedir para o Claude auditar seu site, ele vai perguntar: *"Quer que eu também teste as páginas visualmente no navegador? Posso instalar o Playwright para isso. Ele roda em segundo plano e não abre nenhuma janela."*

Só falar sim e o Claude cuida da instalação e dos testes automaticamente.

---

## Instala as skills (usuários do Claude Cowork)

Duas skills disponíveis. Instala as duas para a experiência completa.

**GSC Analyst**, guia o Claude pela análise de tráfego com seus dados do Search Console:
**[Baixar gsc-analyst.skill](./gsc-analyst.skill)**

**Project Auditor**, guia o Claude pela auditoria de código e cruzamento com o GSC:
**[Baixar project-auditor.skill](./project-auditor.skill)**

No Cowork: Configurações > Skills > Instalar de arquivo

---

## Solução de problemas

**"MCP server not connected"** — Reinicia o Claude Desktop depois de rodar o script.

**"Authorization error"** — Refaz o fluxo OAuth do Google. Às vezes precisa de uma segunda tentativa.

**"Site not found" ou dados errados** — Verifica `GSC_SITE_URL` na config do Claude. Propriedades de domínio usam `sc-domain:seudominio.com`. URL prefix usam `https://seudominio.com/`.

**Node.js não encontrado após instalar** — Fecha e reabre o terminal depois de instalar.

**O Claude não consegue ver meus arquivos** — No Cowork, vai em Configurações e confirma que a pasta do projeto está selecionada.

---

## Como funciona (técnico)

A conexão com o GSC usa o [suganthan-gsc-mcp](https://www.npmjs.com/package/suganthan-gsc-mcp), um servidor MCP local que roda via `npx`, autentica com suas credenciais OAuth do Google e passa os dados do Search Console direto para o Claude. Nada sai da sua máquina.

A auditoria de código usa o acesso nativo a arquivos do Claude no Cowork. O Claude lê seus arquivos diretamente e roda as análises em um ambiente Linux isolado. Sem MCP extra ou ferramentas adicionais.

```
Dados de tráfego: Claude <-> servidor MCP (local, npx) <-> API do Google Search Console
Auditoria código: Claude <-> Pasta do seu projeto (acesso direto)
Combinado:        Claude conecta os dois, encontra a causa raiz, não só o sintoma
```

---

## Contribuir

Encontrou um padrão de bug que vale adicionar ao auditor? Um prompt de análise melhor? Abre um PR.

---

## Licença

MIT — usa, faz fork, compartilha.

---

*Feito por [Fernandes](https://github.com/sabnck) durante uma auditoria real de site de produção com o Claude.*
*Cada problema nos exemplos acima foi encontrado e corrigido em um site real, numa única conversa.*
