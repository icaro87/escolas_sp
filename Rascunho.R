
# Teste Mind Lab ----------------------------------------------------------


# Carregando pacotes ------------------------------------------------------

library(tidyverse)
library(openxlsx)
library(janitor)
library(knitr)
library(kableExtra)
library(rmarkdown)
library(patchwork)
library(RVAideMemoire)
library(car)


# Carregando a base -------------------------------------------------------

# abrindo arquivo 2017
dados_2017 = 
  tibble(
    read.xlsx(
      xlsxFile = "Dados Escolas - Exemplo.xlsx",
      sheet = "data2017"
    )
  )

# abrindo arquivo 2019
dados_2019 = 
  tibble(
    read.xlsx(
      xlsxFile = "Dados Escolas - Exemplo.xlsx",
      sheet = "data2019"
    )
  )


# arquivo inepdata
catalogo = 
  tibble(
    read.csv(
      file = "Análise - Tabela da lista das escolas - Detalhado.csv",
      sep = ";",
      encoding = "UTF-8"
    )
  )


dados_2017
dados_2019

# resumo
glimpse(dados_2017)
glimpse(dados_2019)



# padronização e limpeza -----------------------------------------------------------

# 2017
dados_2017 = dados_2017 %>% clean_names()

# 2019
dados_2019 = dados_2019 %>% clean_names()

# catalogo
catalogo = catalogo %>% clean_names()

# resumo
glimpse(dados_2017)
glimpse(dados_2019)
glimpse(catalogo)



# transformação -----------------------------------------------------------


# criando o campo ano
dados_2017 = 
  dados_2017 %>% 
  mutate(ano = 2017)

dados_2019 = 
  dados_2019 %>% 
  mutate(ano = 2019)

# juntando as bases
dados = bind_rows(dados_2017, dados_2019)

# padronizando os campos
dados = 
  dados %>% 
  mutate(codigo_da_escola_inep = as.character(codigo_da_escola_inep),
         codigo_do_municipio = as.character(codigo_do_municipio),
         nome_da_escola = str_to_title(nome_da_escola),
         grupo = as.factor(grupo),
         ano = as.factor(ano),
         local = ifelse(nome_do_municipio == 'São Paulo', 'Capital', 'Interior'))

glimpse(dados)


catalogo = 
  catalogo %>% 
  select(
    codigo_inep, 
    localizacao,
    dependencia_administrativa,
    categoria_administrativa, 
    porte_da_escola,
    etapas_e_modalidade_de_ensino_oferecidas
  ) %>% 
  rename(
    codigo_da_escola_inep = codigo_inep, 
    esfera_adm = dependencia_administrativa,
    categoria = categoria_administrativa, 
    porte = porte_da_escola,
    modalidade = etapas_e_modalidade_de_ensino_oferecidas
  ) %>% 
  mutate(
    codigo_da_escola_inep = as.character(codigo_da_escola_inep),
    porte = 
      str_replace(
        porte, 
        pattern = " de escolarização",
        replacement = ""
      )
  )

# ver como ficou
glimpse(catalogo)




# EDA ---------------------------------------------------------------------


## Escolas e municípios
dados %>% 
  select(starts_with("codigo")) %>% # campos que iniciam com a palavra codigo
  summarise(escolas = n_distinct(codigo_da_escola_inep),
            municipios = n_distinct(codigo_do_municipio))


dados %>% 
  select(starts_with("codigo"), ano) %>% # campos que iniciam com a palavra codigo
  group_by(ano) %>% 
  summarise(escolas = n_distinct(codigo_da_escola_inep),
            municipios = n_distinct(codigo_do_municipio))



tibble(
  '2017' = 
    length(setdiff(dados_2017$codigo_da_escola_inep, dados_2019$codigo_da_escola_inep)),
  '2019' = 
    length(setdiff(dados_2019$codigo_da_escola_inep, dados_2017$codigo_da_escola_inep)),
  '2017/19' = 
    length(intersect(dados_2017$codigo_da_escola_inep, dados_2019$codigo_da_escola_inep))
)



## Análise dos grupos


summary(dados[, "pontuacao"])


dados %>% 
  tabyl(grupo) %>% 
  adorn_pct_formatting() %>% 
  adorn_totals()



dados %>% 
  group_by(grupo, ano) %>% 
  summarise(avaliacoes = n(),
            percents = paste(round(avaliacoes / 5021 * 100, 2), "%", sep = "")) %>% 
  adorn_totals()



dados %>% 
  group_by(grupo) %>% 
  summarise(
    media = mean(pontuacao), 
    mediana = median(pontuacao), 
    sd = sd(pontuacao), 
    'total escolas' = n_distinct(codigo_da_escola_inep))




