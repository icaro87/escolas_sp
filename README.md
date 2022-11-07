# Dados Escolas Est. de São Paulo

# Análise exploratória e inferencial

Icaro Pinheiro - Estatístico e Analista de dados
2022-10-31

# 1 Contexto
Os dados fornecidos, são de pontuações obtidas das escolas do estado de São Paulo dos anos de 2017 e 2019, separados em dois grupos (0,1).

# 1.1 Objetivo
Este estudo tem por finalidade construir uma análise estatística de modo a comparar os grupos e os anos dentro dos grupos, sob o ponto de vista das pontuações de cada escola.

# 2 Pacotes

![image](https://user-images.githubusercontent.com/72531841/200220133-76497182-ae99-44b4-93c4-ccbec4dc0765.png)

# 3 Carregando arquivos

![image](https://user-images.githubusercontent.com/72531841/200220203-573a37bc-b31a-49c7-ab48-9a68798f2cfc.png)

# 4 Padronização e limpeza

![image](https://user-images.githubusercontent.com/72531841/200220275-0f524822-3ed6-4596-8a47-2e61336adbc0.png)

![image](https://user-images.githubusercontent.com/72531841/200220320-325d77de-ac90-4047-92a2-878028de9964.png)

# 5 Transformação

Dados de pontuação.

![image](https://user-images.githubusercontent.com/72531841/200220406-b6cf8187-2916-46c9-8b9a-af6847e37dec.png)

Dados do Inepdata.

![image](https://user-images.githubusercontent.com/72531841/200220464-bdbae7a2-ad9c-404d-aba2-dca8759415fa.png)

# 6 EDA

Vamos explorar os dados para conhecer como estão estruturados.

![image](https://user-images.githubusercontent.com/72531841/200220550-7cfed52c-c62a-4f38-aab5-4a507abfd02e.png)

# 6.1 Escolas e municípios

A quantidade de escolas e municípios envolvidos neste estudo.

Primeiro, olhando o todo.

![image](https://user-images.githubusercontent.com/72531841/200220923-04899a06-a74f-4b8f-81f1-098c5bebe536.png)

Podemos notar um crescimento no número de escolas avaliadas de um ano para outro na ordem de 50.42%.

Parece que há algumas escolas que não foram avaliadas nos dois anos. Vamos averiguar?

![image](https://user-images.githubusercontent.com/72531841/200220979-e011a5a9-fffc-41a6-81a9-07ea06301dbe.png)

Então, foram 1848 escolas avaliadas nos 2 anos. 157 avaliadas apenas em 2017 e 1168 somente em 2019.

# 6.2 Análise dos grupos

Resumo da nossa variável de interesse.

![image](https://user-images.githubusercontent.com/72531841/200221060-2fd4a9fd-6717-4196-a239-107c9ad4f3a3.png)

Resumo por grupo e ano. (número de escolas únicas)

![image](https://user-images.githubusercontent.com/72531841/200221125-7e5db306-8fad-4d77-a77d-a0ab4a60c772.png)

**Highlights:**

91,8% avaliações são de escolas do grupo 0 e 8,2% do grupo 1.

A pontuação mínima é zero e a máxima é de 180,45.

Q3 ou tereiro quartil = 55,07, isso significa que 75% das escolas avaliadas em 17/19, tiveram pontuação de até este valor.

A média geral é de 38,31 e mediana é de 35,57. Quando a média é maior que a mediana, indica que há possibilidade da distribuição ter assimetria à direita, que possívelmente há valores discrepantes, que nesse caso podem ser algumas escolas com alta pontuação.

Olhando para as medidas estatísticas por grupo, podemos observar que a pontuação média é melhor no grupo 1, porém com ~ 18% variabilidade maior indicando menor consistência dos dados. Essa variabilidade pode ser explicada pelos valores discrepantes comentado no item anterior.

Quando observamos os grupos por ano, podemos perceber que as pontuações médias melhoram de 2017 para 2019, algo em torno 12%. E variação muda muito pouco de ano contra ano.

# 6.3 Análise gráfica - Box plot

Entre grupos, independente do ano.

![image](https://user-images.githubusercontent.com/72531841/200221204-e7644328-224e-49fa-abde-21d153c3f6df.png)

Entre os grupos, observamos que o grupo 1 apresenta uma performance discretamente melhor.

Intra grupos (por ano).

![image](https://user-images.githubusercontent.com/72531841/200221272-02a2969a-d6af-4989-bfa6-d4df47189d16.png)

Olhando para os anos dentro dos grupos, podemos afirmar que houve uma pequena melhora na pontuação das escolas de 2019 em relação a 2017.

Porém, tanto na análise entre grupos e dentro do grupo, essa diferença aparenta não ser estatísticamente significativa. Para tirar a prova, vamos aplicar um teste estatístico de hipótese comparando as médias por grupo e dentro dos grupos.

# 7 Inferência para duas populações

Para fazer inferência no caso, vamos aplicar o teste t. Esse teste faz a comparação entre as médias de duas populações que podem ser dependentes ou independentes.

Como observamos lá no início deste estudo, temos apenas 1848 escolas com avaliação em 2017 e 2019 do total de 3173, então precisamos separar nossa análise em amostras pareadas e independentes, pois a técnica empregada muda conforme o tipo de amostra que temos disponível.

# 7.1 Separando as escolas

Vamos começar identificando e separando aquelas com avaliação nos dois períodos e daquelas com avaliação apenas em um deles.

![image](https://user-images.githubusercontent.com/72531841/200221331-1d95a170-848b-44e8-901e-58ce1f8b24d3.png)

![image](https://user-images.githubusercontent.com/72531841/200221367-41710342-0dd8-4ae2-856f-5030f9cca0c3.png)

# 7.2 Pontuação por grupo e ano

# 7.2.1 Teste T dependente

Vamos iniciar o teste t de Student para categoria das escolas que foram avaliadas nos dois períodos.

# 7.2.1.1 Entre anos - Grupo zero

![image](https://user-images.githubusercontent.com/72531841/200221437-34808c69-03ed-43e7-8da0-3c7f7f03ca33.png)

Apesar do teste de normalidade não ter apresentado normalidade nos dados, o histograma mostra que a distribuição tem um formato próximo de uma normal, além disso as médias e medianas -2.767 e -2.814 respectivamente, são bem próximos, que reforça a ideia de normalidade.

![image](https://user-images.githubusercontent.com/72531841/200221515-0e068d1a-eb83-4fd5-92df-eff75595a0e7.png)

![image](https://user-images.githubusercontent.com/72531841/200221549-6be3e76b-2e80-4165-845c-0fae45be4b49.png)

Portanto, há diferença estatísticamente significativa ao nível de 5% entre as amostras de 2017 e 2019 do grupo zero.

# 7.2.1.2 Entre anos - Grupo um

![image](https://user-images.githubusercontent.com/72531841/200221585-86e0da75-2e76-4258-8908-627fd75c72a8.png)

![image](https://user-images.githubusercontent.com/72531841/200221612-25e96255-045b-4609-ab9f-f23fd0433db2.png)

![image](https://user-images.githubusercontent.com/72531841/200221647-9ca20615-ce21-4f78-882c-c58deba8da2a.png)

Portanto, há evidência de diferença significativa ao nível de 5% entre as amostras de 2017 e 2019 também do grupo um.

# 7.2.2 Teste T independente

Agora o teste t para amostras independentes, ou seja, para as escolas que foram avaliadas em 2017 ou 2019.

Primeiramente, vamos salvar os dados em um novo objeto.

![image](https://user-images.githubusercontent.com/72531841/200221816-7043e105-e74a-42f5-b3d8-ecbed453c324.png)

# 7.2.2.1 Entre grupos

O teste t para amostras independentes exige uma análise dos pressupostos e que estes sejam validados para garantir a integridade dos resultados.

![image](https://user-images.githubusercontent.com/72531841/200221896-325f2dcd-be0c-4d0c-a7b8-7b1f1b4937b9.png)

![image](https://user-images.githubusercontent.com/72531841/200222193-9acd2b07-b002-466e-9bb3-d58e8388f935.png)

![image](https://user-images.githubusercontent.com/72531841/200222235-9ff21cea-704c-4afb-876f-bb5c626cc669.png)

O pressuposto de normalidade entre grupos não foi atendida, no entanto, o tamanho da amostra é grandemente suficiente para assumirmos que a distribuição dos dados se proxima de uma distribuição normal.

Quanto ao teste, o output nos informa que a estatística t = -2,3535 e um p-valor menor que 5%. Isso nos leva a rejeitar a hipótese nula em favor da alternativa e nos faz concluir que há diferença estatísticamente significativa entre os grupos quanto a pontuação das escolas. Como vimos no gráfico, podemos afirmar que o grupo 1 de escolas obteve melhor pontuação que o grupo 0.

# 7.3 Pontuação por localização e ano

Neste tópico vamos comparar a pontuação das escolas quanto a localização (rural, urbana). Será que as escolas em locais urbanos tem melhor pontuação?

# 7.3.1 Cruzando bases

![image](https://user-images.githubusercontent.com/72531841/200222377-cd3a7224-078a-4da5-9543-55b16a23816c.png)

# 7.3.2 Teste T dependente

# 7.3.2.1 Entre anos - Área Urbana

![image](https://user-images.githubusercontent.com/72531841/200222473-90386854-918f-4a38-93c9-cc5b5ed4a2b4.png)

Apesar do teste de normalidade não ter apresentado normalidade nos dados, o histograma mostra que a distribuição tem um formato próximo de uma normal, além disso as médias e medianas -3.149 e -2.942 respectivamente, são bem próximos, que reforça a ideia de normalidade.

![image](https://user-images.githubusercontent.com/72531841/200222521-074ef731-5267-491a-b015-6ca6edaecffe.png)

![image](https://user-images.githubusercontent.com/72531841/200222615-11282777-97a7-4143-9034-1f165dbd0771.png)

Portanto, há diferença estatisticamente significativa ao nível de 5% entre as amostras de 2017 e 2019 da área urbana.

# 7.3.2.2 Entre anos - Área Rural

![image](https://user-images.githubusercontent.com/72531841/200222702-33b50178-eef7-4d27-9ca4-08be57e5ea20.png)

![image](https://user-images.githubusercontent.com/72531841/200223366-406c8368-2de5-47cc-ad9c-3570a8eb5e22.png)

![image](https://user-images.githubusercontent.com/72531841/200223403-9301e3f7-486b-4f9f-abfd-a790e24116c7.png)

Portanto, não há diferença estatisticamente significativa ao nível de 5% entre as amostras de 2017 e 2019 da área rural.

# 7.3.3 Teste T independente

# 7.3.3.1 Entre Áreas

![image](https://user-images.githubusercontent.com/72531841/200223455-71f62686-138d-4401-b76e-ea4c876f1633.png)

![image](https://user-images.githubusercontent.com/72531841/200223494-48cd0fa9-5205-417a-ab27-213858b9cb76.png)

![image](https://user-images.githubusercontent.com/72531841/200223525-484f2c4c-9edc-4179-8856-14a9118bba96.png)

O pressuposto de normalidade entre as áreas não foi atendida, no entanto, o tamanho da amostra é grandemente suficiente para assumirmos que a distribuição dos dados se proxima de uma distribuição normal.

Quanto ao teste, o output nos informa que a estatística t = -3,1186 e um p-valor maior que 5%. Isso implica em não rejeitar a hipótese nula em favor da alternativa e nos faz concluir que há diferença estatísticamente significativa entre as áreas quanto a pontuação das escolas.

# 8 Resumo de atividades

Vamos listar neste tópico todo o processo analítico realizado.

Captura, carga, transformação, limpeza e padronização.

Análise exploratória dos dados.

Inferência estatística em duas populações (amostras dependentes e independentes).

Conclusão.

# 9 . Final
Ao fim de estudo, obtivemos os seguintes resultados.

Ano contra ano para ambos os grupos(0,1), a diferença observada foi estatísticamente significativa, ou seja, houve uma melhora importante na pontuação média das escolas de 2017 para 2019.

Entre os grupos(0,1) também tivemos um diferença estatísticamente singificativa e o grupo com melhor performance é o 1.

No ano contra ano apenas para as escolas de área urbana, a diferença observada foi relevante, ponto de vista estatístico.

Entre as áreas(urbana, rural) tivemos um diferença estatísticamente singificativa e as escolas da área urbana tiveram a melhor pontuação média.

# 10 Links úteis e referências

<https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/inep-data>

<https://www.geeksforgeeks.org/how-to-change-legend-title-in-ggplot2-in-r/>

<https://www.datanovia.com/en/blog/ggplot-legend-title-position-and-labels/>

Morettin, Pedro Alberto, 1942 - Estatística básica / Pedro A. Morettin, Wilton O. Bussab. - 9. ed. São Paulo: Saraiva, 2017.

Alcoforado, Luciane Ferreira - Utilizando a Linguagem R: Conceitos, Mnipulação, Visualização, Modelagem e Elaboração de Relatórios / Luciane Ferreira Alcoforado - Rio de Janeiro: Alta Books, 2021.
