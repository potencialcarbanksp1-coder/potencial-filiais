# GCM Panel — Guia de Deploy

Painel de agrupamento de lojas por região com cálculo de GCMs necessários.

---

## Arquivos do Projeto

```
gcm-painel/
├── index.html      ← Aplicação completa (único arquivo)
├── schema.sql      ← Script SQL para criar a tabela no Supabase
├── netlify.toml    ← Configuração do Netlify
└── README.md       ← Este guia
```

---

## Passo 1 — Configurar o Supabase

1. Acesse [supabase.com](https://supabase.com) e crie um projeto gratuito
2. Vá em **SQL Editor** e cole o conteúdo do arquivo `schema.sql`
3. Clique em **Run** — a tabela `lojas` será criada
4. Anote suas credenciais em **Settings → API**:
   - **Project URL** → ex: `https://abcxyz.supabase.co`
   - **anon (public) key** → chave longa começando com `eyJ...`

---

## Passo 2 — Publicar no Netlify

### Opção A — Arrastar e soltar (mais rápido)
1. Acesse [app.netlify.com](https://app.netlify.com)
2. Faça login (pode usar GitHub)
3. Na tela inicial, arraste a **pasta `gcm-painel`** para a área de deploy
4. Pronto! O Netlify gera uma URL pública automaticamente

### Opção B — Via GitHub (recomendado para atualizações)
1. Crie um repositório no GitHub e suba os arquivos
2. No Netlify: **Add new site → Import an existing project → GitHub**
3. Selecione o repositório → Netlify detecta o `netlify.toml` e publica
4. A cada `git push` o site é atualizado automaticamente

---

## Passo 3 — Usar o Painel

### Upload
1. Abra o site → aba **Upload**
2. Cole a **Supabase URL** e a **Anon Key**
3. Clique na área de drop ou selecione seu arquivo `.xlsx`
4. Clique em **Importar para Supabase**
5. Aguarde o log mostrar "Importação concluída"

### Painel
1. Clique em **Painel** no menu lateral
2. Os dados são carregados automaticamente do Supabase
3. Use a barra de pesquisa para filtrar regiões
4. A coluna **GCMs** mostra quantos funcionários cabem por região
   - 🟢 1 GCM  |  🟡 2 GCMs  |  🔵 3+ GCMs

---

## Lógica de Cálculo GCM

```
GCMs por região = ARREDONDA_PARA_CIMA( VOL_LEVES_PERFIL_CB / 25.000.000 )
```

A meta padrão é **R$ 25 milhões** de potencial por GCM.
Você pode ajustar este valor no campo **Meta GCM (R$)** antes do upload.

---

## Colunas Utilizadas da Planilha

| Campo no site       | Coluna original        | Descrição              |
|---------------------|------------------------|------------------------|
| `regiao`            | REGIAO (col Q)         | Agrupamento principal  |
| `vol_leves_perfil_cb` | VOL_LEVES_PERFIL_CB (col AJ) | Volume CB R$   |
| `qt_leves_cb`       | QT_LEVES_CB (col AR)   | Contratos CB           |

---

## Dúvidas Frequentes

**A importação dá erro de permissão?**
Verifique se o RLS (Row Level Security) está configurado conforme o `schema.sql`.
Em ambiente de desenvolvimento, você pode desativar o RLS temporariamente.

**Posso reimportar a planilha?**
Sim. O sistema usa `upsert` com `cnpj_loja` como chave única — dados existentes são atualizados, novos são inseridos.

**Como adicionar mais usuários?**
Configure autenticação no Supabase (Auth → Users) e ajuste as policies RLS no `schema.sql`.