dados %>% 
  group_by(grupo, ano) %>% 
  summarise(
    media = mean(pontuacao), 
    mediana = median(pontuacao), 
    sd = sd(pontuacao), 
    'total escolas' = n()) 


## Análise gráfica - Box plot


dados %>% 
  ggplot(aes(x = grupo, y = pontuacao)) + 
  geom_boxplot() + 
  labs(
    title = "Comparação dos grupos",
    subtitle = "Pontuação das escolas de SP em 2017 e 2019",
    x = "Grupo",
    y = "Pontuação"
  ) + 
  theme_gray()



dados %>% 
  ggplot(aes(x = grupo, y = pontuacao, col = ano)) + 
  geom_boxplot() + 
  labs(
    title = "Comparação intra grupos",
    subtitle = "Pontuação das escolas de SP por ano",
    x = "Grupos",
    y = "Pontuação"
  ) + 
  guides(color = guide_legend(title = "Ano")) +
  theme_gray()



# Inferência para duas populações -----------------------------------------



## Separando as escolas



only_17 = 
  tibble(
    codigo_da_escola_inep = 
      as.character(setdiff(dados_2017$codigo_da_escola_inep, dados_2019$codigo_da_escola_inep)),
    only_2017 = "only 2017"
  )


only_19 = 
  tibble(
    codigo_da_escola_inep = 
      as.character(setdiff(dados_2019$codigo_da_escola_inep, dados_2017$codigo_da_escola_inep)),
    only_2019 = "only 2019"
  )


two_period = 
  tibble(
    codigo_da_escola_inep = 
      as.character(intersect(dados_2017$codigo_da_escola_inep, dados_2019$codigo_da_escola_inep)),
    two_period = "two period"
  )



# marcando as escolas conforme o grupo
dados = 
  left_join(x = dados, y = only_17, by = "codigo_da_escola_inep")


dados = 
  left_join(x = dados, y = only_19, by = "codigo_da_escola_inep")


dados = 
  left_join(x = dados, y = two_period, by = "codigo_da_escola_inep")


dados_2p_0 = 
  dados %>% 
  filter(two_period == 'two period', grupo == 0) %>% 
  pivot_wider(names_from = 'ano', values_from = 'pontuacao')

# grupo um
dados_2p_1 = 
  dados %>% 
  filter(two_period == 'two period', grupo == 1) %>% 
  pivot_wider(names_from = 'ano', values_from = 'pontuacao')



## Pontuação por grupo e ano

### Teste T dependente


# Passo 1: Verificacao da normalidade dos dados

# diferenças - grupo 0
dados_2p_0$Diferenca1719 <- dados_2p_0$'2017' - dados_2p_0$'2019'

# teste de normalidade
shapiro.test(dados_2p_0$Diferenca1719)

hist(dados_2p_0$Diferenca1719, 
     main = "Histograma da diferença de pontuação",
     xlab = "Diferença")


# Passo 2: Realizacao do teste t pareado

# test t
t.test(dados_2p_0$'2017', dados_2p_0$'2019', paired = TRUE)



# Passo 3: análise gráfica (box plot)
dados %>% 
  filter(two_period == "two period", grupo == 0) %>% 
  ggplot(aes(x = grupo, y = pontuacao, col = ano)) + 
  geom_boxplot() + 
  labs(
    title = "Comparação intra grupos",
    subtitle = "Pontuação das escolas de SP por ano - Grupo zero",
    x = "Grupo",
    y = "Pontuação"
  ) + 
  guides(color = guide_legend(title = "Ano")) +
  theme_gray()



# Passo 1: Verificacao da normalidade dos dados

# diferenças - grupo 1
dados_2p_1$Diferenca1719 = dados_2p_1$'2017' - dados_2p_1$'2019'

# teste de normalidade
shapiro.test(dados_2p_1$Diferenca1719)

hist(dados_2p_1$Diferenca1719, 
     main = "Histograma da diferença de pontuação",
     xlab = "Diferença")


# Passo 2: Realizacao do teste t pareado

# test t
t.test(dados_2p_0$'2017', dados_2p_0$'2019', paired = TRUE)



# Passo 3: análise gráfica (box plot)
dados %>% 
  filter(two_period == "two period", grupo == 1) %>% 
  ggplot(aes(x = grupo, y = pontuacao, col = ano)) + 
  geom_boxplot() + 
  labs(
    title = "Comparação intra grupos",
    subtitle = "Pontuação das escolas de SP por ano - Grupo Um",
    x = "Grupo",
    y = "Pontuação"
  ) + 
  guides(color = guide_legend(title = "Ano")) +
  theme_gray()



### Teste T independente


# Passo 1: Verificação da normalidade dos dados

## Shapiro por grupo (pacote RVAideMemoire)

byf.shapiro(pontuacao ~ grupo, dados_ind)


# Passo 2: Verificação da homogeneidade de variâncias

## Teste de Levene

### H0: as variâncias dos grupos são homogêneas

leveneTest(pontuacao ~ grupo, data = dados_ind, center = mean)


# Observação:
# Por default, o teste realizado pelo pacote car tem como base a mediana (median).
# O teste baseado na mediana é mais robusto.
# Mudamos para ser baseado na média.


# Passo 3: Realização do teste t para amostras independentes

## H0: média grupo 0 = média grupo 1

t.test(
  pontuacao ~ grupo,
  data = dados_ind,
  var.equal = TRUE, # Mesma variância, Desconhecida (Homogêneas)
  conf.level = 0.95
)


# Passo 4: Visualização da distribuição dos dados

boxplot(
  pontuacao ~ grupo, 
  data = dados_ind,
  main = "Pontuação das escolas por grupos",
  ylab = "Pontuação", 
  xlab = "Grupos"
)




## Pontuação por localização e ano



# cruzar com base inteira
dados = 
  left_join(
    x = dados,
    y = catalogo,
    by = "codigo_da_escola_inep"
  )


# gerar base de escolar com avaliação em 17 e 19

# escolas urbanas
dados_2p_urb = 
  dados %>% 
  filter(two_period == 'two period', localizacao == "Urbana") %>% 
  pivot_wider(names_from = 'ano', values_from = 'pontuacao')


# escolas rurais
dados_2p_ru = 
  dados %>% 
  filter(two_period == 'two period', localizacao == "Rural") %>% 
  pivot_wider(names_from = 'ano', values_from = 'pontuacao')


# cruzar com base de escolas com avaliação em um dos anos
dados_ind = 
  left_join(
    x = dados_ind,
    y = catalogo,
    by = "codigo_da_escola_inep"
  )



### Teste T dependente



# Passo 1: Verificacao da normalidade dos dados

# diferenças - área urbana
dados_2p_urb$Diferenca1719 <- dados_2p_urb$'2017' - dados_2p_urb$'2019'

# teste de normalidade
shapiro.test(dados_2p_urb$Diferenca1719)

hist(dados_2p_urb$Diferenca1719, 
     main = "Histograma da diferença de pontuação",
     xlab = "Diferença")



# Passo 2: Realizacao do teste t pareado

# test t
t.test(dados_2p_urb$'2017', dados_2p_urb$'2019', paired = TRUE)



# Passo 3: análise gráfica (box plot)
dados %>% 
  filter(two_period == "two period", localizacao == "Urbana") %>% 
  ggplot(aes(x = localizacao, y = pontuacao, col = ano)) + 
  geom_boxplot() + 
  labs(
    title = "Comparação intra grupos",
    subtitle = "Pontuação das escolas de SP por ano - Área Urbana",
    x = "Área",
    y = "Pontuação"
  ) + 
  guides(color = guide_legend(title = "Ano")) +
  theme_gray()


# Passo 1: Verificacao da normalidade dos dados

# diferenças - área rural
dados_2p_ru$Diferenca1719 <- dados_2p_ru$'2017' - dados_2p_ru$'2019'

# teste de normalidade
shapiro.test(dados_2p_ru$Diferenca1719)

hist(dados_2p_ru$Diferenca1719, 
     main = "Histograma da diferença de pontuação",
     xlab = "Diferença")


# Passo 2: Realizacao do teste t pareado

# test t
t.test(dados_2p_ru$'2017', dados_2p_ru$'2019', paired = TRUE)



# Passo 3: análise gráfica (box plot)
dados %>% 
  filter(two_period == "two period", localizacao == "Rural") %>% 
  ggplot(aes(x = localizacao, y = pontuacao, col = ano)) + 
  geom_boxplot() + 
  labs(
    title = "Comparação intra grupos",
    subtitle = "Pontuação das escolas de SP por ano - Área Rural",
    x = "Área",
    y = "Pontuação"
  ) + 
  guides(color = guide_legend(title = "Ano")) +
  theme_gray()



# Passo 1: Verificação da normalidade dos dados

## Shapiro por grupo

byf.shapiro(pontuacao ~ localizacao, dados_ind)


# Passo 2: Verificação da homogeneidade de variâncias

## Teste de Levene

### H0: as variâncias dos grupos são homogêneas

leveneTest(pontuacao ~ localizacao, data = dados_ind, center = mean)


# Passo 3: Realização do teste t para amostras independentes

## H0: média grupo 0 = média grupo 1

t.test(
  pontuacao ~ localizacao,
  data = dados_ind,
  var.equal = TRUE, # Mesma variância, Desconhecida (Homogêneas)
  conf.level = 0.95
)


# Passo 4: Visualização da distribuição dos dados

boxplot(
  pontuacao ~ localizacao, 
  data = dados_ind,
  main = "Pontuação das escolas por localização",
  ylab = "Pontuação", 
  xlab = "Áreas"
)


