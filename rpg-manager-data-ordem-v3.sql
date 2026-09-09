--
-- PostgreSQL database dump
--

\restrict PxeIX84gvEAUa63TdrlrAeZvy74bMwun0l11E5wX4lJ2KCDP89S80zXiA6RF7WB

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: rpg_system; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.rpg_system (id, name, slug, version, description, source_ref, created_at, updated_at) FROM stdin;
1e9480ec-e177-4b33-90c7-ea576c87b9af	Ordem Paranormal RPG	ordem-paranormal	1.1	Sistema de RPG de investigação paranormal.	PDF v1.1, capa/expediente	2026-08-25 22:31:02.218979-03	2026-08-25 22:31:02.218979-03
\.


--
-- Data for Name: ability_definition; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.ability_definition (id, rpg_system_id, name, slug, ability_type, description, is_active, source_ref) FROM stdin;
25fca680-ca2e-438b-8287-5c86d2fdedfd	1e9480ec-e177-4b33-90c7-ea576c87b9af	Aumento de Atributo	aumento-de-atributo	PROGRESSION_FEATURE	Aumenta um atributo em +1; máximo 5 por esta regra.	f	PDF v1.1, pp. 25, 30 e 34
6b8ba65b-d055-49c6-a3a0-14d4b4697bc5	1e9480ec-e177-4b33-90c7-ea576c87b9af	Grau de Treinamento	grau-de-treinamento	PROGRESSION_FEATURE	Eleva o grau de treinamento de perícias conforme a classe.	f	PDF v1.1, pp. 26, 30 e 34
5f7df240-6aff-40be-a0b7-9e8f547d8d43	1e9480ec-e177-4b33-90c7-ea576c87b9af	Versatilidade	versatilidade	PROGRESSION_FEATURE	Permite escolher um poder da própria classe ou o primeiro poder de outra trilha da classe.	f	PDF v1.1, pp. 26, 30 e 34
cde3aeec-92f5-4d66-9b60-26039e172fe4	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ataque Especial	ataque-especial	CLASS_FEATURE	Habilidade-base do Combatente; evolui nos NEX 5%, 25%, 55% e 85%.	f	PDF v1.1, pp. 24-25
7e8bf815-10b4-45e2-ad51-bde9af0f0e17	1e9480ec-e177-4b33-90c7-ea576c87b9af	Eclético	ecletico	CLASS_FEATURE	Permite obter os benefícios de ser treinado em uma perícia mediante gasto de PE.	f	PDF v1.1, p. 28
c43b4e9e-cd2c-48fd-8bbd-c01c2d9f0984	1e9480ec-e177-4b33-90c7-ea576c87b9af	Perito	perito	CLASS_FEATURE	Escolhe duas perícias treinadas e permite adicionar dado de bônus mediante gasto de PE.	f	PDF v1.1, pp. 28-29
4fa86797-837f-4c88-91e9-e50fba7db071	1e9480ec-e177-4b33-90c7-ea576c87b9af	Engenhosidade	engenhosidade	CLASS_FEATURE	Aprimora Eclético para benefícios de veterano e, depois, expert.	f	PDF v1.1, p. 30
506d4184-4b4b-4f8e-baa5-5704f00917e0	1e9480ec-e177-4b33-90c7-ea576c87b9af	Escolhido pelo Outro Lado	escolhido-pelo-outro-lado	CLASS_FEATURE	Concede acesso progressivo aos círculos de rituais e aprendizado de rituais.	f	PDF v1.1, pp. 32-33
536b57d9-d6c2-452b-bf61-fdac274c8553	1e9480ec-e177-4b33-90c7-ea576c87b9af	Poder de Combatente	poder-de-combatente	CLASS_POWER_SLOT	Marco de progressão que concede uma escolha de poder de Combatente.	f	PDF v1.1, pp. 24-25
27658352-3ed4-46e5-be96-6d72dc72764d	1e9480ec-e177-4b33-90c7-ea576c87b9af	Poder de Especialista	poder-de-especialista	CLASS_POWER_SLOT	Marco de progressão que concede uma escolha de poder de Especialista.	f	PDF v1.1, pp. 28-29
9b22b069-79c9-4bac-816e-ebac2d8a11b4	1e9480ec-e177-4b33-90c7-ea576c87b9af	Poder de Ocultista	poder-de-ocultista	CLASS_POWER_SLOT	Marco de progressão que concede uma escolha de poder de Ocultista.	f	PDF v1.1, pp. 32-33
d3891e69-21ed-4de9-b515-67fe4773e8d8	1e9480ec-e177-4b33-90c7-ea576c87b9af	Artista Marcial	artista-marcial	CLASS_POWER_SHARED	Ataques desarmados melhoram e contam como armas ágeis.	f	PDF v1.1, pp. 25 e 29
1bbcae9a-3618-4233-866e-0db5a773377a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Transcender	transcender	CLASS_POWER_SHARED	Escolhe um poder paranormal; este aumento de NEX não concede Sanidade. Repetível.	f	PDF v1.1, pp. 26, 30 e 34
993551b3-99bc-4d8f-a056-0bbe0a438cb0	1e9480ec-e177-4b33-90c7-ea576c87b9af	Treinamento em Perícia	treinamento-em-pericia	CLASS_POWER_SHARED	Aprimora duas perícias; pode ser escolhido várias vezes.	f	PDF v1.1, pp. 26, 30 e 34
248d1362-407f-40e4-90f6-f7d72d64a784	1e9480ec-e177-4b33-90c7-ea576c87b9af	Armamento Pesado	armamento-pesado	CLASS_POWER	Pré-requisito: Força 2.	f	PDF v1.1, p. 25
34319ad8-a34d-4d8d-bad6-cb73dd7c604c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ataque de Oportunidade	ataque-de-oportunidade	CLASS_POWER	\N	f	PDF v1.1, p. 25
53448770-720b-42d4-8e2e-2a050b94f69f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Combater com Duas Armas	combater-com-duas-armas	CLASS_POWER	Pré-requisitos: Agilidade 3; treinado em Luta ou Pontaria.	f	PDF v1.1, p. 25
6e13b21b-503c-4afc-bc5d-7ed31d235fa7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Combate Defensivo	combate-defensivo	CLASS_POWER	Pré-requisito: Intelecto 2.	f	PDF v1.1, p. 25
078385d9-3f60-40aa-a589-9f2ef1889af8	1e9480ec-e177-4b33-90c7-ea576c87b9af	Golpe Demolidor	golpe-demolidor	CLASS_POWER	Pré-requisitos: Força 2; treinado em Luta.	f	PDF v1.1, p. 25
2f802b57-a9d2-4c41-9f8e-8323449e9d90	1e9480ec-e177-4b33-90c7-ea576c87b9af	Golpe Pesado	golpe-pesado	CLASS_POWER	\N	f	PDF v1.1, p. 25
cf6dd105-fc7a-4dcc-b2bb-672e4ede75d2	1e9480ec-e177-4b33-90c7-ea576c87b9af	Incansável	incansavel	CLASS_POWER	\N	f	PDF v1.1, p. 25
1e9ef0a4-5c91-467b-8041-70d3ec78e352	1e9480ec-e177-4b33-90c7-ea576c87b9af	Presteza Atlética	presteza-atletica	CLASS_POWER	\N	f	PDF v1.1, p. 25
1dabfa3e-4963-49f9-993f-9fc37e4dfebf	1e9480ec-e177-4b33-90c7-ea576c87b9af	Proteção Pesada	poder-protecao-pesada	CLASS_POWER	Pré-requisito: NEX 30%.	f	PDF v1.1, p. 25
41e57677-ddcc-41be-8264-f7848e53cd79	1e9480ec-e177-4b33-90c7-ea576c87b9af	Reflexos Defensivos	reflexos-defensivos	CLASS_POWER	Pré-requisito: Agilidade 2.	f	PDF v1.1, p. 25
40ef6ed6-4305-496a-8739-2935550a4b03	1e9480ec-e177-4b33-90c7-ea576c87b9af	Saque Rápido	saque-rapido	CLASS_POWER	Pré-requisito: treinado em Iniciativa.	f	PDF v1.1, pp. 25-26
ff756f75-c638-4a4b-8152-68153263e778	1e9480ec-e177-4b33-90c7-ea576c87b9af	Segurar o Gatilho	segurar-o-gatilho	CLASS_POWER	Pré-requisito: NEX 60%.	f	PDF v1.1, pp. 25-26
fc008603-423f-4600-890d-af434c10e95c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Sentido Tático	sentido-tatico	CLASS_POWER	Pré-requisitos: Intelecto 2; treinado em Percepção e Tática.	f	PDF v1.1, p. 26
0f4bed27-cc75-475a-ad4f-c4f49be5b419	1e9480ec-e177-4b33-90c7-ea576c87b9af	Tanque de Guerra	tanque-de-guerra	CLASS_POWER	Pré-requisito: poder Proteção Pesada.	f	PDF v1.1, p. 26
29c2da64-af07-46e7-a5e9-32629798a173	1e9480ec-e177-4b33-90c7-ea576c87b9af	Tiro Certeiro	tiro-certeiro	CLASS_POWER	Pré-requisito: treinado em Pontaria.	f	PDF v1.1, p. 26
f0707d5d-65a8-4478-a6f9-21cec7d63f7e	1e9480ec-e177-4b33-90c7-ea576c87b9af	Tiro de Cobertura	tiro-de-cobertura	CLASS_POWER	\N	f	PDF v1.1, p. 26
a26e29ed-5716-4372-989a-8b1bba72ef5b	1e9480ec-e177-4b33-90c7-ea576c87b9af	Balística Avançada	balistica-avancada	CLASS_POWER	\N	f	PDF v1.1, p. 29
c527e2a3-494d-46a2-8e12-51d88291c70a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Conhecimento Aplicado	conhecimento-aplicado	CLASS_POWER	Pré-requisito: Intelecto 2.	f	PDF v1.1, p. 29
a7d51e8d-a336-4984-bd5f-9fc91a755c47	1e9480ec-e177-4b33-90c7-ea576c87b9af	Hacker	hacker	CLASS_POWER	Pré-requisito: treinado em Tecnologia.	f	PDF v1.1, p. 29
0e95b9f4-48d5-4dea-80ec-677117796fd8	1e9480ec-e177-4b33-90c7-ea576c87b9af	Mãos Rápidas	maos-rapidas	CLASS_POWER	Pré-requisitos: Agilidade 3; treinado em Crime.	f	PDF v1.1, p. 29
d515f6c8-b248-48bf-a4ca-6b9d7ddc55a7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Mochila de Utilidades	mochila-de-utilidades	CLASS_POWER	\N	f	PDF v1.1, p. 29
50b8cfb4-deb1-4e0e-96f1-9846e3f8e56b	1e9480ec-e177-4b33-90c7-ea576c87b9af	Movimento Tático	movimento-tatico	CLASS_POWER	Pré-requisito: treinado em Atletismo.	f	PDF v1.1, p. 29
8a21d456-8686-462a-9538-6176cc64527c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Na Trilha Certa	na-trilha-certa	CLASS_POWER	\N	f	PDF v1.1, p. 29
cd8f1cbc-e3ad-42be-99ea-7a98169ff81f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Nerd	nerd	CLASS_POWER	\N	f	PDF v1.1, p. 29
97c83456-1efe-4887-b474-e8808211781c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ninja Urbano	ninja-urbano	CLASS_POWER	\N	f	PDF v1.1, pp. 29-30
7f8d1fe0-0ae3-4f13-9461-604984d2b8cc	1e9480ec-e177-4b33-90c7-ea576c87b9af	Pensamento Ágil	pensamento-agil	CLASS_POWER	\N	f	PDF v1.1, p. 30
61cf6e48-ed63-4f42-89c3-9e6220847e4b	1e9480ec-e177-4b33-90c7-ea576c87b9af	Perito em Explosivos	perito-em-explosivos	CLASS_POWER	\N	f	PDF v1.1, p. 30
d30af734-033b-4179-af53-89be408e5a3a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Primeira Impressão	primeira-impressao	CLASS_POWER	\N	f	PDF v1.1, p. 30
f3406bcb-a076-468b-b71d-87c6d0115341	1e9480ec-e177-4b33-90c7-ea576c87b9af	Saber é Poder	saber-e-poder	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
38e2bde8-bff5-4877-8a79-8e8d82cfa135	1e9480ec-e177-4b33-90c7-ea576c87b9af	Técnica Medicinal	tecnica-medicinal	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
3dabaad2-9797-4b61-a70b-27ddacc7ad18	1e9480ec-e177-4b33-90c7-ea576c87b9af	Vislumbres do Passado	vislumbres-do-passado	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
983f038b-4dc8-4704-89f9-815d749c9091	1e9480ec-e177-4b33-90c7-ea576c87b9af	Magnum Opus	magnum-opus	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
40daaf01-7167-426b-88e3-eba4440a8256	1e9480ec-e177-4b33-90c7-ea576c87b9af	110%	110-por-cento	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
45355c3d-ff10-43bb-98d4-0d2550dce67a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ingrediente Secreto	ingrediente-secreto	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
d1377e89-8fed-4b12-886e-a55af68ffda5	1e9480ec-e177-4b33-90c7-ea576c87b9af	O Crime Compensa	o-crime-compensa	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
a8634eac-8bea-4fb1-b7c3-b24d2a2606ed	1e9480ec-e177-4b33-90c7-ea576c87b9af	Traços do Outro Lado	tracos-do-outro-lado	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
c589144f-52c7-4f73-906b-85d7eef5bfc7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Calejado	calejado	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
e1e57af4-abe3-45b3-b9f9-405b9af86dc6	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ferramentas Favoritas	ferramentas-favoritas	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
f90f509b-647c-4b00-9fd3-8214a545f7af	1e9480ec-e177-4b33-90c7-ea576c87b9af	Processo Otimizado	processo-otimizado	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
85f1cbaa-fee6-4719-be4f-fc400c62c8e1	1e9480ec-e177-4b33-90c7-ea576c87b9af	Faro para Pistas	faro-para-pistas	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
2f3cbca0-0eca-4f9a-9e55-dd99d2faf581	1e9480ec-e177-4b33-90c7-ea576c87b9af	Mão Pesada	mao-pesada	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
4363bcda-5a40-4b90-bd30-aebf42850c1e	1e9480ec-e177-4b33-90c7-ea576c87b9af	Patrocinador da Ordem	patrocinador-da-ordem	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
96358824-0bff-48c7-a44d-07e6ae463321	1e9480ec-e177-4b33-90c7-ea576c87b9af	Posição de Combate	posicao-de-combate	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
65366714-abd8-4f13-bc5d-9843b3bf3424	1e9480ec-e177-4b33-90c7-ea576c87b9af	Para Bellum	para-bellum	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
6d1f587d-1e79-43b0-aaba-e16f656933d3	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ferramenta de Trabalho	ferramenta-de-trabalho	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
d966e2e1-aefb-466e-9a7b-f62171f384e4	1e9480ec-e177-4b33-90c7-ea576c87b9af	Patrulha	patrulha	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
24ee1228-bee7-4e03-8158-4ef084fc461f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Acalentar	acalentar	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
f6f4a2de-181d-47b0-ab35-ce50e4f1a221	1e9480ec-e177-4b33-90c7-ea576c87b9af	Espírito Cívico	espirito-civico	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
ae2af962-b8fd-41f3-a648-9b9e2df10219	1e9480ec-e177-4b33-90c7-ea576c87b9af	Eu Já Sabia	eu-ja-sabia	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
d6f0c5ac-8446-4728-ad20-1cf98ccc5a14	1e9480ec-e177-4b33-90c7-ea576c87b9af	Motor de Busca	motor-de-busca	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
e0135c35-806b-4094-b925-739d6cbef57a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Desbravador	desbravador	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
fac91b0b-2650-4bad-9be8-b50412da0b01	1e9480ec-e177-4b33-90c7-ea576c87b9af	Impostor	impostor	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
8e4b5186-79a3-4d0e-a600-c844bb430be5	1e9480ec-e177-4b33-90c7-ea576c87b9af	Dedicação	dedicacao	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
38cfecc0-6a87-4f1b-a547-2f5d561480f9	1e9480ec-e177-4b33-90c7-ea576c87b9af	Cicatrizes Psicológicas	cicatrizes-psicologicas	ORIGIN_POWER	\N	f	PDF v1.1, origens pp. 16-21
1f473d7c-9a20-4937-be57-3b557ffbc2f2	1e9480ec-e177-4b33-90c7-ea576c87b9af	Camuflar Ocultismo	camuflar-ocultismo	CLASS_POWER	\N	f	PDF v1.1, p. 33
fe49226d-444c-4940-97ec-1fdf92c278ff	1e9480ec-e177-4b33-90c7-ea576c87b9af	Criar Selo	criar-selo	CLASS_POWER	\N	f	PDF v1.1, p. 33
0c63466a-336b-4bcf-9725-9d86cc0721a9	1e9480ec-e177-4b33-90c7-ea576c87b9af	Envolto em Mistério	envolto-em-misterio	CLASS_POWER	\N	f	PDF v1.1, p. 33
b6a24c05-0460-4e06-88e3-92c217724c14	1e9480ec-e177-4b33-90c7-ea576c87b9af	Especialista em Elemento	especialista-em-elemento	CLASS_POWER	\N	f	PDF v1.1, p. 33
62ae19b0-c472-4cdf-9621-b52c467ec328	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ferramentas Paranormais	ferramentas-paranormais	CLASS_POWER	\N	f	PDF v1.1, p. 33
af00bc0c-f42e-43b8-8a2d-34000f83d59f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Fluxo de Poder	fluxo-de-poder	CLASS_POWER	Pré-requisito: NEX 60%.	f	PDF v1.1, p. 33
75a61c2b-3d6d-42fb-9e19-0d943726aeb9	1e9480ec-e177-4b33-90c7-ea576c87b9af	Guiado pelo Paranormal	guiado-pelo-paranormal	CLASS_POWER	\N	f	PDF v1.1, p. 34
3d0d954d-d202-48f8-9c45-a32bb2415575	1e9480ec-e177-4b33-90c7-ea576c87b9af	Identificação Paranormal	identificacao-paranormal	CLASS_POWER	\N	f	PDF v1.1, p. 34
b2be935f-94fc-4900-acbd-a0be92be64b4	1e9480ec-e177-4b33-90c7-ea576c87b9af	Improvisar Componentes	improvisar-componentes	CLASS_POWER	\N	f	PDF v1.1, p. 34
17b7ca3c-7ad3-450d-a1aa-5585840f807b	1e9480ec-e177-4b33-90c7-ea576c87b9af	Intuição Paranormal	intuicao-paranormal	CLASS_POWER	\N	f	PDF v1.1, p. 34
ea9c05e5-4c67-45d1-88a7-fecbec78645b	1e9480ec-e177-4b33-90c7-ea576c87b9af	Mestre em Elemento	mestre-em-elemento	CLASS_POWER	Pré-requisitos: Especialista em Elemento no elemento escolhido; NEX 45%.	f	PDF v1.1, p. 34
a524f3a8-eb2d-456c-b302-7a5a0cc74473	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ritual Potente	ritual-potente	CLASS_POWER	Pré-requisito: Intelecto 2.	f	PDF v1.1, p. 34
a95ca663-bbcd-4a46-957e-548ced1a45e9	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ritual Predileto	ritual-predileto	CLASS_POWER	\N	f	PDF v1.1, p. 34
7d55db3c-6560-4cbf-85ba-fa3d468d4824	1e9480ec-e177-4b33-90c7-ea576c87b9af	Tatuagem Ritualística	tatuagem-ritualistica	CLASS_POWER	\N	f	PDF v1.1, p. 34
245d8d18-3f3f-422a-a82f-99f34b84d584	1e9480ec-e177-4b33-90c7-ea576c87b9af	A Favorita	a-favorita	TRAIL_ABILITY	\N	f	PDF v1.1, p. 26
65e1bd32-3abf-4902-b5d5-3a1249d32d20	1e9480ec-e177-4b33-90c7-ea576c87b9af	Técnica Secreta	tecnica-secreta	TRAIL_ABILITY	\N	f	PDF v1.1, p. 26
500376c6-c753-4630-8eae-709fb2fbb0c0	1e9480ec-e177-4b33-90c7-ea576c87b9af	Técnica Sublime	tecnica-sublime	TRAIL_ABILITY	\N	f	PDF v1.1, p. 26
c4c6f99f-3d42-4c10-bd91-73591768edb7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Máquina de Matar	maquina-de-matar	TRAIL_ABILITY	\N	f	PDF v1.1, p. 26
9672616a-0efe-45a5-ba6f-228339900a6e	1e9480ec-e177-4b33-90c7-ea576c87b9af	Inspirar Confiança	inspirar-confianca	TRAIL_ABILITY	\N	f	PDF v1.1, pp. 26-27
b0f5f911-cd30-4079-833c-7d52c7850bf1	1e9480ec-e177-4b33-90c7-ea576c87b9af	Estrategista	estrategista	TRAIL_ABILITY	\N	f	PDF v1.1, p. 27
1338a532-5b5c-4cfe-865a-984dff355d3c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Brecha na Guarda	brecha-na-guarda	TRAIL_ABILITY	\N	f	PDF v1.1, p. 27
964dd8e2-22f3-40b3-9202-aa26ad36640c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Oficial Comandante	oficial-comandante	TRAIL_ABILITY	\N	f	PDF v1.1, p. 27
a6942f33-a5cc-478a-a5f7-a30ad18dbef7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Técnica Letal	tecnica-letal	TRAIL_ABILITY	\N	f	PDF v1.1, p. 27
e5fff2f1-fb64-4bd0-a6cf-9107a5654efc	1e9480ec-e177-4b33-90c7-ea576c87b9af	Revidar	revidar	TRAIL_ABILITY	\N	f	PDF v1.1, p. 27
54e7163e-ce22-42e7-8153-314c1dab5ad4	1e9480ec-e177-4b33-90c7-ea576c87b9af	Força Opressora	forca-opressora	TRAIL_ABILITY	\N	f	PDF v1.1, p. 27
33d5c8b4-f828-4876-9d2d-bb53313557fd	1e9480ec-e177-4b33-90c7-ea576c87b9af	Potência Máxima	potencia-maxima	TRAIL_ABILITY	\N	f	PDF v1.1, p. 27
a683be6a-3008-4e5c-93dc-2ca19f5e43b9	1e9480ec-e177-4b33-90c7-ea576c87b9af	Iniciativa Aprimorada	iniciativa-aprimorada	TRAIL_ABILITY	\N	f	PDF v1.1, p. 27
19f875ae-ce2c-408d-85f4-0e29881eefcc	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ataque Extra	ataque-extra	TRAIL_ABILITY	\N	f	PDF v1.1, p. 27
5944d095-4755-493e-ad59-a7267e8bb625	1e9480ec-e177-4b33-90c7-ea576c87b9af	Surto de Adrenalina	surto-de-adrenalina	TRAIL_ABILITY	\N	f	PDF v1.1, p. 27
784f4aa8-776c-47a0-9650-a9d5cc28f349	1e9480ec-e177-4b33-90c7-ea576c87b9af	Sempre Alerta	sempre-alerta	TRAIL_ABILITY	\N	f	PDF v1.1, p. 27
172c539f-a02c-4348-8e7d-f69ca8ed6114	1e9480ec-e177-4b33-90c7-ea576c87b9af	Casca Grossa	casca-grossa	TRAIL_ABILITY	\N	f	PDF v1.1, p. 27
cd6e8a61-8cbc-428f-848f-d657f3d492e2	1e9480ec-e177-4b33-90c7-ea576c87b9af	Cai Dentro	cai-dentro	TRAIL_ABILITY	\N	f	PDF v1.1, p. 27
38804135-c2eb-4401-a8bb-0d01bbb78124	1e9480ec-e177-4b33-90c7-ea576c87b9af	Duro de Matar	duro-de-matar	TRAIL_ABILITY	\N	f	PDF v1.1, p. 27
bbade6ff-9742-4868-8a0b-b1ed1e610f4c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Inquebrável	inquebravel	TRAIL_ABILITY	\N	f	PDF v1.1, p. 27
bbbe5c88-d6db-4ca9-9d85-810152bc352e	1e9480ec-e177-4b33-90c7-ea576c87b9af	Mira de Elite	mira-de-elite	TRAIL_ABILITY	\N	f	PDF v1.1, p. 30
6e15a89b-95f4-42a5-913d-f0de6b714a55	1e9480ec-e177-4b33-90c7-ea576c87b9af	Disparo Letal	disparo-letal	TRAIL_ABILITY	\N	f	PDF v1.1, p. 30
b9596e8c-24a6-4a85-948b-955f174f62f5	1e9480ec-e177-4b33-90c7-ea576c87b9af	Disparo Impactante	disparo-impactante	TRAIL_ABILITY	\N	f	PDF v1.1, p. 30
3a95a5be-be77-4f57-a0b0-bd464f618ee3	1e9480ec-e177-4b33-90c7-ea576c87b9af	Atirar para Matar	atirar-para-matar	TRAIL_ABILITY	\N	f	PDF v1.1, p. 30
1cbd6ea6-dda9-44dc-85b7-c7705e876d37	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ataque Furtivo	ataque-furtivo	TRAIL_ABILITY	\N	f	PDF v1.1, p. 30
a014f6a8-7cd6-47d9-aef3-f1ff7cdc69de	1e9480ec-e177-4b33-90c7-ea576c87b9af	Gatuno	gatuno	TRAIL_ABILITY	\N	f	PDF v1.1, p. 30
71b9fd01-8bea-4659-a1a8-fc30b5486a6c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Assassinar	assassinar	TRAIL_ABILITY	\N	f	PDF v1.1, p. 30
a0194e45-64ea-4749-8fca-690ae177640a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Sombra Fugaz	sombra-fugaz	TRAIL_ABILITY	\N	f	PDF v1.1, p. 30
8d3722df-67f2-4559-afa8-d6503178ced6	1e9480ec-e177-4b33-90c7-ea576c87b9af	Paramédico	paramedico	TRAIL_ABILITY	\N	f	PDF v1.1, p. 31
60d103ad-4106-4956-9339-a2ecb3123f9a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Equipe de Trauma	equipe-de-trauma	TRAIL_ABILITY	\N	f	PDF v1.1, p. 31
7a48c18f-e4b3-48d9-8901-bc15b5531e4b	1e9480ec-e177-4b33-90c7-ea576c87b9af	Resgate	resgate	TRAIL_ABILITY	\N	f	PDF v1.1, p. 31
69fa9118-a90b-4937-b520-1e3c017e3ae4	1e9480ec-e177-4b33-90c7-ea576c87b9af	Reanimação	reanimacao	TRAIL_ABILITY	\N	f	PDF v1.1, p. 31
18e2126f-4536-4381-b408-08a850242244	1e9480ec-e177-4b33-90c7-ea576c87b9af	Eloquência	eloquencia	TRAIL_ABILITY	\N	f	PDF v1.1, p. 31
23215030-2b1f-4a53-9fea-4e44483ed7ff	1e9480ec-e177-4b33-90c7-ea576c87b9af	Discurso Motivador	discurso-motivador	TRAIL_ABILITY	\N	f	PDF v1.1, p. 31
4fd6da2c-8652-4496-8a84-ecfcd25292b7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Eu Conheço um Cara	eu-conheco-um-cara	TRAIL_ABILITY	\N	f	PDF v1.1, p. 31
86841319-c3e0-4c0f-bc22-0ba264131da4	1e9480ec-e177-4b33-90c7-ea576c87b9af	Truque de Mestre	truque-de-mestre	TRAIL_ABILITY	\N	f	PDF v1.1, p. 31
402b6477-8bf7-478b-b24d-a4ac8d420461	1e9480ec-e177-4b33-90c7-ea576c87b9af	Inventário Otimizado	inventario-otimizado	TRAIL_ABILITY	\N	f	PDF v1.1, p. 31
1fa9a1ef-1891-4f87-8d24-3b6e5dbbabba	1e9480ec-e177-4b33-90c7-ea576c87b9af	Remendão	remendao	TRAIL_ABILITY	\N	f	PDF v1.1, p. 31
fa1208d2-2135-4958-8d18-c5f0ff6adfb7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Improvisar	improvisar	TRAIL_ABILITY	\N	f	PDF v1.1, p. 31
aa787350-5cb8-4459-bee3-fb0228e9603f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Preparado para Tudo	preparado-para-tudo	TRAIL_ABILITY	\N	f	PDF v1.1, p. 31
632937ad-0a91-4f0d-bd74-df4124c1f898	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ampliar Ritual	ampliar-ritual	TRAIL_ABILITY	\N	f	PDF v1.1, p. 34
c9d4c150-0340-4d6f-bc34-49119e99913f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Acelerar Ritual	acelerar-ritual	TRAIL_ABILITY	\N	f	PDF v1.1, p. 34
1a3b2946-c9ff-4ff7-91f1-c5d3952f9ad4	1e9480ec-e177-4b33-90c7-ea576c87b9af	Anular Ritual	anular-ritual	TRAIL_ABILITY	\N	f	PDF v1.1, p. 34
1bbdccc2-0b19-4786-8617-e85c64a40f51	1e9480ec-e177-4b33-90c7-ea576c87b9af	Poder do Flagelo	poder-do-flagelo	TRAIL_ABILITY	\N	f	PDF v1.1, p. 34
d1447960-6336-4255-bfd5-cb99e36571ce	1e9480ec-e177-4b33-90c7-ea576c87b9af	Abraçar a Dor	abracar-a-dor	TRAIL_ABILITY	\N	f	PDF v1.1, pp. 34-35
de8991c4-763c-41b1-a750-e88c8529914d	1e9480ec-e177-4b33-90c7-ea576c87b9af	Absorver Agonia	absorver-agonia	TRAIL_ABILITY	\N	f	PDF v1.1, pp. 34-35
9e347308-6911-4d36-b04b-59f9d2b2cab2	1e9480ec-e177-4b33-90c7-ea576c87b9af	Saber Ampliado	saber-ampliado	TRAIL_ABILITY	\N	f	PDF v1.1, p. 35
efeb1430-c070-4b34-8b7e-89aff881dd7f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Grimório Ritualístico	grimorio-ritualistico	TRAIL_ABILITY	\N	f	PDF v1.1, p. 35
23ac072b-be0b-4e8f-8599-eb650e644d94	1e9480ec-e177-4b33-90c7-ea576c87b9af	Rituais Eficientes	rituais-eficientes	TRAIL_ABILITY	\N	f	PDF v1.1, p. 35
c956d919-4817-4df8-8e0f-6849bed42aed	1e9480ec-e177-4b33-90c7-ea576c87b9af	Mente Sã	mente-sa	TRAIL_ABILITY	\N	f	PDF v1.1, p. 35
98c93fca-c126-48a2-a812-5571baa76c2f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Presença Poderosa	presenca-poderosa	TRAIL_ABILITY	\N	f	PDF v1.1, p. 35
43a189ac-e2a7-4dcb-838a-95dbba2144e9	1e9480ec-e177-4b33-90c7-ea576c87b9af	Inabalável	inabalavel	TRAIL_ABILITY	\N	f	PDF v1.1, p. 35
73ce33ca-6a6e-451c-a3b0-ac9a79372f1b	1e9480ec-e177-4b33-90c7-ea576c87b9af	Lâmina Maldita	lamina-maldita	TRAIL_ABILITY	\N	f	PDF v1.1, p. 35
7ecedacf-757b-441d-bcf4-9d4c5360675c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Gladiador Paranormal	gladiador-paranormal	TRAIL_ABILITY	\N	f	PDF v1.1, p. 35
886e03c3-f083-41ce-9317-b5d795f48a3c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Conjuração Marcial	conjuracao-marcial	TRAIL_ABILITY	\N	f	PDF v1.1, p. 35
2c8d37f4-e82b-4ca6-8e40-0255a2788739	1e9480ec-e177-4b33-90c7-ea576c87b9af	Alterar Destino	alterar-destino	RITUAL	\N	f	PDF v1.1, ritual p. 124
0eae77b1-8e67-4b2b-aa0d-249bb2a51087	1e9480ec-e177-4b33-90c7-ea576c87b9af	Alterar Memória	alterar-memoria	RITUAL	\N	f	PDF v1.1, ritual p. 124
2163550a-2419-4042-9156-7987c84e3004	1e9480ec-e177-4b33-90c7-ea576c87b9af	Amaldiçoar Arma	amaldicoar-arma-conhecimento	RITUAL	\N	f	PDF v1.1, ritual p. 124
f35cd399-f732-4a66-bf6b-c8104ee5a0bf	1e9480ec-e177-4b33-90c7-ea576c87b9af	Amaldiçoar Arma	amaldicoar-arma-energia	RITUAL	\N	f	PDF v1.1, ritual p. 124
b129ac9c-23ba-4318-b0d1-34fa3f043de9	1e9480ec-e177-4b33-90c7-ea576c87b9af	Amaldiçoar Arma	amaldicoar-arma-morte	RITUAL	\N	f	PDF v1.1, ritual p. 124
0bdf7448-ed3f-4783-ab7c-7406ba6df0e9	1e9480ec-e177-4b33-90c7-ea576c87b9af	Amaldiçoar Arma	amaldicoar-arma-sangue	RITUAL	\N	f	PDF v1.1, ritual p. 124
2047fef0-b7e9-4f92-8c3c-3b6a23542777	1e9480ec-e177-4b33-90c7-ea576c87b9af	Amaldiçoar Tecnologia	amaldicoar-tecnologia	RITUAL	\N	f	PDF v1.1, ritual p. 124
2ea4c50c-a34f-4157-ae1b-4872d40d1a65	1e9480ec-e177-4b33-90c7-ea576c87b9af	Âncora Temporal	ancora-temporal	RITUAL	\N	f	PDF v1.1, ritual p. 124
f5648ca6-a4c2-4ea1-a0a0-d43337cfce3c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Aprimorar Físico	aprimorar-fisico	RITUAL	\N	f	PDF v1.1, ritual p. 125
9a32cea2-906f-4226-b2a9-5df0809cc754	1e9480ec-e177-4b33-90c7-ea576c87b9af	Aprimorar Mente	aprimorar-mente	RITUAL	\N	f	PDF v1.1, ritual p. 125
c7716109-254f-439f-8ec0-17f4edac5594	1e9480ec-e177-4b33-90c7-ea576c87b9af	Arma Atroz	arma-atroz	RITUAL	\N	f	PDF v1.1, ritual p. 125
fd2c6ae0-2f1a-44ce-a160-0a3879f83c06	1e9480ec-e177-4b33-90c7-ea576c87b9af	Armadura de Sangue	armadura-de-sangue	RITUAL	\N	f	PDF v1.1, ritual p. 125
2abc7564-9063-4ef4-82db-6e015457f284	1e9480ec-e177-4b33-90c7-ea576c87b9af	Canalizar o Medo	canalizar-o-medo	RITUAL	\N	f	PDF v1.1, ritual p. 125
c065d959-47c8-42a2-975d-903575c78aac	1e9480ec-e177-4b33-90c7-ea576c87b9af	Capturar o Coração	capturar-o-coracao	RITUAL	\N	f	PDF v1.1, ritual p. 125
14bfb442-c14a-4c55-9c05-1d0f9302e842	1e9480ec-e177-4b33-90c7-ea576c87b9af	Chamas do Caos	chamas-do-caos	RITUAL	\N	f	PDF v1.1, ritual p. 126
e723b128-dced-4940-bfbc-cb4c9bc4dfb7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Cicatrização	cicatrizacao	RITUAL	\N	f	PDF v1.1, ritual p. 126
5425bfd8-3df0-4bf3-a6cc-177766d52080	1e9480ec-e177-4b33-90c7-ea576c87b9af	Cinerária	cineraria	RITUAL	\N	f	PDF v1.1, ritual p. 126
96871314-cd14-47cb-adb1-cc39840fd656	1e9480ec-e177-4b33-90c7-ea576c87b9af	Coincidência Forçada	coincidencia-forcada	RITUAL	\N	f	PDF v1.1, ritual p. 126
58e7e59e-05da-4efd-b979-375ee1df922c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Compreensão Paranormal	compreensao-paranormal	RITUAL	\N	f	PDF v1.1, ritual p. 126
8c7f5fd2-79cd-40fd-9634-de96cd1e9a5b	1e9480ec-e177-4b33-90c7-ea576c87b9af	Conhecendo o Medo	conhecendo-o-medo	RITUAL	\N	f	PDF v1.1, ritual p. 127
f4eb79f7-d170-4e15-898d-26ac10a644e4	1e9480ec-e177-4b33-90c7-ea576c87b9af	Consumir Manancial	consumir-manancial	RITUAL	\N	f	PDF v1.1, ritual p. 127
e606a428-2361-4a6b-9b36-d88ee0413ba6	1e9480ec-e177-4b33-90c7-ea576c87b9af	Contato Paranormal	contato-paranormal	RITUAL	\N	f	PDF v1.1, ritual p. 127
2405ec4f-6ed8-447c-85cc-71b90703e09b	1e9480ec-e177-4b33-90c7-ea576c87b9af	Contenção Fantasmagórica	contencao-fantasmagorica	RITUAL	\N	f	PDF v1.1, ritual p. 127
6c8eac70-d6f0-4ecf-93c5-6db46d6f48d0	1e9480ec-e177-4b33-90c7-ea576c87b9af	Controle Mental	controle-mental	RITUAL	\N	f	PDF v1.1, ritual p. 128
74b87116-c584-4830-a8ac-b403da05d969	1e9480ec-e177-4b33-90c7-ea576c87b9af	Convocação Instantânea	convocacao-instantanea	RITUAL	\N	f	PDF v1.1, ritual p. 128
b678aa48-0e59-4c84-84ac-22454f6a7de0	1e9480ec-e177-4b33-90c7-ea576c87b9af	Convocar o Algoz	convocar-o-algoz	RITUAL	\N	f	PDF v1.1, ritual p. 128
47124fdf-0974-49af-8e79-6e3ea8863bb8	1e9480ec-e177-4b33-90c7-ea576c87b9af	Corpo Adaptado	corpo-adaptado	RITUAL	\N	f	PDF v1.1, ritual p. 128
675025ed-84af-43b7-96e5-8338efe9a129	1e9480ec-e177-4b33-90c7-ea576c87b9af	Decadência	decadencia	RITUAL	\N	f	PDF v1.1, ritual p. 129
0c076548-f470-41c3-b448-bbe7a59a7ea8	1e9480ec-e177-4b33-90c7-ea576c87b9af	Definhar	definhar	RITUAL	\N	f	PDF v1.1, ritual p. 129
be1d4147-cca6-4a3b-96a6-8476925a542d	1e9480ec-e177-4b33-90c7-ea576c87b9af	Deflagração de Energia	deflagracao-de-energia	RITUAL	\N	f	PDF v1.1, ritual p. 129
9cecc9eb-9fb1-4fc7-9561-95127a6b85da	1e9480ec-e177-4b33-90c7-ea576c87b9af	Desacelerar Impacto	desacelerar-impacto	RITUAL	\N	f	PDF v1.1, ritual p. 129
0e606536-bef9-43cd-aec6-e07f79ecc216	1e9480ec-e177-4b33-90c7-ea576c87b9af	Descarnar	descarnar	RITUAL	\N	f	PDF v1.1, ritual p. 129
b326548e-31fc-4acd-b6cc-b2a4865ec882	1e9480ec-e177-4b33-90c7-ea576c87b9af	Detecção de Ameaças	deteccao-de-ameacas	RITUAL	\N	f	PDF v1.1, ritual p. 130
b98d707e-e27a-4fd4-a8e6-e8b5675aeb1f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Dissipar Ritual	dissipar-ritual	RITUAL	\N	f	PDF v1.1, ritual p. 130
8ef60ca3-8415-489e-b84e-7dfacebb5739	1e9480ec-e177-4b33-90c7-ea576c87b9af	Dissonância Acústica	dissonancia-acustica	RITUAL	\N	f	PDF v1.1, ritual p. 130
7c76245f-58fe-4a13-b740-d1770fe35b69	1e9480ec-e177-4b33-90c7-ea576c87b9af	Distorção Temporal	distorcao-temporal	RITUAL	\N	f	PDF v1.1, ritual p. 130
8eb514d3-cfa8-4887-86dc-3a76a260057b	1e9480ec-e177-4b33-90c7-ea576c87b9af	Distorcer Aparência	distorcer-aparencia	RITUAL	\N	f	PDF v1.1, ritual p. 130
ffa681e1-5bbd-4486-8762-ec2864f3f4d9	1e9480ec-e177-4b33-90c7-ea576c87b9af	Eco Espiral	eco-espiral	RITUAL	\N	f	PDF v1.1, ritual p. 131
2bfbf8e3-9764-467a-9e0a-2e84d1fc8808	1e9480ec-e177-4b33-90c7-ea576c87b9af	Eletrocussão	eletrocussao	RITUAL	\N	f	PDF v1.1, ritual p. 131
19e0b0a2-fecc-47d9-8107-2e9f953a68e0	1e9480ec-e177-4b33-90c7-ea576c87b9af	Embaralhar	embaralhar	RITUAL	\N	f	PDF v1.1, ritual p. 131
5ceb3b7e-6f87-4248-895a-a6ff99111e0a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Enfeitiçar	enfeiticar	RITUAL	\N	f	PDF v1.1, ritual p. 131
d5657ce4-3488-4d35-8880-9c83ebd15eae	1e9480ec-e177-4b33-90c7-ea576c87b9af	Esconder dos Olhos	esconder-dos-olhos	RITUAL	\N	f	PDF v1.1, ritual p. 132
746611f0-4bfe-48ab-9420-6596a1026b5b	1e9480ec-e177-4b33-90c7-ea576c87b9af	Espirais da Perdição	espirais-da-perdicao	RITUAL	\N	f	PDF v1.1, ritual p. 132
634711eb-9d5a-4ad3-bc20-1e09e3ca006e	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ferver Sangue	ferver-sangue	RITUAL	\N	f	PDF v1.1, ritual p. 132
f94059e2-bbbe-4811-a620-2d5540386a2d	1e9480ec-e177-4b33-90c7-ea576c87b9af	Fim Inevitável	fim-inevitavel	RITUAL	\N	f	PDF v1.1, ritual p. 132
68906119-abd6-4edc-b553-d44a2601e465	1e9480ec-e177-4b33-90c7-ea576c87b9af	Flagelo de Sangue	flagelo-de-sangue	RITUAL	\N	f	PDF v1.1, ritual p. 133
f870b656-aee7-462d-ae08-cf4b57c7297f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Forma Monstruosa	forma-monstruosa	RITUAL	\N	f	PDF v1.1, ritual p. 133
0f48f60c-7d75-4a9f-aeb0-625865fbaf77	1e9480ec-e177-4b33-90c7-ea576c87b9af	Fortalecimento Sensorial	fortalecimento-sensorial	RITUAL	\N	f	PDF v1.1, ritual p. 133
352c32b0-4383-4479-b925-bafc2ed1f5ac	1e9480ec-e177-4b33-90c7-ea576c87b9af	Hemofagia	hemofagia	RITUAL	\N	f	PDF v1.1, ritual p. 133
a31d1ec9-14da-467e-b4a8-64793844bd5d	1e9480ec-e177-4b33-90c7-ea576c87b9af	Inexistir	inexistir	RITUAL	\N	f	PDF v1.1, ritual p. 134
029ed9d6-922f-4af6-ab5a-92c492a7cb27	1e9480ec-e177-4b33-90c7-ea576c87b9af	Invadir Mente	invadir-mente	RITUAL	\N	f	PDF v1.1, ritual p. 134
70255d54-db1c-45f3-8c7e-4662941074b8	1e9480ec-e177-4b33-90c7-ea576c87b9af	Invólucro de Carne	involucro-de-carne	RITUAL	\N	f	PDF v1.1, ritual p. 134
85d43c4f-c14d-487a-bb2e-79c2704ca4d3	1e9480ec-e177-4b33-90c7-ea576c87b9af	Lâmina do Medo	lamina-do-medo	RITUAL	\N	f	PDF v1.1, ritual p. 135
1819c4e9-409d-4051-8c93-c2fec070dd43	1e9480ec-e177-4b33-90c7-ea576c87b9af	Localização	localizacao	RITUAL	\N	f	PDF v1.1, ritual p. 135
40752128-44f0-47da-8c5d-f3763e46b7ed	1e9480ec-e177-4b33-90c7-ea576c87b9af	Luz	luz	RITUAL	\N	f	PDF v1.1, ritual p. 135
63f84939-2425-4e9e-884b-de8fe9eb674d	1e9480ec-e177-4b33-90c7-ea576c87b9af	Medo Tangível	medo-tangivel	RITUAL	\N	f	PDF v1.1, ritual p. 135
aa007c8c-da36-443a-bbfa-fe1138be3674	1e9480ec-e177-4b33-90c7-ea576c87b9af	Mergulho Mental	mergulho-mental	RITUAL	\N	f	PDF v1.1, ritual p. 136
059735fa-b8a8-40b5-bd9d-cb2e6a1b4c07	1e9480ec-e177-4b33-90c7-ea576c87b9af	Miasma Entrópico	miasma-entropico	RITUAL	\N	f	PDF v1.1, ritual p. 136
7367a744-b0a9-40d3-8879-259531799286	1e9480ec-e177-4b33-90c7-ea576c87b9af	Nuvem de Cinzas	nuvem-de-cinzas	RITUAL	\N	f	PDF v1.1, ritual p. 136
d5890474-e7ff-490d-bbad-bb01431a7340	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ódio Incontrolável	odio-incontrolavel	RITUAL	\N	f	PDF v1.1, ritual p. 136
aaf7fce1-94d7-4893-9412-77a861be5c67	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ouvir os Sussurros	ouvir-os-sussurros	RITUAL	\N	f	PDF v1.1, ritual p. 137
7c4406b9-df35-462c-82f3-3bf376a3d737	1e9480ec-e177-4b33-90c7-ea576c87b9af	Paradoxo	paradoxo	RITUAL	\N	f	PDF v1.1, ritual p. 137
c9cdf410-fe29-499a-8586-1dd087326e22	1e9480ec-e177-4b33-90c7-ea576c87b9af	Perturbação	perturbacao	RITUAL	\N	f	PDF v1.1, ritual p. 137
e9f793cc-c54f-4862-9f87-fee73caf5474	1e9480ec-e177-4b33-90c7-ea576c87b9af	Poeira da Podridão	poeira-da-podridao	RITUAL	\N	f	PDF v1.1, ritual p. 138
ed0f50df-8c77-4c78-b012-95dbbdb4adec	1e9480ec-e177-4b33-90c7-ea576c87b9af	Polarização Caótica	polarizacao-caotica	RITUAL	\N	f	PDF v1.1, ritual p. 138
fc8aab2d-c245-4c67-8610-cb5609b2d31e	1e9480ec-e177-4b33-90c7-ea576c87b9af	Possessão	possessao	RITUAL	\N	f	PDF v1.1, ritual p. 138
c747d4e9-db06-4899-84b2-7b0525b3c94e	1e9480ec-e177-4b33-90c7-ea576c87b9af	Presença do Medo	presenca-do-medo	RITUAL	\N	f	PDF v1.1, ritual p. 139
50f8e24a-3ad7-41b3-8233-1ab6b49241d2	1e9480ec-e177-4b33-90c7-ea576c87b9af	Proteção contra Rituais	protecao-contra-rituais	RITUAL	\N	f	PDF v1.1, ritual p. 139
6e209bb3-5207-417c-848b-604cb0009a02	1e9480ec-e177-4b33-90c7-ea576c87b9af	Purgatório	purgatorio	RITUAL	\N	f	PDF v1.1, ritual p. 139
09a4ced8-395b-470d-b908-9b7a7fdbbfe9	1e9480ec-e177-4b33-90c7-ea576c87b9af	Rejeitar Névoa	rejeitar-nevoa	RITUAL	\N	f	PDF v1.1, ritual p. 139
9b660863-9c16-492d-bd09-404780d87455	1e9480ec-e177-4b33-90c7-ea576c87b9af	Salto Fantasma	salto-fantasma	RITUAL	\N	f	PDF v1.1, ritual p. 139
14f656fa-83f3-4054-8421-fff1a1dc29e2	1e9480ec-e177-4b33-90c7-ea576c87b9af	Sopro do Caos	sopro-do-caos	RITUAL	\N	f	PDF v1.1, ritual p. 140
c8be4994-b2f3-40b8-845d-f76794ab3243	1e9480ec-e177-4b33-90c7-ea576c87b9af	Tecer Ilusão	tecer-ilusao	RITUAL	\N	f	PDF v1.1, ritual p. 140
3b5b45cc-d205-4148-811e-94825fb374a7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Tela de Ruído	tela-de-ruido	RITUAL	\N	f	PDF v1.1, ritual p. 141
0023d1e0-f7b5-4438-99ee-bce572033d38	1e9480ec-e177-4b33-90c7-ea576c87b9af	Teletransporte	teletransporte	RITUAL	\N	f	PDF v1.1, ritual p. 141
bb091fa6-8117-428d-893e-e741eba51091	1e9480ec-e177-4b33-90c7-ea576c87b9af	Tentáculos de Lodo	tentaculos-de-lodo	RITUAL	\N	f	PDF v1.1, ritual p. 141
34ef1e15-b5f4-4138-b247-d3475689d844	1e9480ec-e177-4b33-90c7-ea576c87b9af	Terceiro Olho	terceiro-olho	RITUAL	\N	f	PDF v1.1, ritual p. 141
d0ce03ab-7fb1-47f7-87b4-222bd18263c9	1e9480ec-e177-4b33-90c7-ea576c87b9af	Transfigurar Água	transfigurar-agua	RITUAL	\N	f	PDF v1.1, ritual p. 142
e0fdeac8-093e-4a98-99c8-a1b4a013c2b3	1e9480ec-e177-4b33-90c7-ea576c87b9af	Transfigurar Terra	transfigurar-terra	RITUAL	\N	f	PDF v1.1, ritual p. 142
8d99146e-aed8-4901-b813-88657a357c6f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Transfusão Vital	transfusao-vital	RITUAL	\N	f	PDF v1.1, ritual p. 142
5640ef1b-2653-4246-ba68-26bef7f3d459	1e9480ec-e177-4b33-90c7-ea576c87b9af	Velocidade Mortal	velocidade-mortal	RITUAL	\N	f	PDF v1.1, ritual p. 142
09bbe454-e56b-4f2a-88ac-5236484e0212	1e9480ec-e177-4b33-90c7-ea576c87b9af	Vidência	videncia	RITUAL	\N	f	PDF v1.1, ritual p. 143
6f9ad5c3-8144-47b4-8f55-7e21914228ee	1e9480ec-e177-4b33-90c7-ea576c87b9af	Vínculo de Sangue	vinculo-de-sangue	RITUAL	\N	f	PDF v1.1, ritual p. 143
bbabd94b-c6e8-4e8b-bd23-a4cc94b4705a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Vomitar Pestes	vomitar-pestes	RITUAL	\N	f	PDF v1.1, ritual p. 143
f51c7a06-21e4-4863-b9a0-be6fbd12c38a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Zerar Entropia	zerar-entropia	RITUAL	\N	f	PDF v1.1, ritual p. 143
\.


--
-- Data for Name: action_definition; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.action_definition (id, rpg_system_id, name, slug, action_type, description, sort_order, source_ref, metadata) FROM stdin;
98dc256c-4200-4d4d-a31b-8ba39ca9d24a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Agredir	agredir	STANDARD	Realiza um ataque com uma arma ou ataque desarmado apropriado.	1	PDF v1.1, Cap. 4 pp. 85-86	{"combat": true}
b10939df-271d-4104-b413-20158761f3e4	1e9480ec-e177-4b33-90c7-ea576c87b9af	Atropelar	atropelar	STANDARD	Durante um movimento, tenta atravessar o espaço ocupado por um ser. Se ele resistir, é feito um teste de manobra oposto; em vitória, o alvo fica caído e o movimento continua.	2	PDF v1.1, p. 86	{"combat": true}
95065d6a-40bf-4ade-b54b-fad9b115aa9c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Conjurar um Ritual	conjurar-ritual	STANDARD	Executa um ritual cuja execução seja uma ação padrão.	3	PDF v1.1, p. 86	{"combat": true}
2323ea93-56d7-4095-9a19-2701483b4243	1e9480ec-e177-4b33-90c7-ea576c87b9af	Fintar	fintar	STANDARD	Faz Enganação oposta a Reflexos de um ser em alcance curto; em sucesso o alvo fica desprevenido contra o próximo ataque do usuário até o fim do próximo turno.	4	PDF v1.1, p. 86	{"combat": true}
7ef346d8-4598-4956-a5dc-a70ccdfabd80	1e9480ec-e177-4b33-90c7-ea576c87b9af	Preparar	preparar	STANDARD	Prepara uma ação padrão, de movimento ou livre para ocorrer após o turno como reação a uma circunstância declarada; a Iniciativa é ajustada quando a ação preparada é executada.	5	PDF v1.1, p. 86	{"combat": true}
86409c6e-da18-4c42-8755-e3c29bd5cce5	1e9480ec-e177-4b33-90c7-ea576c87b9af	Usar Habilidade ou Item	usar-habilidade-ou-item	STANDARD	Usa uma habilidade ou item que exija ação padrão.	6	PDF v1.1, p. 86	{"combat": true}
411a418c-22a7-4649-96ee-616fe5ed60c4	1e9480ec-e177-4b33-90c7-ea576c87b9af	Levantar-se	levantar-se	MOVEMENT	Levanta-se do chão ou de outra posição equivalente.	10	PDF v1.1, p. 87	{"combat": true}
b9d5beee-0967-4f2c-a8f6-4eaf6589de29	1e9480ec-e177-4b33-90c7-ea576c87b9af	Manipular Item	manipular-item	MOVEMENT	Manipula um objeto, como pegar algo na mochila, abrir ou fechar uma porta ou lançar uma corda.	11	PDF v1.1, p. 87	{"combat": true}
6a3995e5-a1ed-40f3-8f69-faec01b6a3b0	1e9480ec-e177-4b33-90c7-ea576c87b9af	Mirar	mirar	MOVEMENT	Mira em um alvo visível dentro do alcance da arma e anula a penalidade de -5 em Pontaria contra esse alvo se ele estiver engajado em combate corpo a corpo.	12	PDF v1.1, p. 87	{"combat": true}
7f903f41-60d3-424c-a4ec-c77cbdc38f18	1e9480ec-e177-4b33-90c7-ea576c87b9af	Movimentar-se	movimentar-se	MOVEMENT	Percorre uma distância igual ao deslocamento; outros tipos de movimento, como nadar ou escalar, também usam esta ação.	13	PDF v1.1, p. 87	{"combat": true}
0113a6f8-8459-47c2-af02-5b7584719440	1e9480ec-e177-4b33-90c7-ea576c87b9af	Sacar ou Guardar Item	sacar-ou-guardar-item	MOVEMENT	Saca ou guarda um item.	14	PDF v1.1, p. 87	{"combat": true}
5e8a7ebc-b396-4cbf-b5cc-725bd8116ac3	1e9480ec-e177-4b33-90c7-ea576c87b9af	Corrida	corrida	FULL	Corre mais rapidamente que o deslocamento normal, usando as regras da perícia Atletismo.	20	PDF v1.1, p. 87	{"combat": true}
78abf8ae-30f1-4160-b57e-b568dab5e695	1e9480ec-e177-4b33-90c7-ea576c87b9af	Golpe de Misericórdia	golpe-de-misericordia	FULL	Contra oponente adjacente e indefeso, realiza acerto crítico automático e pode provocar morte instantânea conforme o tipo de vítima.	21	PDF v1.1, p. 87	{"combat": true}
b9585436-3516-42d7-be1c-fc587294256e	1e9480ec-e177-4b33-90c7-ea576c87b9af	Investida	investida	FULL	Avança em linha reta entre 3m e até o dobro do deslocamento e então faz ataque corpo a corpo. Recebe +1 dado no ataque e -5 Defesa até o próximo turno. Não pode ser feita em terreno difícil.	22	PDF v1.1, p. 87	{"combat": true}
c49532ef-7733-4829-a53d-82328d01a3f4	1e9480ec-e177-4b33-90c7-ea576c87b9af	Conjurar Ritual Prolongado	conjurar-ritual-prolongado	FULL	Para rituais com execução maior que uma ação completa, gasta uma ação completa a cada rodada da execução.	23	PDF v1.1, p. 87	{"combat": true}
8bc10168-21ba-4109-96f2-dc26376b843a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Atrasar	atrasar	FREE	Reduz voluntariamente a própria Iniciativa para agir mais tarde no combate, respeitando os limites da regra de atraso.	30	PDF v1.1, pp. 87-88	{"combat": true}
ec257081-8091-4a7c-b7ea-4ba4c8ce61e7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Falar	falar	FREE	Falar normalmente é ação livre; o mestre pode limitar a quantidade de fala em uma rodada.	31	PDF v1.1, p. 88	{"combat": true}
73701f1c-f7fe-4c9b-88ae-9f9be8119728	1e9480ec-e177-4b33-90c7-ea576c87b9af	Jogar-se no Chão	jogar-se-no-chao	FREE	Assume voluntariamente a condição Caído.	32	PDF v1.1, p. 88	{"combat": true}
9a990249-04cd-4316-a4cf-94b3f9f0c53a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Largar um Item	largar-item	FREE	Deixa cair um item segurado sem tentar acertar algo ou passá-lo a outra pessoa.	33	PDF v1.1, p. 88	{"combat": true}
\.


--
-- Data for Name: class_definition; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.class_definition (id, rpg_system_id, name, slug, description, source_ref) FROM stdin;
d2222c7e-59c7-4b37-83da-b65ab68e594b	1e9480ec-e177-4b33-90c7-ea576c87b9af	Combatente	combatente	\N	PDF v1.1, pp. 24-27
c9bd6935-a5db-4cb4-b99b-0621358c1820	1e9480ec-e177-4b33-90c7-ea576c87b9af	Especialista	especialista	\N	PDF v1.1, pp. 28-31
97b09513-32b5-4ad9-9e13-18b6ed61be29	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ocultista	ocultista	\N	PDF v1.1, pp. 32-35
\.


--
-- Data for Name: archetype_definition; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.archetype_definition (id, rpg_system_id, class_id, name, slug, description, source_ref) FROM stdin;
1f333868-9304-42e0-a3e9-06e06a1ff9cf	1e9480ec-e177-4b33-90c7-ea576c87b9af	d2222c7e-59c7-4b37-83da-b65ab68e594b	Aniquilador	aniquilador	\N	PDF v1.1, p. 26
6e86c313-ba51-4b81-bd05-d1f6492e9ff7	1e9480ec-e177-4b33-90c7-ea576c87b9af	d2222c7e-59c7-4b37-83da-b65ab68e594b	Comandante de Campo	comandante-de-campo	\N	PDF v1.1, p. 26
3bf6bf10-acb6-4046-9203-96d23f965963	1e9480ec-e177-4b33-90c7-ea576c87b9af	d2222c7e-59c7-4b37-83da-b65ab68e594b	Guerreiro	guerreiro	\N	PDF v1.1, p. 27
c0a0239f-7e01-4f2d-b11d-0b0d0ae2bfb4	1e9480ec-e177-4b33-90c7-ea576c87b9af	d2222c7e-59c7-4b37-83da-b65ab68e594b	Operações Especiais	operacoes-especiais	\N	PDF v1.1, p. 27
cc6e2cba-e7d3-4231-93ec-d35fb9ddb628	1e9480ec-e177-4b33-90c7-ea576c87b9af	d2222c7e-59c7-4b37-83da-b65ab68e594b	Tropa de Choque	tropa-de-choque	\N	PDF v1.1, p. 27
bc4eeef0-c7f0-42aa-bdb5-8da8bee5e549	1e9480ec-e177-4b33-90c7-ea576c87b9af	c9bd6935-a5db-4cb4-b99b-0621358c1820	Atirador de Elite	atirador-de-elite	\N	PDF v1.1, p. 30
280a09b3-fd40-4eb3-9526-54ac55abbe2f	1e9480ec-e177-4b33-90c7-ea576c87b9af	c9bd6935-a5db-4cb4-b99b-0621358c1820	Infiltrador	infiltrador	\N	PDF v1.1, p. 30
fb7d71d7-95bd-4488-bbc9-29e5249c30b7	1e9480ec-e177-4b33-90c7-ea576c87b9af	c9bd6935-a5db-4cb4-b99b-0621358c1820	Médico de Campo	medico-de-campo	\N	PDF v1.1, p. 31
7141a22a-5f2c-4eb5-b512-62b98a715394	1e9480ec-e177-4b33-90c7-ea576c87b9af	c9bd6935-a5db-4cb4-b99b-0621358c1820	Negociador	negociador	\N	PDF v1.1, p. 31
b2367dbe-fd86-4e01-a101-5796360aa3f6	1e9480ec-e177-4b33-90c7-ea576c87b9af	c9bd6935-a5db-4cb4-b99b-0621358c1820	Técnico	tecnico	\N	PDF v1.1, p. 31
bae9a72c-f706-4545-b3ee-616cd515d330	1e9480ec-e177-4b33-90c7-ea576c87b9af	97b09513-32b5-4ad9-9e13-18b6ed61be29	Conduíte	conduite	\N	PDF v1.1, p. 34
12e3b714-60dd-41e1-a1f5-8d6c04d841ca	1e9480ec-e177-4b33-90c7-ea576c87b9af	97b09513-32b5-4ad9-9e13-18b6ed61be29	Flagelador	flagelador	\N	PDF v1.1, pp. 34-35
d12fe3a2-9bf3-4a56-9145-e15bcaf43d62	1e9480ec-e177-4b33-90c7-ea576c87b9af	97b09513-32b5-4ad9-9e13-18b6ed61be29	Graduado	graduado	\N	PDF v1.1, p. 35
b74cab39-06bc-466f-9686-d73a2d575f5d	1e9480ec-e177-4b33-90c7-ea576c87b9af	97b09513-32b5-4ad9-9e13-18b6ed61be29	Intuitivo	intuitivo	\N	PDF v1.1, p. 35
155d6b43-cdf8-4a01-8ca7-1929b8a2b578	1e9480ec-e177-4b33-90c7-ea576c87b9af	97b09513-32b5-4ad9-9e13-18b6ed61be29	Lâmina Paranormal	lamina-paranormal	\N	PDF v1.1, p. 35
\.


--
-- Data for Name: archetype_ability_unlock; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.archetype_ability_unlock (archetype_id, ability_id, required_progression) FROM stdin;
1f333868-9304-42e0-a3e9-06e06a1ff9cf	245d8d18-3f3f-422a-a82f-99f34b84d584	10.00
1f333868-9304-42e0-a3e9-06e06a1ff9cf	65e1bd32-3abf-4902-b5d5-3a1249d32d20	40.00
1f333868-9304-42e0-a3e9-06e06a1ff9cf	500376c6-c753-4630-8eae-709fb2fbb0c0	65.00
1f333868-9304-42e0-a3e9-06e06a1ff9cf	c4c6f99f-3d42-4c10-bd91-73591768edb7	99.00
6e86c313-ba51-4b81-bd05-d1f6492e9ff7	9672616a-0efe-45a5-ba6f-228339900a6e	10.00
6e86c313-ba51-4b81-bd05-d1f6492e9ff7	b0f5f911-cd30-4079-833c-7d52c7850bf1	40.00
6e86c313-ba51-4b81-bd05-d1f6492e9ff7	1338a532-5b5c-4cfe-865a-984dff355d3c	65.00
6e86c313-ba51-4b81-bd05-d1f6492e9ff7	964dd8e2-22f3-40b3-9202-aa26ad36640c	99.00
3bf6bf10-acb6-4046-9203-96d23f965963	a6942f33-a5cc-478a-a5f7-a30ad18dbef7	10.00
3bf6bf10-acb6-4046-9203-96d23f965963	e5fff2f1-fb64-4bd0-a6cf-9107a5654efc	40.00
3bf6bf10-acb6-4046-9203-96d23f965963	54e7163e-ce22-42e7-8153-314c1dab5ad4	65.00
3bf6bf10-acb6-4046-9203-96d23f965963	33d5c8b4-f828-4876-9d2d-bb53313557fd	99.00
c0a0239f-7e01-4f2d-b11d-0b0d0ae2bfb4	a683be6a-3008-4e5c-93dc-2ca19f5e43b9	10.00
c0a0239f-7e01-4f2d-b11d-0b0d0ae2bfb4	19f875ae-ce2c-408d-85f4-0e29881eefcc	40.00
c0a0239f-7e01-4f2d-b11d-0b0d0ae2bfb4	5944d095-4755-493e-ad59-a7267e8bb625	65.00
c0a0239f-7e01-4f2d-b11d-0b0d0ae2bfb4	784f4aa8-776c-47a0-9650-a9d5cc28f349	99.00
cc6e2cba-e7d3-4231-93ec-d35fb9ddb628	172c539f-a02c-4348-8e7d-f69ca8ed6114	10.00
cc6e2cba-e7d3-4231-93ec-d35fb9ddb628	cd6e8a61-8cbc-428f-848f-d657f3d492e2	40.00
cc6e2cba-e7d3-4231-93ec-d35fb9ddb628	38804135-c2eb-4401-a8bb-0d01bbb78124	65.00
cc6e2cba-e7d3-4231-93ec-d35fb9ddb628	bbade6ff-9742-4868-8a0b-b1ed1e610f4c	99.00
bc4eeef0-c7f0-42aa-bdb5-8da8bee5e549	bbbe5c88-d6db-4ca9-9d85-810152bc352e	10.00
bc4eeef0-c7f0-42aa-bdb5-8da8bee5e549	6e15a89b-95f4-42a5-913d-f0de6b714a55	40.00
bc4eeef0-c7f0-42aa-bdb5-8da8bee5e549	b9596e8c-24a6-4a85-948b-955f174f62f5	65.00
bc4eeef0-c7f0-42aa-bdb5-8da8bee5e549	3a95a5be-be77-4f57-a0b0-bd464f618ee3	99.00
280a09b3-fd40-4eb3-9526-54ac55abbe2f	1cbd6ea6-dda9-44dc-85b7-c7705e876d37	10.00
280a09b3-fd40-4eb3-9526-54ac55abbe2f	a014f6a8-7cd6-47d9-aef3-f1ff7cdc69de	40.00
280a09b3-fd40-4eb3-9526-54ac55abbe2f	71b9fd01-8bea-4659-a1a8-fc30b5486a6c	65.00
280a09b3-fd40-4eb3-9526-54ac55abbe2f	a0194e45-64ea-4749-8fca-690ae177640a	99.00
fb7d71d7-95bd-4488-bbc9-29e5249c30b7	8d3722df-67f2-4559-afa8-d6503178ced6	10.00
fb7d71d7-95bd-4488-bbc9-29e5249c30b7	60d103ad-4106-4956-9339-a2ecb3123f9a	40.00
fb7d71d7-95bd-4488-bbc9-29e5249c30b7	7a48c18f-e4b3-48d9-8901-bc15b5531e4b	65.00
fb7d71d7-95bd-4488-bbc9-29e5249c30b7	69fa9118-a90b-4937-b520-1e3c017e3ae4	99.00
7141a22a-5f2c-4eb5-b512-62b98a715394	18e2126f-4536-4381-b408-08a850242244	10.00
7141a22a-5f2c-4eb5-b512-62b98a715394	23215030-2b1f-4a53-9fea-4e44483ed7ff	40.00
7141a22a-5f2c-4eb5-b512-62b98a715394	4fd6da2c-8652-4496-8a84-ecfcd25292b7	65.00
7141a22a-5f2c-4eb5-b512-62b98a715394	86841319-c3e0-4c0f-bc22-0ba264131da4	99.00
b2367dbe-fd86-4e01-a101-5796360aa3f6	402b6477-8bf7-478b-b24d-a4ac8d420461	10.00
b2367dbe-fd86-4e01-a101-5796360aa3f6	1fa9a1ef-1891-4f87-8d24-3b6e5dbbabba	40.00
b2367dbe-fd86-4e01-a101-5796360aa3f6	fa1208d2-2135-4958-8d18-c5f0ff6adfb7	65.00
b2367dbe-fd86-4e01-a101-5796360aa3f6	aa787350-5cb8-4459-bee3-fb0228e9603f	99.00
bae9a72c-f706-4545-b3ee-616cd515d330	632937ad-0a91-4f0d-bd74-df4124c1f898	10.00
bae9a72c-f706-4545-b3ee-616cd515d330	c9d4c150-0340-4d6f-bc34-49119e99913f	40.00
bae9a72c-f706-4545-b3ee-616cd515d330	1a3b2946-c9ff-4ff7-91f1-c5d3952f9ad4	65.00
bae9a72c-f706-4545-b3ee-616cd515d330	2abc7564-9063-4ef4-82db-6e015457f284	99.00
12e3b714-60dd-41e1-a1f5-8d6c04d841ca	1bbdccc2-0b19-4786-8617-e85c64a40f51	10.00
12e3b714-60dd-41e1-a1f5-8d6c04d841ca	d1447960-6336-4255-bfd5-cb99e36571ce	40.00
12e3b714-60dd-41e1-a1f5-8d6c04d841ca	de8991c4-763c-41b1-a750-e88c8529914d	65.00
12e3b714-60dd-41e1-a1f5-8d6c04d841ca	63f84939-2425-4e9e-884b-de8fe9eb674d	99.00
d12fe3a2-9bf3-4a56-9145-e15bcaf43d62	9e347308-6911-4d36-b04b-59f9d2b2cab2	10.00
d12fe3a2-9bf3-4a56-9145-e15bcaf43d62	efeb1430-c070-4b34-8b7e-89aff881dd7f	40.00
d12fe3a2-9bf3-4a56-9145-e15bcaf43d62	23ac072b-be0b-4e8f-8599-eb650e644d94	65.00
d12fe3a2-9bf3-4a56-9145-e15bcaf43d62	8c7f5fd2-79cd-40fd-9634-de96cd1e9a5b	99.00
b74cab39-06bc-466f-9686-d73a2d575f5d	c956d919-4817-4df8-8e0f-6849bed42aed	10.00
b74cab39-06bc-466f-9686-d73a2d575f5d	98c93fca-c126-48a2-a812-5571baa76c2f	40.00
b74cab39-06bc-466f-9686-d73a2d575f5d	43a189ac-e2a7-4dcb-838a-95dbba2144e9	65.00
b74cab39-06bc-466f-9686-d73a2d575f5d	c747d4e9-db06-4899-84b2-7b0525b3c94e	99.00
155d6b43-cdf8-4a01-8ca7-1929b8a2b578	73ce33ca-6a6e-451c-a3b0-ac9a79372f1b	10.00
155d6b43-cdf8-4a01-8ca7-1929b8a2b578	7ecedacf-757b-441d-bcf4-9d4c5360675c	40.00
155d6b43-cdf8-4a01-8ca7-1929b8a2b578	886e03c3-f083-41ce-9317-b5d795f48a3c	65.00
155d6b43-cdf8-4a01-8ca7-1929b8a2b578	85d43c4f-c14d-487a-bb2e-79c2704ca4d3	99.00
\.


--
-- Data for Name: attribute_definition; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.attribute_definition (id, rpg_system_id, name, slug, abbreviation, description, min_value, max_value, default_value, sort_order, source_ref) FROM stdin;
e2b6801d-3774-415d-b526-fb525eeffafc	1e9480ec-e177-4b33-90c7-ea576c87b9af	Agilidade	agilidade	AGI	\N	0.00	5.00	1.00	1	PDF v1.1, pp. 14-15
326d77c4-ec69-4301-9e30-c7bba5220302	1e9480ec-e177-4b33-90c7-ea576c87b9af	Força	forca	FOR	\N	0.00	5.00	1.00	2	PDF v1.1, pp. 14-15
8ca30379-0668-4272-aaef-f7891b4783f0	1e9480ec-e177-4b33-90c7-ea576c87b9af	Intelecto	intelecto	INT	\N	0.00	5.00	1.00	3	PDF v1.1, pp. 14-15
68fee4e0-784c-45c6-962c-d5c0a9b43609	1e9480ec-e177-4b33-90c7-ea576c87b9af	Presença	presenca	PRE	\N	0.00	5.00	1.00	4	PDF v1.1, pp. 14-15
5240f832-e2c1-4492-b8ee-8a040dec7950	1e9480ec-e177-4b33-90c7-ea576c87b9af	Vigor	vigor	VIG	\N	0.00	5.00	1.00	5	PDF v1.1, pp. 14-15
\.


--
-- Data for Name: rpg_character; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.rpg_character (id, rpg_system_id, name, character_type, description, image_url, appearance, personality, background, objective, created_at, updated_at) FROM stdin;
e2be0bb4-7c11-800b-ce51-7c9de1342c43	1e9480ec-e177-4b33-90c7-ea576c87b9af	Aberração de Carne	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
2fd41391-37dd-20d2-871e-cb71f4ebb278	1e9480ec-e177-4b33-90c7-ea576c87b9af	Aniquilação	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
0234288f-2f0c-872d-cbae-239b25da9cc7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Dama de Sangue	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
64b81aec-4e03-2fca-94e7-851dbd04b7a0	1e9480ec-e177-4b33-90c7-ea576c87b9af	Enpap-X	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
3587d753-20e6-0197-2b96-f948f5ca6bc9	1e9480ec-e177-4b33-90c7-ea576c87b9af	Kerberos	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
0f60fed6-a659-b802-3fb1-8f53d4278aaa	1e9480ec-e177-4b33-90c7-ea576c87b9af	Minotauro	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
553a94fb-382c-69c5-eac0-dfb12b2665bb	1e9480ec-e177-4b33-90c7-ea576c87b9af	Mulher Afogada	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
dc030186-e4b0-6b26-a3eb-cdb5e2980571	1e9480ec-e177-4b33-90c7-ea576c87b9af	Carente	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
e7ff9a66-e094-d347-aeb8-11e733c4a6df	1e9480ec-e177-4b33-90c7-ea576c87b9af	O Diabo	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
e247cdc1-d609-fa24-f339-7adb397a6ec7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Titã de Sangue	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
cf30b492-cace-69d4-8b39-8f091caf2499	1e9480ec-e177-4b33-90c7-ea576c87b9af	Zumbi de Sangue	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
d4da78e2-01d5-3a2c-cb04-bc56d7df0a5c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Zumbi de Sangue Bestial	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
67052271-cab5-1982-3cfc-2fff9fcf2c74	1e9480ec-e177-4b33-90c7-ea576c87b9af	Marionete	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
7c0fbcb9-f9cb-a886-2517-8bd5f4bcc597	1e9480ec-e177-4b33-90c7-ea576c87b9af	Anjo	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
2faad71f-e963-0d04-806c-e49455fac533	1e9480ec-e177-4b33-90c7-ea576c87b9af	Anárquico	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
e4866d22-2413-8a10-dc2f-30681c33a483	1e9480ec-e177-4b33-90c7-ea576c87b9af	Aracnasita	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
981e0906-addf-ca9b-c5e8-82659e6c64cf	1e9480ec-e177-4b33-90c7-ea576c87b9af	Carniçal	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
3e733982-0435-ca3a-40e2-20e2ac8d5195	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ceifador Espiral	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
40b5007f-2005-de03-e7f4-64783809fd47	1e9480ec-e177-4b33-90c7-ea576c87b9af	Enraizado	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
0bcc85f7-b3dd-c1dd-d8b9-95c8f01a8dda	1e9480ec-e177-4b33-90c7-ea576c87b9af	Escutado	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
48f329fb-339b-2f3c-ab5e-69c01707ec0e	1e9480ec-e177-4b33-90c7-ea576c87b9af	Esqueleto de Lodo	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
5e226c8d-e09f-ddc9-7963-811bd3cfa346	1e9480ec-e177-4b33-90c7-ea576c87b9af	Múmia Xipófaga	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
37785bcb-c312-1207-fa57-7c2553052220	1e9480ec-e177-4b33-90c7-ea576c87b9af	Nidere	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	1e9480ec-e177-4b33-90c7-ea576c87b9af	O Deus da Morte	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
a7e35038-1680-908a-be3a-60ad1debd522	1e9480ec-e177-4b33-90c7-ea576c87b9af	Sempiternal	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
99c9e528-e4ec-2c7b-da9c-1fb4cece6b74	1e9480ec-e177-4b33-90c7-ea576c87b9af	Succ	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
25556b0f-1ee2-f31a-5f84-21662ea3eeca	1e9480ec-e177-4b33-90c7-ea576c87b9af	Bicho-Papão	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
35167a4a-1da4-3662-c53c-1cc057cd8a9d	1e9480ec-e177-4b33-90c7-ea576c87b9af	Estrangeiro	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
189034de-8f01-36a7-87c6-1126d93d3450	1e9480ec-e177-4b33-90c7-ea576c87b9af	Existido	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
368972da-2308-bf04-7103-bca0de4932fd	1e9480ec-e177-4b33-90c7-ea576c87b9af	Lembrado	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
af9ebb2d-0f65-c58e-27bd-dbdb8f62445c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Máscara do Desespero	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
edbeef88-be85-94ce-b3af-00e5692c338e	1e9480ec-e177-4b33-90c7-ea576c87b9af	O Espreitador	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
15b07f11-8cdc-d86d-eebd-b745d86cb108	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ocioso	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
4c29680f-753d-b300-6316-69ab128fbd3f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Parasita de Culpa	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
63b121c2-516a-f562-feac-b6886de8f29f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Rastejador Sombrio	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
04f6c70d-ccd0-6736-5a7e-8b4380e81ecc	1e9480ec-e177-4b33-90c7-ea576c87b9af	Silhueta	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
eeb94d35-292d-e7b1-8686-0a2ea8a0ee90	1e9480ec-e177-4b33-90c7-ea576c87b9af	Vulto	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
72b4164d-66cb-3f52-c4c8-8fcb403bba7d	1e9480ec-e177-4b33-90c7-ea576c87b9af	Anárquico Descontrolado	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
d6ecb2e4-bd05-093f-d43f-26dca3d354bb	1e9480ec-e177-4b33-90c7-ea576c87b9af	Anomalia	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
22118520-6be3-b02f-f935-50333c06403e	1e9480ec-e177-4b33-90c7-ea576c87b9af	Anomiático	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
b55d1509-2803-fc09-cd9a-66772751e758	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ciborgue	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
4686e4e2-c047-5691-fbc4-11eb224493eb	1e9480ec-e177-4b33-90c7-ea576c87b9af	Infecticídio	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
600edb81-50a4-7ce3-bd94-7597458ec444	1e9480ec-e177-4b33-90c7-ea576c87b9af	O Anfitrião	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
7f48783f-86b6-c93c-962d-fbf5c9ccdb5b	1e9480ec-e177-4b33-90c7-ea576c87b9af	Perturbado de Energia	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
20f91d11-1834-d40f-02c1-8e8a0c81ee63	1e9480ec-e177-4b33-90c7-ea576c87b9af	Sukkalgir	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
9d273d68-1267-1193-d4e4-d7aade51df78	1e9480ec-e177-4b33-90c7-ea576c87b9af	Tempestuoso	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
cab21581-a023-2e27-8178-fa3898890bd4	1e9480ec-e177-4b33-90c7-ea576c87b9af	Telopsia	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
68da4a77-b1ae-6eef-aa7d-2d68a617bc8a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Sucuri	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
c9a49ecf-895c-9dac-0185-2e23764358cd	1e9480ec-e177-4b33-90c7-ea576c87b9af	Viajante	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
f87384c2-4e60-56db-a5de-3d654357a796	1e9480ec-e177-4b33-90c7-ea576c87b9af	Degolificada	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
cad9d205-0e8c-9d91-0142-7243852739f9	1e9480ec-e177-4b33-90c7-ea576c87b9af	Bandido	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
bf633d83-4d78-4b53-2e47-316dfd0e1768	1e9480ec-e177-4b33-90c7-ea576c87b9af	Capanga	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
6854df88-14b7-ca24-c1f7-31288fffdd87	1e9480ec-e177-4b33-90c7-ea576c87b9af	Soldado de Aluguel	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
2f48e0be-c76c-6a21-2b44-5774b1103744	1e9480ec-e177-4b33-90c7-ea576c87b9af	Assassino	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
9e5601b2-bd2e-485a-ee50-8082f3a83a92	1e9480ec-e177-4b33-90c7-ea576c87b9af	Comandante Mercenário	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
e2708871-e31f-4e67-dbba-e5962e66a3a5	1e9480ec-e177-4b33-90c7-ea576c87b9af	Iniciado	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
ddd48960-8422-2949-b599-893b178948ff	1e9480ec-e177-4b33-90c7-ea576c87b9af	Investido	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
5c2807af-f19e-54f2-27a2-22abbb0018eb	1e9480ec-e177-4b33-90c7-ea576c87b9af	Líder de Culto	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
53e7cc77-166b-4062-9521-4ebe729f086c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Policial	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
e6407482-d3e0-838d-0683-fa7173f8015c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Policial de Elite	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
a04aeb3a-4937-0509-3603-feaa1790ef36	1e9480ec-e177-4b33-90c7-ea576c87b9af	Chefe de Polícia	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
d1122566-9223-4957-1667-52b39dfa85b7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Cão de Guarda	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
42c8eb5b-7fda-8518-d251-45abb6239074	1e9480ec-e177-4b33-90c7-ea576c87b9af	Enxame de Abelhas	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
f5de5b9f-880b-44d7-f64a-63819147f4aa	1e9480ec-e177-4b33-90c7-ea576c87b9af	Enxame de Ratos	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
c1fe7c0a-1581-4610-0326-6176fca42f03	1e9480ec-e177-4b33-90c7-ea576c87b9af	Jacaré	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
a2655898-407a-8e76-c06b-1f88c15aba65	1e9480ec-e177-4b33-90c7-ea576c87b9af	Javaporco	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
e13d6f64-cbd7-8f33-a624-429f6f1ea8f8	1e9480ec-e177-4b33-90c7-ea576c87b9af	Onça-Pintada	THREAT	\N	\N	\N	\N	\N	\N	2026-08-27 20:27:26.019346-03	2026-08-27 20:27:26.019346-03
\.


--
-- Data for Name: character_ability; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.character_ability (character_id, ability_id, acquisition_source, acquired_at_progression, notes) FROM stdin;
\.


--
-- Data for Name: character_archetype; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.character_archetype (character_id, archetype_id) FROM stdin;
\.


--
-- Data for Name: item_type; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.item_type (id, rpg_system_id, parent_id, name, slug, description, source_ref) FROM stdin;
65485293-3c43-45cc-8a48-3eaf53887f86	1e9480ec-e177-4b33-90c7-ea576c87b9af	\N	Arma	arma	\N	PDF v1.1, p. 54
bfcb1a03-8dd8-4f29-9fe1-1ee940af62d8	1e9480ec-e177-4b33-90c7-ea576c87b9af	\N	Proteção	protecao	\N	PDF v1.1, p. 62
dcafd032-9c7f-413a-abc5-30a8dbecbc9a	1e9480ec-e177-4b33-90c7-ea576c87b9af	\N	Munição	municao	\N	PDF v1.1, p. 59
2d827511-b84a-4c82-8f9f-be9db2f6bb70	1e9480ec-e177-4b33-90c7-ea576c87b9af	\N	Equipamento Geral	equipamento-geral	\N	PDF v1.1, p. 63
ddb7420e-5168-4ca6-b27a-c92c643e6826	1e9480ec-e177-4b33-90c7-ea576c87b9af	2d827511-b84a-4c82-8f9f-be9db2f6bb70	Acessório	acessorio	\N	PDF v1.1, p. 63
e2181ffb-fb1a-43aa-a544-814a8cbf5a15	1e9480ec-e177-4b33-90c7-ea576c87b9af	2d827511-b84a-4c82-8f9f-be9db2f6bb70	Explosivo	explosivo	\N	PDF v1.1, p. 63
5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	1e9480ec-e177-4b33-90c7-ea576c87b9af	2d827511-b84a-4c82-8f9f-be9db2f6bb70	Item Operacional	item-operacional	\N	PDF v1.1, p. 63
1f0d4ef1-22c5-4b15-9c56-8b5c6b0b3770	1e9480ec-e177-4b33-90c7-ea576c87b9af	2d827511-b84a-4c82-8f9f-be9db2f6bb70	Item Paranormal	item-paranormal	\N	PDF v1.1, p. 63
665c26e8-301b-4226-aea8-5ac531a5c2dc	1e9480ec-e177-4b33-90c7-ea576c87b9af	\N	Item Amaldiçoado Especial	item-amaldicoado-especial	Itens amaldiçoados com mecânicas próprias, distintos de armas, proteções e acessórios que recebem maldições.	PDF v1.1, pp. 144 e 148-151
\.


--
-- Data for Name: item_definition; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.item_definition (id, rpg_system_id, item_type_id, name, slug, description, weight, source_ref) FROM stdin;
383fbb9e-ceab-4128-9d0b-58ecc7601e0f	1e9480ec-e177-4b33-90c7-ea576c87b9af	1f0d4ef1-22c5-4b15-9c56-8b5c6b0b3770	Amarras de (Elemento)	amarras-de-elemento	Amarras ligadas a um elemento paranormal. Podem ser gastas como armadilha ou usadas para laçar criaturas; ambas as formas exigem gasto de PE e testes de resistência conforme a regra do item.	\N	PDF v1.1, Tabela 3.10 e descrição pp. 66-67
4ee205f3-50f8-4813-bd30-e124e3f0bf65	1e9480ec-e177-4b33-90c7-ea576c87b9af	1f0d4ef1-22c5-4b15-9c56-8b5c6b0b3770	Câmera de Aura Paranormal	camera-de-aura-paranormal	Tirar uma foto exige ação padrão e 1 PE. A fotografia revela a presença de auras paranormais em pessoas e objetos.	\N	PDF v1.1, Tabela 3.10 e descrição p. 66
98ff934b-b8b3-4912-93c9-9386aa228fd4	1e9480ec-e177-4b33-90c7-ea576c87b9af	1f0d4ef1-22c5-4b15-9c56-8b5c6b0b3770	Componentes Ritualísticos de (Elemento)	componentes-ritualisticos-de-elemento	Conjunto de objetos necessário para conjurar rituais do elemento correspondente. Existem para Sangue, Morte, Conhecimento e Energia; não existem componentes ritualísticos de Medo.	\N	PDF v1.1, Tabela 3.10 e descrição p. 66
a5fb822f-ef91-486c-9689-b9f085402952	1e9480ec-e177-4b33-90c7-ea576c87b9af	1f0d4ef1-22c5-4b15-9c56-8b5c6b0b3770	Emissor de Pulsos Paranormais	emissor-de-pulsos-paranormais	Ativar exige ação completa e 1 PE. O aparelho emite um pulso de um elemento escolhido, atraindo criaturas do mesmo elemento e afastando criaturas do elemento oposto; as criaturas afetadas podem resistir com Vontade (DT Pre).	\N	PDF v1.1, Tabela 3.10 e descrição p. 67
10ba4b7f-205d-4f52-aec3-8defbf196f54	1e9480ec-e177-4b33-90c7-ea576c87b9af	1f0d4ef1-22c5-4b15-9c56-8b5c6b0b3770	Escuta de Ruídos Paranormais	escuta-de-ruidos-paranormais	Ativar exige ação completa e 2 PE. O aparelho grava ruídos paranormais por até 24 horas; ouvir a gravação concede +5 em testes de Ocultismo para identificar criatura.	\N	PDF v1.1, Tabela 3.10 e descrição p. 67
fbb63902-52f5-4d86-acec-0cd1762f4f40	1e9480ec-e177-4b33-90c7-ea576c87b9af	1f0d4ef1-22c5-4b15-9c56-8b5c6b0b3770	Medidor de Estabilidade da Membrana	medidor-de-estabilidade-da-membrana	Um agente treinado em Ocultismo pode utilizar o aparelho para avaliar o estado da Membrana em uma área. O resultado funciona como indício e não como resposta definitiva.	\N	PDF v1.1, descrição pp. 66-67; ausente da Tabela 3.10 v1.1
c49ef9fa-f7ef-455b-9e03-ef0479f70a97	1e9480ec-e177-4b33-90c7-ea576c87b9af	1f0d4ef1-22c5-4b15-9c56-8b5c6b0b3770	Scanner de Manifestação Paranormal de (Elemento)	scanner-de-manifestacao-paranormal-de-elemento	Ativar exige ação padrão. Enquanto ativo, consome 1 PE por rodada e informa a direção de manifestações paranormais do elemento escolhido em alcance longo, incluindo criaturas que possuam esse elemento como complemento.	\N	PDF v1.1, Tabela 3.10 e descrição p. 67
1edf9132-543b-46cf-9406-67472c8072bc	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Peitoral da Segunda Chance	peitoral-da-segunda-chance	Ao cair a 0 PV, gasta automaticamente 5 PE do usuário para reanimá-lo com 4d10 PV. Sem PE suficiente não funciona. A cada ativação há chance de 1 em 1d10 de matar o usuário instantaneamente.	\N	PDF v1.1, p. 150
89873742-deaf-4b9d-b640-8bae95cafbf7	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Relógio de Arnaldo	relogio-de-arnaldo	Uma vez por rodada pode gastar 1 PE para rolar novamente qualquer dado cujo resultado tenha sido 1. O custo aumenta em +1 PE para cada ativação adicional no mesmo dia.	\N	PDF v1.1, p. 150
e4ba7bc5-403f-427c-b1d6-79eeb7e99154	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Talismã da Sorte	talisma-da-sorte	Ao sofrer dano enquanto veste o talismã, reação e 3 PE permitem rolar 1d4: 2-3 evitam o dano; 4 evita e destrói o talismã; 1 dobra o dano e também destrói o talismã.	\N	PDF v1.1, pp. 150-151
d3d3e810-cfbc-4535-b806-e2bf62c1dde3	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Teclado de Conexão Neural	teclado-de-conexao-neural	Conectar ao computador exige ação de movimento. Remove impedimentos tecnológicos ou de idioma, concede +10 para hackear e reduz à metade o tempo para localizar arquivos; causa 1d6 de dano mental por rodada de uso.	\N	PDF v1.1, p. 151
2d6b71b1-0ee0-4511-80f0-a1f5fb72f25f	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Tela do Pesadelo	tela-do-pesadelo	Ação padrão e 2 PE armam a tela. A próxima pessoa que tocar faz Vontade contra DT do usuário +5; falha causa atordoamento e 4d6 de dano mental, repetindo o teste nas rodadas seguintes até encerrar o efeito.	\N	PDF v1.1, p. 151
90317f8e-1ea2-4d19-b242-a7839e71f4b7	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Veículo Energizado	veiculo-energizado	Não precisa de combustível. O motorista pode usar reação e Pilotagem DT 25 para tornar veículo e ocupantes momentaneamente incorpóreos em forma de Energia e atravessar um objeto, evitando colisão.	\N	PDF v1.1, p. 151
1481983b-e1c4-4702-a45c-6fe1960590b5	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Jaqueta de Veríssimo	jaqueta-de-verissimo	Concede resistência a dano paranormal 15. Quando aliado adjacente sofreria dano, reação e 2 PE permitem que o usuário se torne o alvo do dano. É item único e explicitamente categoria IV.	\N	PDF v1.1, p. 151
5077ff76-8154-449f-ba0c-0f917ed12c5d	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Coração Pulsante	coracao-pulsante	Ao sofrer dano enquanto empunha o item, pode usar reação para reduzir esse dano à metade. Cada uso exige Fortitude DT 15 + 5 por uso adicional no mesmo dia; falha destrói o item.	\N	PDF v1.1, p. 148
d386d4b4-e689-4f4d-97fc-4774585e92eb	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Coroa de Espinhos	coroa-de-espinhos	Uma vez por rodada, pode usar reação para converter dano mental recebido em dano de Sangue. Enquanto veste o item não recupera Sanidade por descanso. Exige uma semana de uso para ativar.	\N	PDF v1.1, p. 148
a9450faa-413a-43d9-a201-4c4801d90eff	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Frasco de Vitalidade	frasco-de-vitalidade	Pode sofrer até 20 PV em 1 minuto para armazenar sangue. Beber exige ação padrão e recupera a mesma quantidade armazenada; Fortitude DT 20 evita ficar enjoado por uma rodada.	\N	PDF v1.1, p. 148
e6f60a15-29fa-474a-8fb9-aa7dc881a3e4	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Pérola de Sangue	perola-de-sangue	Ação de movimento para absorver: recebe +5 em testes de Agilidade, Força e Vigor e testes baseados nesses atributos até o fim da cena. Depois faz Fortitude DT 20; falha causa fadiga, e falha por 5 ou mais deixa morrendo.	\N	PDF v1.1, p. 148
82f2c5fd-291f-405d-9ebc-d34721d39de3	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Punhos Enraivecidos	punhos-enraivecidos	Ataques desarmados causam 1d8 de dano de Sangue. Após acertar, pode atacar novamente o mesmo alvo pagando PE crescente: 2 PE pelo primeiro ataque extra, depois +2 PE a cada novo ataque extra no turno.	\N	PDF v1.1, p. 148
edec1c28-f343-4368-8625-dba996f9a283	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Seringa de Transfiguração	seringa-de-transfiguracao	Pode coletar sangue de alvo adjacente e injetá-lo em outra pessoa para reproduzir a aparência do dono do sangue por um dia, como Distorcer Aparência. Ao terminar, resultado 1 em 1d6 causa perda permanente de 1 PV.	\N	PDF v1.1, pp. 148-149
12fc8472-32c2-457d-9571-e6b878217eb3	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Amarras Mortais	amarras-mortais	Uma vez por rodada, ação padrão e 2 PE permitem agarrar alvo Grande ou menor em alcance curto com +10 no teste oposto. Ação de movimento pode puxar o alvo agarrado para adjacente.	\N	PDF v1.1, p. 149
53b4555b-e446-4335-adc9-a445ba083659	1e9480ec-e177-4b33-90c7-ea576c87b9af	dcafd032-9c7f-413a-abc5-30a8dbecbc9a	Balas curtas	balas-curtas	\N	\N	PDF v1.1, Tabela 3.4 p. 59
cc792318-e26e-4841-93e5-4b6707f802de	1e9480ec-e177-4b33-90c7-ea576c87b9af	dcafd032-9c7f-413a-abc5-30a8dbecbc9a	Balas longas	balas-longas	\N	\N	PDF v1.1, Tabela 3.4 p. 59
395bf90d-d51c-44a3-a37d-8e895dd73104	1e9480ec-e177-4b33-90c7-ea576c87b9af	dcafd032-9c7f-413a-abc5-30a8dbecbc9a	Cartuchos	cartuchos	\N	\N	PDF v1.1, Tabela 3.4 p. 59
f4635410-9f0b-4784-a02f-cb7810059f9b	1e9480ec-e177-4b33-90c7-ea576c87b9af	dcafd032-9c7f-413a-abc5-30a8dbecbc9a	Combustível	combustivel	\N	\N	PDF v1.1, Tabela 3.4 p. 59
31b0f633-04b1-488d-ad4f-b71aa4ce66ec	1e9480ec-e177-4b33-90c7-ea576c87b9af	dcafd032-9c7f-413a-abc5-30a8dbecbc9a	Flechas	flechas	\N	\N	PDF v1.1, Tabela 3.4 p. 59
79671d81-d320-4c86-aa57-f15a74f64164	1e9480ec-e177-4b33-90c7-ea576c87b9af	dcafd032-9c7f-413a-abc5-30a8dbecbc9a	Foguete	foguete	\N	\N	PDF v1.1, Tabela 3.4 p. 59
2a03f265-77cf-4198-8ec1-313bc60c57b2	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Coronhada	coronhada	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
f006cf61-cf4c-44ad-b6bd-3b5572943831	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Faca	faca	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
9841f810-b40e-48f0-a30f-edb09e0b9e3f	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Martelo	martelo	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
f5f41815-1280-44a7-ba89-2653cb568ae1	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Punhal	punhal	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
1b6b7bec-ea6f-49df-83d2-1d01aba0ca89	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Bastão	bastao	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
65a4f42a-1d7f-4b1c-afff-58780de65f74	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Machete	machete	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
7ef0a39b-c538-4e5e-8057-41a5a43a65eb	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Lança	lanca	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
ad09228f-4b31-45ad-a2c6-cd24a96e4b43	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Cajado	cajado	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
cffdb0d5-3f0b-4cec-af72-095d3b1065a5	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Arco	arco	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
85d54c02-ed53-4c01-9e7f-d64a0ea964a4	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Besta	besta	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
ab571040-908c-4c06-a6f7-2ffca307360f	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Pistola	pistola	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
5c1716e3-e12f-4d76-b1b0-b6ca9412baa9	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Revólver	revolver	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
7419f5db-0b38-4729-817f-6dd8eeb28102	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Fuzil de caça	fuzil-de-caca	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
5d927ec1-33aa-41c8-b50e-e8100e4add4d	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Machadinha	machadinha	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
d9761921-ea0b-4cc8-a08f-c23f5803740a	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Nunchaku	nunchaku	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
00229d7c-8ac4-4931-afdb-eae0739002cd	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Corrente	corrente	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
013cf605-2a17-497d-9256-cd12983b6d1c	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Espada	espada	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
84e059f1-fd54-45bb-b3eb-904b8b0856ee	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Florete	florete	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
08f23594-8c5e-46c8-8302-bd5981b27548	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Machado	machado	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
54853ae4-d9bc-4f7c-a5d7-a3cc9e8b2436	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Maça	maca	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
a236ba82-e0f8-4698-ad57-f68342bd16cf	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Acha	acha	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
420a81d7-3b32-4494-b689-31265aab1fb7	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Gadanho	gadanho	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
7e947a37-1106-4cd6-b978-db8e238f7d40	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Katana	katana	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
9ff75b0d-fea4-412e-9905-3cb05b05e6f7	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Marreta	marreta	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
38b796fe-e581-47db-b7e4-e2704979b5aa	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Montante	montante	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
8aa191b4-b7a8-4899-84d5-744f5db6c64f	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Motoserra	motoserra	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
939eb1ab-25ce-4edb-92ed-38eb9d9c4e53	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Arco composto	arco-composto	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
d28c7613-c52d-4b47-8779-34e8239831ff	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Balestra	balestra	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
48772a13-c938-4e39-87d5-99913fbaa6e6	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Submetralhadora	submetralhadora	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
ca60c4f8-85e1-416b-853f-93843bc016b5	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Espingarda	espingarda	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
385a729f-b5e6-48c8-b545-1b13ac41d7f3	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Fuzil de assalto	fuzil-de-assalto	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
0ddc72d6-5f59-4511-bbdf-dc14c9157718	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Fuzil de precisão	fuzil-de-precisao	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
29cc2007-98fc-4a83-850e-640887fa7de1	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Bazuca	bazuca	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
c840c186-9ef5-4273-aa2f-a1678d4deac3	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Lança-chamas	lanca-chamas	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
8b6c90e5-bb56-464a-b37c-50d9c0bbf8e8	1e9480ec-e177-4b33-90c7-ea576c87b9af	65485293-3c43-45cc-8a48-3eaf53887f86	Metralhadora	metralhadora	\N	\N	PDF v1.1, Tabela 3.3 pp. 56-57
7015769c-d533-4974-b4c2-35332f58f0f0	1e9480ec-e177-4b33-90c7-ea576c87b9af	bfcb1a03-8dd8-4f29-9fe1-1ee940af62d8	Proteção Leve	protecao-leve	\N	\N	PDF v1.1, Tabela 3.6 p. 62
cc7349b0-c449-41e4-85c3-12f1a6acb823	1e9480ec-e177-4b33-90c7-ea576c87b9af	bfcb1a03-8dd8-4f29-9fe1-1ee940af62d8	Proteção Pesada	protecao-pesada	\N	\N	PDF v1.1, Tabela 3.6 p. 62
bfc79980-3691-46e0-b9bf-0a185e5b4398	1e9480ec-e177-4b33-90c7-ea576c87b9af	bfcb1a03-8dd8-4f29-9fe1-1ee940af62d8	Escudo	escudo	\N	\N	PDF v1.1, Tabela 3.6 p. 62
e5781039-d00d-4f94-932c-4b26f07df835	1e9480ec-e177-4b33-90c7-ea576c87b9af	ddb7420e-5168-4ca6-b27a-c92c643e6826	Kit de perícia	kit-de-pericia	\N	\N	PDF v1.1, Tabela 3.8 p. 63
a01a1615-868e-46dd-8fa0-a1074cc65097	1e9480ec-e177-4b33-90c7-ea576c87b9af	ddb7420e-5168-4ca6-b27a-c92c643e6826	Utensílio	utensilio	\N	\N	PDF v1.1, Tabela 3.8 p. 63
a5be980b-bec7-4fc5-bc99-c679635a387c	1e9480ec-e177-4b33-90c7-ea576c87b9af	ddb7420e-5168-4ca6-b27a-c92c643e6826	Vestimenta	vestimenta	\N	\N	PDF v1.1, Tabela 3.8 p. 63
39263678-522e-4c00-8818-e158049ebe63	1e9480ec-e177-4b33-90c7-ea576c87b9af	e2181ffb-fb1a-43aa-a544-814a8cbf5a15	Granada de atordoamento	granada-de-atordoamento	\N	\N	PDF v1.1, Tabela 3.8 p. 63
9436a317-4b37-4793-83bd-f56fb26a048d	1e9480ec-e177-4b33-90c7-ea576c87b9af	e2181ffb-fb1a-43aa-a544-814a8cbf5a15	Granada de fragmentação	granada-de-fragmentacao	\N	\N	PDF v1.1, Tabela 3.8 p. 63
55ff885d-dcc8-40ea-bd4d-4a66fc7f4581	1e9480ec-e177-4b33-90c7-ea576c87b9af	e2181ffb-fb1a-43aa-a544-814a8cbf5a15	Granada de fumaça	granada-de-fumaca	\N	\N	PDF v1.1, Tabela 3.8 p. 63
f4564a3f-d89d-4f84-be10-b7e6df90c694	1e9480ec-e177-4b33-90c7-ea576c87b9af	e2181ffb-fb1a-43aa-a544-814a8cbf5a15	Granada incendiária	granada-incendiaria	\N	\N	PDF v1.1, Tabela 3.8 p. 63
d316f3c6-1dbe-4ff8-ad2d-5d9522d5a802	1e9480ec-e177-4b33-90c7-ea576c87b9af	e2181ffb-fb1a-43aa-a544-814a8cbf5a15	Mina antipessoal	mina-antipessoal	\N	\N	PDF v1.1, Tabela 3.8 p. 63
6d7293af-76e1-4204-a356-282faf18d115	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Algemas	algemas	\N	\N	PDF v1.1, Tabela 3.8 p. 63
1faf5cc0-8ebe-4c5d-91c4-abbd109b1dc6	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Arpéu	arpeu	\N	\N	PDF v1.1, Tabela 3.8 p. 63
ca7e6f35-3fb2-43ff-9848-fef26f18dcdd	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Bandoleira	bandoleira	\N	\N	PDF v1.1, Tabela 3.8 p. 63
121b2dac-40a1-4817-8814-c56585363fa6	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Binóculos	binoculos	\N	\N	PDF v1.1, Tabela 3.8 p. 63
9bd8c7d6-009b-4ef6-8d16-8c395095330c	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Bloqueador de sinal	bloqueador-de-sinal	\N	\N	PDF v1.1, Tabela 3.8 p. 63
324d519e-bf3d-46ed-a203-bba8e6530870	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Cicatrizante	cicatrizante	\N	\N	PDF v1.1, Tabela 3.8 p. 63
15570622-eb6b-4b01-b4c4-6528fc5056a8	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Corda	corda	\N	\N	PDF v1.1, Tabela 3.8 p. 63
bd96d88e-9240-4cf7-96c9-17741508c6c7	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Equipamento de sobrevivência	equipamento-de-sobrevivencia	\N	\N	PDF v1.1, Tabela 3.8 p. 63
13f1d4cc-92ef-4784-be44-167c91faa965	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Lanterna tática	lanterna-tatica	\N	\N	PDF v1.1, Tabela 3.8 p. 63
5474f0f4-9ddb-41dc-94b4-d56b7e21e183	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Máscara de gás	mascara-de-gas	\N	\N	PDF v1.1, Tabela 3.8 p. 63
067cb40d-abb8-47c8-bac3-1dd7987001a9	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Mochila militar	mochila-militar	\N	\N	PDF v1.1, Tabela 3.8 p. 63
f6f827b6-7c4b-4a5d-bdb8-1fc7277fabfd	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Óculos de visão térmica	oculos-de-visao-termica	\N	\N	PDF v1.1, Tabela 3.8 p. 63
e2f04b54-67a1-4353-80f2-edfaaab84800	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Pé de cabra	pe-de-cabra	\N	\N	PDF v1.1, Tabela 3.8 p. 63
80178930-50c0-4a08-b3fc-d682739fb14b	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Pistola de dardos	pistola-de-dardos	\N	\N	PDF v1.1, Tabela 3.8 p. 63
7647dd6a-1c91-4c3b-a106-658dc556df5b	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Pistola sinalizadora	pistola-sinalizadora	\N	\N	PDF v1.1, Tabela 3.8 p. 63
a37f18b1-753c-4d63-adec-c51ce6afba9a	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Soqueira	soqueira	\N	\N	PDF v1.1, Tabela 3.8 p. 63
57bdecfd-8af8-4bc7-b214-258c97e0ab11	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Spray de pimenta	spray-de-pimenta	\N	\N	PDF v1.1, Tabela 3.8 p. 63
a82cd550-1117-480e-958b-d7e22ea07fb6	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Taser	taser	\N	\N	PDF v1.1, Tabela 3.8 p. 63
ca6ee024-40e6-4dd6-b25d-e713ba95baee	1e9480ec-e177-4b33-90c7-ea576c87b9af	5081f72b-d88c-4e76-a3ae-7d8be9cbc5b8	Traje hazmat	traje-hazmat	\N	\N	PDF v1.1, Tabela 3.8 p. 63
7cd71efd-7c4f-4aec-90e6-e88231cffe86	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Casaco de Lodo	casaco-de-lodo	Concede resistência 5 a corte, impacto, Morte e perfuração, mas torna o usuário vulnerável a dano balístico e de Energia.	\N	PDF v1.1, p. 149
b27a6267-dc98-44bb-bbb7-52d5a3be1697	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Coletora	coletora	Ação completa para matar uma pessoa morrendo e armazenar 1d8 PE; capacidade máxima 20 PE. Os PE armazenados podem ser usados após portar a adaga por pelo menos uma semana. Enquanto a porta, descanso é sempre ruim.	\N	PDF v1.1, p. 149
a54e7348-9f3a-43ed-bc71-2e5a53ca3210	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Crânio Espiral	cranio-espiral	Uma vez por rodada, enquanto empunhado, ação livre concede uma ação padrão adicional. Cada uso exige Vontade DT 15 + 5 por uso adicional no dia; em falha ainda recebe o benefício, envelhece 1d4 anos e não pode usar de novo naquele dia.	\N	PDF v1.1, p. 149
901620e5-904d-4efd-ac78-7fe93c3c75f7	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Frasco de Lodo	frasco-de-lodo	Ação padrão em ferimento de até uma rodada recupera 6d8+20 PV. Em ferimento mais antigo, resultado par recupera 3d8+10 PV e resultado ímpar causa 3d8+10 de dano de Morte. Possui uma única ativação.	\N	PDF v1.1, p. 149
89938177-68b2-4843-bc24-ed1741149714	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Vislumbre do Fim	vislumbre-do-fim	Ação de movimento focando um ser visível revela informação sobre sua morte. Contra Marcados ou criaturas informa a pior resistência entre Fortitude, Reflexos e Vontade e as vulnerabilidades do alvo.	\N	PDF v1.1, p. 149
c6636b06-7dae-46c4-8a32-9062caf6320f	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Anéis do Elo Mental	aneis-do-elo-mental	Duas pessoas devem usar os anéis por 24 horas. Depois permanecem em ligação telepática enquanto os usam; testes de Vontade usam a melhor quantidade de dados e bônus entre as duas, mas dano mental e condições mentais ou de medo são compartilhados.	\N	PDF v1.1, pp. 149-150
d8681053-5ab6-42d3-b6c7-909187aec931	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Lanterna Reveladora	lanterna-reveladora	Ativar exige ação padrão e 1 PE; dura uma cena e emite luz com propriedades de Terceiro Olho. Criaturas de Sangue iluminadas priorizam atacar o usuário entre alvos na mesma categoria de alcance.	\N	PDF v1.1, p. 150
aa72bf67-e439-49ce-95b6-8bbfb901efc1	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Máscara das Pessoas nas Sombras	mascara-das-pessoas-nas-sombras	Concede resistência a Conhecimento 10. Ação de movimento e 2 PE permitem entrar em sombra adjacente e teleportar para outra sombra visível em alcance médio.	\N	PDF v1.1, p. 150
0e06beed-b3b9-4499-ade6-f4fb86e4cd7a	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Munição Jurada	municao-jurada	Ritual de uma hora vincula a munição a um ser conhecido. Contra esse alvo concede +10 no ataque, dobra a margem de ameaça e causa +6d12 de Conhecimento; enquanto a possui, sofre -2 em Defesa e ataques contra outros alvos.	\N	PDF v1.1, p. 150
cf52e92a-2833-4477-bbb0-e20e3e07b1d2	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Pergaminho da Pertinácia	pergaminho-da-pertinacia	Ação padrão concede 5 PE temporários até o fim da cena. Cada uso exige Ocultismo DT 15 + 5 por uso adicional no mesmo dia; em falha o pergaminho se desfaz.	\N	PDF v1.1, p. 150
58650147-9f8e-4b18-ac8e-b0cf7c70efbf	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Arcabuz dos Moretti	arcabuz-dos-moretti	Arma simples de fogo e uma mão, +2 em ataques, alcance curto, crítico x3 e sem munição. Em cada disparo rola 1d6: o resultado define o dano entre 2d4, 2d6, 2d8, 2d10, 2d12 ou 2d20.	\N	PDF v1.1, p. 150
ff0e93b4-db09-4124-803e-21f4562385ef	1e9480ec-e177-4b33-90c7-ea576c87b9af	665c26e8-301b-4226-aea8-5ac531a5c2dc	Bateria Reversa	bateria-reversa	Ação padrão e 2 PE descarregam dispositivo eletrônico em alcance curto; quando carregada pode reenergizar um dispositivo descarregado. Cada uso exige Ocultismo DT 15 + 5 por uso adicional no dia; falha causa explosão de 12d6 de Energia em raio de 3m.	\N	PDF v1.1, p. 150
\.


--
-- Data for Name: skill_definition; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.skill_definition (id, rpg_system_id, base_attribute_id, name, slug, description, allows_specialization, sort_order, source_ref) FROM stdin;
922c3c2d-32bf-4414-bbf2-a741f63c50b6	1e9480ec-e177-4b33-90c7-ea576c87b9af	e2b6801d-3774-415d-b526-fb525eeffafc	Acrobacia	acrobacia	\N	f	1	PDF v1.1, Tabela 2.1 p. 41
30156222-5290-4ddc-8c83-739aff02497f	1e9480ec-e177-4b33-90c7-ea576c87b9af	68fee4e0-784c-45c6-962c-d5c0a9b43609	Adestramento	adestramento	\N	f	2	PDF v1.1, Tabela 2.1 p. 41
8f05e179-5621-4e25-a969-a23dff5d6941	1e9480ec-e177-4b33-90c7-ea576c87b9af	68fee4e0-784c-45c6-962c-d5c0a9b43609	Artes	artes	\N	f	3	PDF v1.1, Tabela 2.1 p. 41
6c2d9b01-f885-4d52-90e6-53d307409f12	1e9480ec-e177-4b33-90c7-ea576c87b9af	326d77c4-ec69-4301-9e30-c7bba5220302	Atletismo	atletismo	\N	f	4	PDF v1.1, Tabela 2.1 p. 41
96e4e0b9-f67c-4aee-99fc-668d9c46a2b2	1e9480ec-e177-4b33-90c7-ea576c87b9af	8ca30379-0668-4272-aaef-f7891b4783f0	Atualidades	atualidades	\N	f	5	PDF v1.1, Tabela 2.1 p. 41
0859d45c-5039-4d4a-8ca9-b0935107e533	1e9480ec-e177-4b33-90c7-ea576c87b9af	8ca30379-0668-4272-aaef-f7891b4783f0	Ciências	ciencias	\N	f	6	PDF v1.1, Tabela 2.1 p. 41
487a4440-5a08-4a97-badf-cc59a6af8d78	1e9480ec-e177-4b33-90c7-ea576c87b9af	e2b6801d-3774-415d-b526-fb525eeffafc	Crime	crime	\N	f	7	PDF v1.1, Tabela 2.1 p. 41
93ffe95b-b0ef-4faa-b693-c375bcdd22cb	1e9480ec-e177-4b33-90c7-ea576c87b9af	68fee4e0-784c-45c6-962c-d5c0a9b43609	Diplomacia	diplomacia	\N	f	8	PDF v1.1, Tabela 2.1 p. 41
83b28425-380e-4b8c-b244-c8c9cfe3e0d7	1e9480ec-e177-4b33-90c7-ea576c87b9af	68fee4e0-784c-45c6-962c-d5c0a9b43609	Enganação	enganacao	\N	f	9	PDF v1.1, Tabela 2.1 p. 41
07fc0547-5b68-4f71-8cdd-06dde575b4d2	1e9480ec-e177-4b33-90c7-ea576c87b9af	5240f832-e2c1-4492-b8ee-8a040dec7950	Fortitude	fortitude	\N	f	10	PDF v1.1, Tabela 2.1 p. 41
c3841196-d89d-4c41-a890-93bee7644b03	1e9480ec-e177-4b33-90c7-ea576c87b9af	e2b6801d-3774-415d-b526-fb525eeffafc	Furtividade	furtividade	\N	f	11	PDF v1.1, Tabela 2.1 p. 41
64cf1a15-4bbf-4086-80a8-bdab541beb54	1e9480ec-e177-4b33-90c7-ea576c87b9af	e2b6801d-3774-415d-b526-fb525eeffafc	Iniciativa	iniciativa	\N	f	12	PDF v1.1, Tabela 2.1 p. 41
3fd8bc69-1f47-4b7c-b6c3-48e260b37148	1e9480ec-e177-4b33-90c7-ea576c87b9af	68fee4e0-784c-45c6-962c-d5c0a9b43609	Intimidação	intimidacao	\N	f	13	PDF v1.1, Tabela 2.1 p. 41
6addb566-ad62-47fc-ada7-3a4789206784	1e9480ec-e177-4b33-90c7-ea576c87b9af	8ca30379-0668-4272-aaef-f7891b4783f0	Intuição	intuicao	\N	f	14	PDF v1.1, Tabela 2.1 p. 41
4c0358e5-dab8-4778-a4f5-3de3b34bd2d7	1e9480ec-e177-4b33-90c7-ea576c87b9af	8ca30379-0668-4272-aaef-f7891b4783f0	Investigação	investigacao	\N	f	15	PDF v1.1, Tabela 2.1 p. 41
8cf55386-5621-415f-9ca3-c1dfc4e81348	1e9480ec-e177-4b33-90c7-ea576c87b9af	326d77c4-ec69-4301-9e30-c7bba5220302	Luta	luta	\N	f	16	PDF v1.1, Tabela 2.1 p. 41
72482ffd-cb13-4b1e-bece-303fb9c3685f	1e9480ec-e177-4b33-90c7-ea576c87b9af	8ca30379-0668-4272-aaef-f7891b4783f0	Medicina	medicina	\N	f	17	PDF v1.1, Tabela 2.1 p. 41
1a2ed4bd-bed4-446b-b743-d18d60c130e5	1e9480ec-e177-4b33-90c7-ea576c87b9af	8ca30379-0668-4272-aaef-f7891b4783f0	Ocultismo	ocultismo	\N	f	18	PDF v1.1, Tabela 2.1 p. 41
fb22f984-cd2b-41e5-af86-812d9591e6aa	1e9480ec-e177-4b33-90c7-ea576c87b9af	68fee4e0-784c-45c6-962c-d5c0a9b43609	Percepção	percepcao	\N	f	19	PDF v1.1, Tabela 2.1 p. 41
e1f4663c-d0d3-4cb1-9da6-9d99e22c1177	1e9480ec-e177-4b33-90c7-ea576c87b9af	e2b6801d-3774-415d-b526-fb525eeffafc	Pilotagem	pilotagem	\N	f	20	PDF v1.1, Tabela 2.1 p. 41
30b4680b-1aea-481e-a428-c47a99263cf4	1e9480ec-e177-4b33-90c7-ea576c87b9af	e2b6801d-3774-415d-b526-fb525eeffafc	Pontaria	pontaria	\N	f	21	PDF v1.1, Tabela 2.1 p. 41
02239e12-80b2-4762-8b4b-3e5edf4d89a9	1e9480ec-e177-4b33-90c7-ea576c87b9af	8ca30379-0668-4272-aaef-f7891b4783f0	Profissão	profissao	\N	t	22	PDF v1.1, Tabela 2.1 p. 41
8372aaee-85ba-4abc-bbca-6b0625883bbc	1e9480ec-e177-4b33-90c7-ea576c87b9af	e2b6801d-3774-415d-b526-fb525eeffafc	Reflexos	reflexos	\N	f	23	PDF v1.1, Tabela 2.1 p. 41
5c7ac341-4006-499e-a262-3cf85498a442	1e9480ec-e177-4b33-90c7-ea576c87b9af	68fee4e0-784c-45c6-962c-d5c0a9b43609	Religião	religiao	\N	f	24	PDF v1.1, Tabela 2.1 p. 41
902d9e87-64b2-4da8-b4ea-165283027f1a	1e9480ec-e177-4b33-90c7-ea576c87b9af	8ca30379-0668-4272-aaef-f7891b4783f0	Sobrevivência	sobrevivencia	\N	f	25	PDF v1.1, Tabela 2.1 p. 41
028f7ff4-efab-4bd3-8922-a9f431b9da2c	1e9480ec-e177-4b33-90c7-ea576c87b9af	8ca30379-0668-4272-aaef-f7891b4783f0	Tática	tatica	\N	f	26	PDF v1.1, Tabela 2.1 p. 41
80194d65-0aa6-4cec-926f-82561e36750e	1e9480ec-e177-4b33-90c7-ea576c87b9af	8ca30379-0668-4272-aaef-f7891b4783f0	Tecnologia	tecnologia	\N	f	27	PDF v1.1, Tabela 2.1 p. 41
352f5340-7a8a-4d88-ad7c-70cb86d6fbef	1e9480ec-e177-4b33-90c7-ea576c87b9af	68fee4e0-784c-45c6-962c-d5c0a9b43609	Vontade	vontade	\N	f	28	PDF v1.1, Tabela 2.1 p. 41
\.


--
-- Data for Name: character_attack; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.character_attack (id, character_id, source_item_id, skill_id, name, test_expression, damage_expression, damage_type, attack_bonus, critical_threshold, critical_multiplier, range_text, special) FROM stdin;
\.


--
-- Data for Name: character_attribute; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.character_attribute (character_id, attribute_id, value) FROM stdin;
\.


--
-- Data for Name: character_class; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.character_class (character_id, class_id, primary_class) FROM stdin;
\.


--
-- Data for Name: character_item; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.character_item (id, character_id, item_id, quantity, equipped, notes) FROM stdin;
\.


--
-- Data for Name: origin_definition; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.origin_definition (id, rpg_system_id, name, slug, description, source_ref) FROM stdin;
2e972664-8ec6-4cd2-9fa7-c74cf278d7fd	1e9480ec-e177-4b33-90c7-ea576c87b9af	Acadêmico	academico	\N	PDF v1.1, Tabela 1.1 p. 19
0a1ef649-4dbe-4e61-adf2-8863a5a425ba	1e9480ec-e177-4b33-90c7-ea576c87b9af	Agente de Saúde	agente-de-saude	\N	PDF v1.1, Tabela 1.1 p. 19
8bcbd258-0259-457a-8eb5-6314e3412491	1e9480ec-e177-4b33-90c7-ea576c87b9af	Amnésico	amnesico	\N	PDF v1.1, Tabela 1.1 p. 19
d4c64c0d-b88b-42dc-9abb-f2110a6158b7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Artista	artista	\N	PDF v1.1, Tabela 1.1 p. 19
1479018f-d88e-4baa-9d24-1e8e7f416bc4	1e9480ec-e177-4b33-90c7-ea576c87b9af	Atleta	atleta	\N	PDF v1.1, Tabela 1.1 p. 19
92b069e1-c8c2-41b4-8abf-bec0dd3dffc3	1e9480ec-e177-4b33-90c7-ea576c87b9af	Chef	chef	\N	PDF v1.1, Tabela 1.1 p. 19
17dd0e12-e007-40fc-a0db-85b78c081ce1	1e9480ec-e177-4b33-90c7-ea576c87b9af	Criminoso	criminoso	\N	PDF v1.1, Tabela 1.1 p. 19
289ee8bb-c711-43b9-b1a5-b93f99e648ea	1e9480ec-e177-4b33-90c7-ea576c87b9af	Cultista Arrependido	cultista-arrependido	\N	PDF v1.1, Tabela 1.1 p. 19
097d9de7-26f3-4ebe-835c-c859280e7b1f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Desgarrado	desgarrado	\N	PDF v1.1, Tabela 1.1 p. 19
883052b1-9f27-49a6-be69-3742358d44d7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Engenheiro	engenheiro	\N	PDF v1.1, Tabela 1.1 p. 19
123fbb6c-9ed5-4f38-b6a2-6f7337b2a628	1e9480ec-e177-4b33-90c7-ea576c87b9af	Executivo	executivo	\N	PDF v1.1, Tabela 1.1 p. 19
d1beb8d2-c004-45d3-a6a0-eee1be25a38c	1e9480ec-e177-4b33-90c7-ea576c87b9af	Investigador	investigador	\N	PDF v1.1, Tabela 1.1 p. 19
882b5f8b-d41f-4e40-80c1-a7ac0c53d64a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Lutador	lutador	\N	PDF v1.1, Tabela 1.1 p. 19
09e327c6-d066-411d-9e02-d7d0072a2903	1e9480ec-e177-4b33-90c7-ea576c87b9af	Magnata	magnata	\N	PDF v1.1, Tabela 1.1 p. 19
7c562c48-86ba-49f0-9642-55d10455e35e	1e9480ec-e177-4b33-90c7-ea576c87b9af	Mercenário	mercenario	\N	PDF v1.1, Tabela 1.1 p. 19
467a76cc-fb73-4598-8a19-9e77f285fc83	1e9480ec-e177-4b33-90c7-ea576c87b9af	Militar	militar	\N	PDF v1.1, Tabela 1.1 p. 19
6a28b1fb-36f8-4033-b83e-af82c577aefd	1e9480ec-e177-4b33-90c7-ea576c87b9af	Operário	operario	\N	PDF v1.1, Tabela 1.1 p. 19
6fa66243-9b26-44ac-84f9-79735b67b2ce	1e9480ec-e177-4b33-90c7-ea576c87b9af	Policial	policial	\N	PDF v1.1, Tabela 1.1 p. 19
662569e1-99fb-48b3-b8a2-ad3a915c3d98	1e9480ec-e177-4b33-90c7-ea576c87b9af	Religioso	religioso	\N	PDF v1.1, Tabela 1.1 p. 19
fc4f66fd-9ced-44be-a074-f53872b5c5c1	1e9480ec-e177-4b33-90c7-ea576c87b9af	Servidor Público	servidor-publico	\N	PDF v1.1, Tabela 1.1 p. 19
b8fe5383-2e7f-4076-bd28-d806cbef7d02	1e9480ec-e177-4b33-90c7-ea576c87b9af	Teórico da Conspiração	teorico-da-conspiracao	\N	PDF v1.1, Tabela 1.1 p. 19
448dac9f-0ea0-4f5e-ac5c-e105776cdbf8	1e9480ec-e177-4b33-90c7-ea576c87b9af	T.I.	ti	\N	PDF v1.1, Tabela 1.1 p. 19
cc315fc5-08e9-40f4-9aad-02f882e01c1b	1e9480ec-e177-4b33-90c7-ea576c87b9af	Trabalhador Rural	trabalhador-rural	\N	PDF v1.1, Tabela 1.1 p. 19
dd7234fe-f31e-4ee4-8eee-98dac48b7431	1e9480ec-e177-4b33-90c7-ea576c87b9af	Trambiqueiro	trambiqueiro	\N	PDF v1.1, Tabela 1.1 p. 19
812534d9-66e1-40cb-ab22-5c8839b3e1b5	1e9480ec-e177-4b33-90c7-ea576c87b9af	Universitário	universitario	\N	PDF v1.1, Tabela 1.1 p. 19
e806e5b5-7626-48bd-97be-ba4fafe7ff90	1e9480ec-e177-4b33-90c7-ea576c87b9af	Vítima	vitima	\N	PDF v1.1, Tabela 1.1 p. 19
\.


--
-- Data for Name: character_origin; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.character_origin (character_id, origin_id) FROM stdin;
\.


--
-- Data for Name: proficiency_definition; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.proficiency_definition (id, rpg_system_id, name, slug, proficiency_type, description, source_ref) FROM stdin;
f25cbb1a-7664-4622-9c94-d691c23113ea	1e9480ec-e177-4b33-90c7-ea576c87b9af	Armas Simples	armas-simples	WEAPON	\N	PDF v1.1, p. 54
9d007a18-9511-4b40-a3df-39ff14822640	1e9480ec-e177-4b33-90c7-ea576c87b9af	Armas Táticas	armas-taticas	WEAPON	\N	PDF v1.1, p. 54
a20e8ed2-ef0e-47e6-8dea-6ddc3c8f1569	1e9480ec-e177-4b33-90c7-ea576c87b9af	Armas Pesadas	armas-pesadas	WEAPON	\N	PDF v1.1, p. 54
00be5026-3797-441d-b03a-231579e67224	1e9480ec-e177-4b33-90c7-ea576c87b9af	Proteções Leves	protecoes-leves	PROTECTION	\N	PDF v1.1, p. 62
260af6d5-9ff2-4a7f-a0fe-612819b92b13	1e9480ec-e177-4b33-90c7-ea576c87b9af	Proteções Pesadas	protecoes-pesadas	PROTECTION	\N	PDF v1.1, p. 62
\.


--
-- Data for Name: character_proficiency; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.character_proficiency (character_id, proficiency_id, acquisition_source) FROM stdin;
\.


--
-- Data for Name: progression_definition; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.progression_definition (id, rpg_system_id, name, slug, abbreviation, value_type, min_value, max_value, description, sort_order, source_ref) FROM stdin;
612adcf4-eb1d-4523-9551-a4fe8fd32fac	1e9480ec-e177-4b33-90c7-ea576c87b9af	Nível de Exposição Paranormal	nex	NEX	PERCENTAGE	0.00	99.00	\N	1	PDF v1.1, p. 23; regra opcional NEX 0% p. 171
2f031f8c-cc80-45ad-8a0f-0b7adcf54257	1e9480ec-e177-4b33-90c7-ea576c87b9af	Pontos de Prestígio	prestigio	PP	INTEGER	0.00	\N	\N	2	PDF v1.1, Tabela 3.1 p. 52
\.


--
-- Data for Name: character_progression; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.character_progression (character_id, progression_id, value) FROM stdin;
\.


--
-- Data for Name: resistance_definition; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.resistance_definition (id, rpg_system_id, name, slug, description, source_ref) FROM stdin;
\.


--
-- Data for Name: character_resistance; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.character_resistance (character_id, resistance_id, value) FROM stdin;
\.


--
-- Data for Name: resource_definition; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.resource_definition (id, rpg_system_id, name, slug, abbreviation, description, sort_order, source_ref) FROM stdin;
d0612d9a-549b-4b1e-aa91-bd95c29bd81a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Pontos de Vida	pontos-de-vida	PV	\N	1	PDF v1.1, pp. 10 e 36
c6e790cc-e140-4e44-af64-352372b8fd70	1e9480ec-e177-4b33-90c7-ea576c87b9af	Pontos de Esforço	pontos-de-esforco	PE	\N	2	PDF v1.1, pp. 10 e 36
385eb458-015a-49ce-bd1b-aa311cf31885	1e9480ec-e177-4b33-90c7-ea576c87b9af	Sanidade	sanidade	SAN	\N	3	PDF v1.1, pp. 10 e 36
\.


--
-- Data for Name: character_resource; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.character_resource (character_id, resource_id, current_value, max_value, temporary_value) FROM stdin;
\.


--
-- Data for Name: skill_training_level; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.skill_training_level (id, rpg_system_id, name, slug, bonus, sort_order, source_ref) FROM stdin;
b25a1bca-ffc4-42e1-bdbc-7ac9dc8d72a2	1e9480ec-e177-4b33-90c7-ea576c87b9af	Leigo	leigo	0.00	1	PDF v1.1, p. 11
b0b3208c-fee3-436e-a89d-a1a25e844131	1e9480ec-e177-4b33-90c7-ea576c87b9af	Treinado	treinado	5.00	2	PDF v1.1, p. 11
a8f17e9d-4afc-4fd4-a52c-820b120db202	1e9480ec-e177-4b33-90c7-ea576c87b9af	Veterano	veterano	10.00	3	PDF v1.1, p. 11
1afa223a-254d-40cf-a140-b8728c3f371f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Expert	expert	15.00	4	PDF v1.1, p. 11
\.


--
-- Data for Name: character_skill; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.character_skill (character_id, skill_id, training_level_id, other_bonus, specialization) FROM stdin;
\.


--
-- Data for Name: stat_definition; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.stat_definition (id, rpg_system_id, name, slug, abbreviation, description, sort_order, source_ref) FROM stdin;
cc1340ff-22ec-4836-8240-2067d5320d78	1e9480ec-e177-4b33-90c7-ea576c87b9af	Defesa	defesa	DEF	\N	1	PDF v1.1, p. 36
df4fa21b-62e0-4453-b5e1-defad07fd32a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Deslocamento	deslocamento	DESL	\N	2	PDF v1.1, pp. 36 e 89
6b7d4cdd-587b-4b61-a60a-fbbbda0e007a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Limite de PE	limite-de-pe	\N	\N	3	PDF v1.1, p. 23
fcb8c55c-757c-4906-b98c-ecb137f69af7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Carga Máxima	carga-maxima	\N	\N	4	PDF v1.1, p. 53
\.


--
-- Data for Name: character_stat; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.character_stat (character_id, stat_id, base_value, equipment_bonus, other_bonus, calculated_value) FROM stdin;
\.


--
-- Data for Name: class_ability_unlock; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.class_ability_unlock (class_id, ability_id, required_progression) FROM stdin;
d2222c7e-59c7-4b37-83da-b65ab68e594b	25fca680-ca2e-438b-8287-5c86d2fdedfd	20.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	25fca680-ca2e-438b-8287-5c86d2fdedfd	50.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	25fca680-ca2e-438b-8287-5c86d2fdedfd	80.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	25fca680-ca2e-438b-8287-5c86d2fdedfd	95.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	25fca680-ca2e-438b-8287-5c86d2fdedfd	20.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	25fca680-ca2e-438b-8287-5c86d2fdedfd	50.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	25fca680-ca2e-438b-8287-5c86d2fdedfd	80.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	25fca680-ca2e-438b-8287-5c86d2fdedfd	95.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	25fca680-ca2e-438b-8287-5c86d2fdedfd	20.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	25fca680-ca2e-438b-8287-5c86d2fdedfd	50.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	25fca680-ca2e-438b-8287-5c86d2fdedfd	80.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	25fca680-ca2e-438b-8287-5c86d2fdedfd	95.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	6b8ba65b-d055-49c6-a3a0-14d4b4697bc5	35.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	6b8ba65b-d055-49c6-a3a0-14d4b4697bc5	70.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	6b8ba65b-d055-49c6-a3a0-14d4b4697bc5	35.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	6b8ba65b-d055-49c6-a3a0-14d4b4697bc5	70.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	6b8ba65b-d055-49c6-a3a0-14d4b4697bc5	35.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	6b8ba65b-d055-49c6-a3a0-14d4b4697bc5	70.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	5f7df240-6aff-40be-a0b7-9e8f547d8d43	50.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	5f7df240-6aff-40be-a0b7-9e8f547d8d43	50.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	5f7df240-6aff-40be-a0b7-9e8f547d8d43	50.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	cde3aeec-92f5-4d66-9b60-26039e172fe4	5.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	cde3aeec-92f5-4d66-9b60-26039e172fe4	25.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	cde3aeec-92f5-4d66-9b60-26039e172fe4	55.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	cde3aeec-92f5-4d66-9b60-26039e172fe4	85.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	7e8bf815-10b4-45e2-ad51-bde9af0f0e17	5.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	c43b4e9e-cd2c-48fd-8bbd-c01c2d9f0984	5.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	c43b4e9e-cd2c-48fd-8bbd-c01c2d9f0984	25.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	c43b4e9e-cd2c-48fd-8bbd-c01c2d9f0984	55.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	c43b4e9e-cd2c-48fd-8bbd-c01c2d9f0984	85.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	4fa86797-837f-4c88-91e9-e50fba7db071	40.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	4fa86797-837f-4c88-91e9-e50fba7db071	75.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	506d4184-4b4b-4f8e-baa5-5704f00917e0	5.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	506d4184-4b4b-4f8e-baa5-5704f00917e0	25.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	506d4184-4b4b-4f8e-baa5-5704f00917e0	55.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	506d4184-4b4b-4f8e-baa5-5704f00917e0	85.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	536b57d9-d6c2-452b-bf61-fdac274c8553	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	536b57d9-d6c2-452b-bf61-fdac274c8553	30.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	536b57d9-d6c2-452b-bf61-fdac274c8553	45.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	536b57d9-d6c2-452b-bf61-fdac274c8553	60.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	536b57d9-d6c2-452b-bf61-fdac274c8553	75.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	536b57d9-d6c2-452b-bf61-fdac274c8553	90.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	27658352-3ed4-46e5-be96-6d72dc72764d	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	27658352-3ed4-46e5-be96-6d72dc72764d	30.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	27658352-3ed4-46e5-be96-6d72dc72764d	45.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	27658352-3ed4-46e5-be96-6d72dc72764d	60.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	27658352-3ed4-46e5-be96-6d72dc72764d	75.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	27658352-3ed4-46e5-be96-6d72dc72764d	90.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	9b22b069-79c9-4bac-816e-ebac2d8a11b4	15.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	9b22b069-79c9-4bac-816e-ebac2d8a11b4	30.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	9b22b069-79c9-4bac-816e-ebac2d8a11b4	45.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	9b22b069-79c9-4bac-816e-ebac2d8a11b4	60.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	9b22b069-79c9-4bac-816e-ebac2d8a11b4	75.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	9b22b069-79c9-4bac-816e-ebac2d8a11b4	90.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	248d1362-407f-40e4-90f6-f7d72d64a784	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	d3891e69-21ed-4de9-b515-67fe4773e8d8	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	34319ad8-a34d-4d8d-bad6-cb73dd7c604c	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	53448770-720b-42d4-8e2e-2a050b94f69f	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	6e13b21b-503c-4afc-bc5d-7ed31d235fa7	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	078385d9-3f60-40aa-a589-9f2ef1889af8	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	2f802b57-a9d2-4c41-9f8e-8323449e9d90	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	cf6dd105-fc7a-4dcc-b2bb-672e4ede75d2	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	1e9ef0a4-5c91-467b-8041-70d3ec78e352	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	1dabfa3e-4963-49f9-993f-9fc37e4dfebf	30.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	41e57677-ddcc-41be-8264-f7848e53cd79	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	40ef6ed6-4305-496a-8739-2935550a4b03	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	ff756f75-c638-4a4b-8152-68153263e778	60.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	fc008603-423f-4600-890d-af434c10e95c	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	0f4bed27-cc75-475a-ad4f-c4f49be5b419	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	29c2da64-af07-46e7-a5e9-32629798a173	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	f0707d5d-65a8-4478-a6f9-21cec7d63f7e	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	1bbcae9a-3618-4233-866e-0db5a773377a	15.00
d2222c7e-59c7-4b37-83da-b65ab68e594b	993551b3-99bc-4d8f-a056-0bbe0a438cb0	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	d3891e69-21ed-4de9-b515-67fe4773e8d8	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	a26e29ed-5716-4372-989a-8b1bba72ef5b	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	c527e2a3-494d-46a2-8e12-51d88291c70a	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	a7d51e8d-a336-4984-bd5f-9fc91a755c47	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	0e95b9f4-48d5-4dea-80ec-677117796fd8	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	d515f6c8-b248-48bf-a4ca-6b9d7ddc55a7	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	50b8cfb4-deb1-4e0e-96f1-9846e3f8e56b	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	8a21d456-8686-462a-9538-6176cc64527c	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	cd8f1cbc-e3ad-42be-99ea-7a98169ff81f	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	97c83456-1efe-4887-b474-e8808211781c	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	7f8d1fe0-0ae3-4f13-9461-604984d2b8cc	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	61cf6e48-ed63-4f42-89c3-9e6220847e4b	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	d30af734-033b-4179-af53-89be408e5a3a	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	1bbcae9a-3618-4233-866e-0db5a773377a	15.00
c9bd6935-a5db-4cb4-b99b-0621358c1820	993551b3-99bc-4d8f-a056-0bbe0a438cb0	15.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	1f473d7c-9a20-4937-be57-3b557ffbc2f2	15.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	fe49226d-444c-4940-97ec-1fdf92c278ff	15.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	0c63466a-336b-4bcf-9725-9d86cc0721a9	15.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	b6a24c05-0460-4e06-88e3-92c217724c14	15.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	62ae19b0-c472-4cdf-9621-b52c467ec328	15.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	af00bc0c-f42e-43b8-8a2d-34000f83d59f	60.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	75a61c2b-3d6d-42fb-9e19-0d943726aeb9	15.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	3d0d954d-d202-48f8-9c45-a32bb2415575	15.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	b2be935f-94fc-4900-acbd-a0be92be64b4	15.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	17b7ca3c-7ad3-450d-a1aa-5585840f807b	15.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	ea9c05e5-4c67-45d1-88a7-fecbec78645b	45.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	a524f3a8-eb2d-456c-b302-7a5a0cc74473	15.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	a95ca663-bbcd-4a46-957e-548ced1a45e9	15.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	7d55db3c-6560-4cbf-85ba-fa3d468d4824	15.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	1bbcae9a-3618-4233-866e-0db5a773377a	15.00
97b09513-32b5-4ad9-9e13-18b6ed61be29	993551b3-99bc-4d8f-a056-0bbe0a438cb0	15.00
\.


--
-- Data for Name: class_proficiency; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.class_proficiency (class_id, proficiency_id) FROM stdin;
d2222c7e-59c7-4b37-83da-b65ab68e594b	00be5026-3797-441d-b03a-231579e67224
d2222c7e-59c7-4b37-83da-b65ab68e594b	9d007a18-9511-4b40-a3df-39ff14822640
d2222c7e-59c7-4b37-83da-b65ab68e594b	f25cbb1a-7664-4622-9c94-d691c23113ea
c9bd6935-a5db-4cb4-b99b-0621358c1820	00be5026-3797-441d-b03a-231579e67224
c9bd6935-a5db-4cb4-b99b-0621358c1820	f25cbb1a-7664-4622-9c94-d691c23113ea
97b09513-32b5-4ad9-9e13-18b6ed61be29	f25cbb1a-7664-4622-9c94-d691c23113ea
\.


--
-- Data for Name: condition_definition; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.condition_definition (id, rpg_system_id, name, slug, description, category, sort_order, source_ref, metadata) FROM stdin;
be04194f-60b1-4205-b86e-8996d77fa3b3	1e9480ec-e177-4b33-90c7-ea576c87b9af	Abalado	abalado	Sofre uma penalidade em testes; se receber a condição novamente, progride para Apavorado.	FEAR	1	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
ae3ac528-f87e-465c-9494-a1dc410da37d	1e9480ec-e177-4b33-90c7-ea576c87b9af	Agarrado	agarrado	Fica desprevenido e imóvel, sofre penalidade em ataques e só pode atacar com armas leves; ataques à distância contra envolvidos na manobra podem atingir o alvo errado.	PARALYSIS	2	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
d15a9e43-3ee0-47d9-9263-4e5edeeee8fd	1e9480ec-e177-4b33-90c7-ea576c87b9af	Alquebrado	alquebrado	O custo em PE de habilidades e rituais aumenta em 1.	MENTAL	3	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
64096f70-3d22-4354-a4fc-0199e0f9f831	1e9480ec-e177-4b33-90c7-ea576c87b9af	Apavorado	apavorado	Sofre forte penalidade em testes e deve fugir da fonte do medo da forma mais eficiente possível; se não puder fugir, não pode se aproximar voluntariamente dela.	FEAR	4	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
30487b83-5cdc-425c-a112-1f966194f731	1e9480ec-e177-4b33-90c7-ea576c87b9af	Asfixiado	asfixiado	Não pode respirar. Pode prender o fôlego por rodadas iguais ao Vigor, reduzidas quando sofre dano; ao fim da última rodada fica Morrendo.	GENERAL	5	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
1fc60f99-edf0-4096-a207-2c1920384467	1e9480ec-e177-4b33-90c7-ea576c87b9af	Atordoado	atordoado	Fica desprevenido e não pode realizar ações.	MENTAL	6	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
4f62a307-aac4-4482-bff9-ebdfd3d55bed	1e9480ec-e177-4b33-90c7-ea576c87b9af	Caído	caido	Deitado no chão; ataques corpo a corpo sofrem penalidade, deslocamento cai para 1,5m, Defesa piora contra ataques corpo a corpo e melhora contra ataques à distância.	GENERAL	7	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
daddccc7-ef49-44cd-87d5-3ef755efba80	1e9480ec-e177-4b33-90c7-ea576c87b9af	Cego	cego	Fica desprevenido e lento, não pode usar Percepção para observar e sofre penalidade em perícias baseadas em Agilidade ou Força; alvos de seus ataques recebem camuflagem total.	SENSES	8	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
52906482-edfe-4682-a7c0-3696b01fcdd6	1e9480ec-e177-4b33-90c7-ea576c87b9af	Confuso	confuso	No início de cada turno rola 1d6 para determinar comportamento aleatório; em 6 a condição termina.	MENTAL	9	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
aca3619d-90ba-48b3-b030-d185ce80f128	1e9480ec-e177-4b33-90c7-ea576c87b9af	Debilitado	debilitado	Sofre penalidade severa em testes de Agilidade, Força e Vigor. Se receber novamente, fica Inconsciente.	GENERAL	10	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
837ecb02-12dc-4c1b-913a-2595edea9e7e	1e9480ec-e177-4b33-90c7-ea576c87b9af	Desprevenido	desprevenido	Sofre -5 na Defesa e penalidade em Reflexos; também fica desprevenido contra inimigos que não consegue perceber.	GENERAL	11	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
e0207c60-9954-4583-9aba-c0678182b153	1e9480ec-e177-4b33-90c7-ea576c87b9af	Doente	doente	Está sob efeito de uma doença; seus efeitos dependem da doença específica.	GENERAL	12	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
abe5c1d6-ce53-4052-a410-a2aa16b297a7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Em Chamas	em-chamas	No início de cada turno sofre 1d6 de dano de fogo.	GENERAL	13	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
05711998-18bf-4119-8a5a-3beddd30cb62	1e9480ec-e177-4b33-90c7-ea576c87b9af	Enjoado	enjoado	Só pode realizar uma ação padrão ou uma ação de movimento por rodada, não ambas.	GENERAL	14	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
468cb901-973c-4727-b9cd-f3cfb30f0158	1e9480ec-e177-4b33-90c7-ea576c87b9af	Enredado	enredado	Fica lento e vulnerável e sofre penalidade em ataques.	PARALYSIS	15	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
6b773401-3d0c-4b06-baf4-39cdafb252d6	1e9480ec-e177-4b33-90c7-ea576c87b9af	Envenenado	envenenado	O efeito depende do veneno e pode impor outra condição ou causar dano recorrente; dano recorrente de Envenenado acumula.	GENERAL	16	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
1031c974-0897-46d9-875d-e8ee2f4b46ad	1e9480ec-e177-4b33-90c7-ea576c87b9af	Esmorecido	esmorecido	Sofre penalidade severa em testes de Intelecto e Presença.	MENTAL	17	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
729c8fb2-ce9d-48c5-86ef-c446ebe85aa8	1e9480ec-e177-4b33-90c7-ea576c87b9af	Exausto	exausto	Fica debilitado, lento e vulnerável. Se receber novamente, fica Inconsciente.	FATIGUE	18	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
0f1256c1-0b1e-4c58-bf99-a94d96f78ebe	1e9480ec-e177-4b33-90c7-ea576c87b9af	Fascinado	fascinado	Sofre penalidade em Percepção e não pode fazer ações além de observar aquilo que o fascinou.	MENTAL	19	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
4c12b325-c0a1-4de7-838c-b2bb95620506	1e9480ec-e177-4b33-90c7-ea576c87b9af	Fatigado	fatigado	Fica fraco e vulnerável. Se receber novamente, fica Exausto.	FATIGUE	20	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
e7b56e52-e6ec-4640-956f-95ad80a3cd42	1e9480ec-e177-4b33-90c7-ea576c87b9af	Fraco	fraco	Sofre penalidade em testes de Agilidade, Força e Vigor. Se receber novamente, fica Debilitado.	GENERAL	21	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
c637bce6-fd8a-4aa9-806f-abf6f59172f5	1e9480ec-e177-4b33-90c7-ea576c87b9af	Frustrado	frustrado	Sofre penalidade em testes de Intelecto e Presença. Se receber novamente, fica Esmorecido.	MENTAL	22	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
96dd0958-c381-4e38-b62e-e774a8dbc4d8	1e9480ec-e177-4b33-90c7-ea576c87b9af	Imóvel	imovel	Todas as formas de deslocamento são reduzidas a 0m.	PARALYSIS	23	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
af248f43-8e98-4872-86c9-61bc85bdff58	1e9480ec-e177-4b33-90c7-ea576c87b9af	Inconsciente	inconsciente	Fica indefeso e não pode fazer ações, inclusive reações.	GENERAL	24	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
e1b7dfee-1cf5-4a03-8d15-2ee988818b0f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Indefeso	indefeso	É considerado desprevenido, sofre -10 na Defesa, falha automaticamente em Reflexos e pode sofrer golpe de misericórdia.	GENERAL	25	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
a658cb99-66dd-4434-a2bd-e2f58aafbd43	1e9480ec-e177-4b33-90c7-ea576c87b9af	Lento	lento	Todas as formas de deslocamento são reduzidas à metade e não pode correr nem fazer investidas.	PARALYSIS	26	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
f93fea15-9b8b-4fe8-bd24-a4aa90f2ed5d	1e9480ec-e177-4b33-90c7-ea576c87b9af	Machucado	machucado	Está com menos da metade de seus PV totais.	GENERAL	27	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
9120e461-a698-4d13-932b-fe876baa600a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Morrendo	morrendo	Está com 0 PV, fica inconsciente e morre se terminar mais de três rodadas morrendo na mesma cena.	GENERAL	28	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
3a1672a8-4d33-44ff-ad68-562a87eec145	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ofuscado	ofuscado	Sofre penalidade em ataques e em Percepção.	SENSES	29	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
41f69422-7922-43ba-bd9b-a296b01cfaf4	1e9480ec-e177-4b33-90c7-ea576c87b9af	Paralisado	paralisado	Fica imóvel e indefeso e só pode realizar ações puramente mentais.	PARALYSIS	30	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
c1e5740e-1767-4a63-9b2f-7921fc4b550f	1e9480ec-e177-4b33-90c7-ea576c87b9af	Pasmo	pasmo	Não pode realizar ações.	MENTAL	31	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
0cbe97bf-e1e9-42e9-80fa-16bc27fca258	1e9480ec-e177-4b33-90c7-ea576c87b9af	Petrificado	petrificado	Fica inconsciente e recebe resistência a dano 10.	GENERAL	32	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
04c48909-505a-4363-a617-62232bdf9942	1e9480ec-e177-4b33-90c7-ea576c87b9af	Sangrando	sangrando	No início do turno faz teste de Vigor DT 20; em sucesso remove a condição, em falha perde 1d6 PV e continua sangrando.	GENERAL	33	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
896bd68a-75cf-40ca-81a4-92094c66b42a	1e9480ec-e177-4b33-90c7-ea576c87b9af	Surdo	surdo	Não pode usar Percepção para ouvir, sofre penalidade em Iniciativa e conta como condição ruim para conjurar rituais.	SENSES	34	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
02119314-84e7-496d-9bcf-5368cb8321b9	1e9480ec-e177-4b33-90c7-ea576c87b9af	Surpreendido	surpreendido	Fica desprevenido e não pode realizar ações.	GENERAL	35	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
4fb34607-8122-44e6-8e6f-5f68bf584574	1e9480ec-e177-4b33-90c7-ea576c87b9af	Vulnerável	vulneravel	Sofre -5 na Defesa.	GENERAL	36	PDF v1.1, Apêndice Condições pp. 310-312	{"official_appendix": true}
\.


--
-- Data for Name: downtime_action_definition; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.downtime_action_definition (id, rpg_system_id, name, slug, description, sort_order, source_ref, metadata) FROM stdin;
279a3e3c-9026-4610-9841-1467dcac8793	1e9480ec-e177-4b33-90c7-ea576c87b9af	Alimentar-se	alimentar-se	Faz uma refeição especial e escolhe um prato com benefício específico.	1	PDF v1.1, pp. 92-93	{"interlude": true}
4f2be75b-b9ea-424d-8db3-dc9465532604	1e9480ec-e177-4b33-90c7-ea576c87b9af	Dormir	dormir	Descansa por um período curto e recupera PV e PE conforme o Limite de PE e a condição de descanso.	2	PDF v1.1, p. 93	{"interlude": true}
3919b9a3-0075-42c3-98b0-e57056336eef	1e9480ec-e177-4b33-90c7-ea576c87b9af	Exercitar-se	exercitar-se	Treina fisicamente e prepara um bônus para um teste futuro baseado em atributo físico.	3	PDF v1.1, p. 93	{"interlude": true}
024571d1-7b08-4805-8b1c-475da2ab38ee	1e9480ec-e177-4b33-90c7-ea576c87b9af	Ler	ler	Lê material relevante e prepara um bônus para um teste futuro baseado em Intelecto ou Presença.	4	PDF v1.1, p. 93	{"interlude": true}
ab4e511d-fe4c-4d9c-bf9e-dc254ed334d3	1e9480ec-e177-4b33-90c7-ea576c87b9af	Manutenção	manutencao	Conserta um item quebrado.	5	PDF v1.1, p. 93	{"interlude": true}
31704f70-e4e6-4a69-8058-790a503e27b7	1e9480ec-e177-4b33-90c7-ea576c87b9af	Relaxar	relaxar	Realiza uma atividade agradável para recuperar a mente.	6	PDF v1.1, p. 93	{"interlude": true}
c3be56fd-7d54-404d-9f1b-0713e3de22f9	1e9480ec-e177-4b33-90c7-ea576c87b9af	Revisar Caso	revisar-caso	Revisa anotações e pistas de uma cena de investigação anterior.	7	PDF v1.1, p. 93	{"interlude": true}
\.


--
-- Data for Name: origin_ability; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.origin_ability (origin_id, ability_id) FROM stdin;
2e972664-8ec6-4cd2-9fa7-c74cf278d7fd	f3406bcb-a076-468b-b71d-87c6d0115341
0a1ef649-4dbe-4e61-adf2-8863a5a425ba	38e2bde8-bff5-4877-8a79-8e8d82cfa135
8bcbd258-0259-457a-8eb5-6314e3412491	3dabaad2-9797-4b61-a70b-27ddacc7ad18
d4c64c0d-b88b-42dc-9abb-f2110a6158b7	983f038b-4dc8-4704-89f9-815d749c9091
1479018f-d88e-4baa-9d24-1e8e7f416bc4	40daaf01-7167-426b-88e3-eba4440a8256
92b069e1-c8c2-41b4-8abf-bec0dd3dffc3	45355c3d-ff10-43bb-98d4-0d2550dce67a
17dd0e12-e007-40fc-a0db-85b78c081ce1	d1377e89-8fed-4b12-886e-a55af68ffda5
289ee8bb-c711-43b9-b1a5-b93f99e648ea	a8634eac-8bea-4fb1-b7c3-b24d2a2606ed
097d9de7-26f3-4ebe-835c-c859280e7b1f	c589144f-52c7-4f73-906b-85d7eef5bfc7
883052b1-9f27-49a6-be69-3742358d44d7	e1e57af4-abe3-45b3-b9f9-405b9af86dc6
123fbb6c-9ed5-4f38-b6a2-6f7337b2a628	f90f509b-647c-4b00-9fd3-8214a545f7af
d1beb8d2-c004-45d3-a6a0-eee1be25a38c	85f1cbaa-fee6-4719-be4f-fc400c62c8e1
882b5f8b-d41f-4e40-80c1-a7ac0c53d64a	2f3cbca0-0eca-4f9a-9e55-dd99d2faf581
09e327c6-d066-411d-9e02-d7d0072a2903	4363bcda-5a40-4b90-bd30-aebf42850c1e
7c562c48-86ba-49f0-9642-55d10455e35e	96358824-0bff-48c7-a44d-07e6ae463321
467a76cc-fb73-4598-8a19-9e77f285fc83	65366714-abd8-4f13-bc5d-9843b3bf3424
6a28b1fb-36f8-4033-b83e-af82c577aefd	6d1f587d-1e79-43b0-aaba-e16f656933d3
6fa66243-9b26-44ac-84f9-79735b67b2ce	d966e2e1-aefb-466e-9a7b-f62171f384e4
662569e1-99fb-48b3-b8a2-ad3a915c3d98	24ee1228-bee7-4e03-8158-4ef084fc461f
fc4f66fd-9ced-44be-a074-f53872b5c5c1	f6f4a2de-181d-47b0-ab35-ce50e4f1a221
b8fe5383-2e7f-4076-bd28-d806cbef7d02	ae2af962-b8fd-41f3-a648-9b9e2df10219
448dac9f-0ea0-4f5e-ac5c-e105776cdbf8	d6f0c5ac-8446-4728-ad20-1cf98ccc5a14
cc315fc5-08e9-40f4-9aad-02f882e01c1b	e0135c35-806b-4094-b925-739d6cbef57a
dd7234fe-f31e-4ee4-8eee-98dac48b7431	fac91b0b-2650-4bad-9be8-b50412da0b01
812534d9-66e1-40cb-ab22-5c8839b3e1b5	8e4b5186-79a3-4d0e-a600-c844bb430be5
e806e5b5-7626-48bd-97be-ba4fafe7ff90	38cfecc0-6a87-4f1b-a547-2f5d561480f9
\.


--
-- Data for Name: progression_tier; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.progression_tier (id, progression_id, name, slug, required_value, rule_data, sort_order, source_ref) FROM stdin;
515cead2-0713-4156-b42f-427cc8f44ee3	612adcf4-eb1d-4523-9551-a4fe8fd32fac	5% NEX	nex-5	5.00	{"pe_limit": 1}	1	PDF v1.1, Tabela 1.2 p. 23
2e8cf6ed-3e5a-4138-b995-0d4392d831e0	612adcf4-eb1d-4523-9551-a4fe8fd32fac	10% NEX	nex-10	10.00	{"pe_limit": 2}	2	PDF v1.1, Tabela 1.2 p. 23
1ca4d44a-e7d9-462c-b929-609d4e4ef8cc	612adcf4-eb1d-4523-9551-a4fe8fd32fac	15% NEX	nex-15	15.00	{"pe_limit": 3}	3	PDF v1.1, Tabela 1.2 p. 23
e10ca0ab-e9cc-4256-ab0d-11f9ff8ada6e	612adcf4-eb1d-4523-9551-a4fe8fd32fac	20% NEX	nex-20	20.00	{"pe_limit": 4}	4	PDF v1.1, Tabela 1.2 p. 23
996b8db7-c061-4695-81cd-589e31d6cf35	612adcf4-eb1d-4523-9551-a4fe8fd32fac	25% NEX	nex-25	25.00	{"pe_limit": 5}	5	PDF v1.1, Tabela 1.2 p. 23
6d22bb17-aad7-4e25-8f4c-09103928096f	612adcf4-eb1d-4523-9551-a4fe8fd32fac	30% NEX	nex-30	30.00	{"pe_limit": 6}	6	PDF v1.1, Tabela 1.2 p. 23
8fd7f328-a9d3-4083-af5c-86837d5f8a3c	612adcf4-eb1d-4523-9551-a4fe8fd32fac	35% NEX	nex-35	35.00	{"pe_limit": 7}	7	PDF v1.1, Tabela 1.2 p. 23
742acf15-5e7c-407b-9721-663ed63ca106	612adcf4-eb1d-4523-9551-a4fe8fd32fac	40% NEX	nex-40	40.00	{"pe_limit": 8}	8	PDF v1.1, Tabela 1.2 p. 23
d2d0cc85-7205-4480-b389-28749b5910bc	612adcf4-eb1d-4523-9551-a4fe8fd32fac	45% NEX	nex-45	45.00	{"pe_limit": 9}	9	PDF v1.1, Tabela 1.2 p. 23
f68e937f-0895-49c4-a0af-6bfaf3f2e7db	612adcf4-eb1d-4523-9551-a4fe8fd32fac	50% NEX	nex-50	50.00	{"pe_limit": 10}	10	PDF v1.1, Tabela 1.2 p. 23
634108de-7f7b-402b-b460-7c4a29753cea	612adcf4-eb1d-4523-9551-a4fe8fd32fac	55% NEX	nex-55	55.00	{"pe_limit": 11}	11	PDF v1.1, Tabela 1.2 p. 23
4cfa1de2-8f01-4230-bf9c-983b1c98a39c	612adcf4-eb1d-4523-9551-a4fe8fd32fac	60% NEX	nex-60	60.00	{"pe_limit": 12}	12	PDF v1.1, Tabela 1.2 p. 23
719bef0d-d6e7-4feb-bd93-1074e0f5b0f4	612adcf4-eb1d-4523-9551-a4fe8fd32fac	65% NEX	nex-65	65.00	{"pe_limit": 13}	13	PDF v1.1, Tabela 1.2 p. 23
f91cc010-4e7f-420d-8543-c07c41c0b537	612adcf4-eb1d-4523-9551-a4fe8fd32fac	70% NEX	nex-70	70.00	{"pe_limit": 14}	14	PDF v1.1, Tabela 1.2 p. 23
4d8d86f2-ce60-44dc-89d0-b061cc1488c2	612adcf4-eb1d-4523-9551-a4fe8fd32fac	75% NEX	nex-75	75.00	{"pe_limit": 15}	15	PDF v1.1, Tabela 1.2 p. 23
724e661b-488a-430d-be47-8ce6695fefac	612adcf4-eb1d-4523-9551-a4fe8fd32fac	80% NEX	nex-80	80.00	{"pe_limit": 16}	16	PDF v1.1, Tabela 1.2 p. 23
80c33ef3-7f52-4f61-8df7-9237c415a4d0	612adcf4-eb1d-4523-9551-a4fe8fd32fac	85% NEX	nex-85	85.00	{"pe_limit": 17}	17	PDF v1.1, Tabela 1.2 p. 23
eae596f1-1efa-45cd-83d3-3d501b63b46f	612adcf4-eb1d-4523-9551-a4fe8fd32fac	90% NEX	nex-90	90.00	{"pe_limit": 18}	18	PDF v1.1, Tabela 1.2 p. 23
d65c9fac-7aad-494b-9a6a-c4f57fad9b76	612adcf4-eb1d-4523-9551-a4fe8fd32fac	95% NEX	nex-95	95.00	{"pe_limit": 19}	19	PDF v1.1, Tabela 1.2 p. 23
812008f6-102d-426f-a14c-5e3168ebecb5	612adcf4-eb1d-4523-9551-a4fe8fd32fac	99% NEX	nex-99	99.00	{"pe_limit": 20}	20	PDF v1.1, Tabela 1.2 p. 23
b46b1e06-21f8-4ae7-a95a-1dc064e73132	2f031f8c-cc80-45ad-8a0f-0b7adcf54257	Recruta	recruta	0.00	{}	1	PDF v1.1, Tabela 3.1 p. 52
43f99edf-fd95-46bf-8921-04c14eec8064	2f031f8c-cc80-45ad-8a0f-0b7adcf54257	Operador	operador	20.00	{}	2	PDF v1.1, Tabela 3.1 p. 52
10659be7-48ca-4776-98a1-dbf2eb19f740	2f031f8c-cc80-45ad-8a0f-0b7adcf54257	Agente Especial	agente-especial	50.00	{}	3	PDF v1.1, Tabela 3.1 p. 52
c16a3c99-3114-4525-8126-3d1880373c40	2f031f8c-cc80-45ad-8a0f-0b7adcf54257	Oficial de Operações	oficial-de-operacoes	100.00	{}	4	PDF v1.1, Tabela 3.1 p. 52
87c7f84e-91dc-4a32-8f7e-46208b74b10d	2f031f8c-cc80-45ad-8a0f-0b7adcf54257	Agente de Elite	agente-de-elite	200.00	{}	5	PDF v1.1, Tabela 3.1 p. 52
\.


--
-- Data for Name: ammunition; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.ammunition (item_id, duration_text, source_ref) FROM stdin;
53b4555b-e446-4335-adc9-a445ba083659	2 cenas	PDF v1.1, p. 59
cc792318-e26e-4841-93e5-4b6707f802de	1 cena	PDF v1.1, p. 59
395bf90d-d51c-44a3-a37d-8e895dd73104	1 cena	PDF v1.1, p. 59
f4635410-9f0b-4784-a02f-cb7810059f9b	1 cena	PDF v1.1, p. 59
31b0f633-04b1-488d-ad4f-b71aa4ce66ec	1 missão	PDF v1.1, p. 59
79671d81-d320-4c86-aa57-f15a74f64164	1 disparo	PDF v1.1, p. 59
\.


--
-- Data for Name: being_type; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.being_type (id, name, slug, description, source_ref) FROM stdin;
ccbfe321-1a7c-4fa1-b1f4-685a5ebaccb7	Pessoa	pessoa	\N	PDF v1.1, p. 10
97efe17b-1bb7-4446-97b8-897819f17e98	Animal	animal	\N	PDF v1.1, p. 10
67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	Criatura	criatura	\N	PDF v1.1, p. 10
6e50b6e6-58fc-4807-b48f-7c1cb2f10b47	Relíquia	reliquia	Categoria usada para as manifestações conhecidas como Relíquias.	PDF v1.1, bestiário / Relíquias
\.


--
-- Data for Name: character_detail; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.character_detail (character_id, credit_limit) FROM stdin;
\.


--
-- Data for Name: class_rule; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.class_rule (class_id, initial_pv_base, initial_pv_attribute, pv_per_nex_base, pv_per_nex_attribute, initial_pe_base, initial_pe_attribute, pe_per_nex_base, pe_per_nex_attribute, initial_san, san_per_nex, trained_skills_rule, source_ref) FROM stdin;
d2222c7e-59c7-4b37-83da-b65ab68e594b	20	VIG	4	VIG	2	PRE	2	PRE	12	3	Luta ou Pontaria; Fortitude ou Reflexos; + (1 + Intelecto) perícias à escolha	PDF v1.1, p. 25
c9bd6935-a5db-4cb4-b99b-0621358c1820	16	VIG	3	VIG	3	PRE	3	PRE	16	4	7 + Intelecto perícias à escolha	PDF v1.1, p. 29
97b09513-32b5-4ad9-9e13-18b6ed61be29	12	VIG	2	VIG	4	PRE	4	PRE	20	5	Ocultismo e Vontade; + (3 + Intelecto) perícias à escolha	PDF v1.1, p. 33
\.


--
-- Data for Name: combat_action_rule; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.combat_action_rule (action_id, required_skill_id, requires_training, attack_dice_modifier, attack_flat_modifier, defense_modifier, movement_multiplier, minimum_movement_m, requires_melee_attack, requires_ranged_attack, requires_visible_target, rule_data, source_ref) FROM stdin;
98dc256c-4200-4d4d-a31b-8ba39ca9d24a	\N	f	\N	\N	\N	\N	\N	f	f	f	{"kind": "attack"}	PDF v1.1, Cap. 4 pp. 85-86
8bc10168-21ba-4109-96f2-dc26376b843a	64cf1a15-4bbf-4086-80a8-bdab541beb54	f	\N	\N	\N	\N	\N	f	f	f	{"minimum_initiative_expression": "0 - bonus_iniciativa"}	PDF v1.1, pp. 87-88
b10939df-271d-4104-b413-20158761f3e4	8cf55386-5621-415f-9ca3-c1dfc4e81348	f	\N	\N	\N	\N	\N	f	f	f	{"during_movement": true, "free_during_charge": true}	PDF v1.1, p. 86
95065d6a-40bf-4ade-b54b-fad9b115aa9c	\N	f	\N	\N	\N	\N	\N	f	f	f	{"ritual_execution": "padrao"}	PDF v1.1, p. 86
c49532ef-7733-4829-a53d-82328d01a3f4	\N	f	\N	\N	\N	\N	\N	f	f	f	{"ritual_execution": "maior_que_acao_completa"}	PDF v1.1, p. 87
5e8a7ebc-b396-4cbf-b5cc-725bd8116ac3	6c2d9b01-f885-4d52-90e6-53d307409f12	f	\N	\N	\N	\N	\N	f	f	f	{"uses_skill_rule": true}	PDF v1.1, p. 87
ec257081-8091-4a7c-b7ea-4ba4c8ce61e7	\N	f	\N	\N	\N	\N	\N	f	f	f	{"default_word_limit": 20}	PDF v1.1, p. 88
2323ea93-56d7-4095-9a19-2701483b4243	83b28425-380e-4b8c-b244-c8c9cfe3e0d7	f	\N	\N	\N	\N	\N	f	f	t	{"range": "curto", "opposed_skill": "reflexos", "result_condition": "desprevenido"}	PDF v1.1, p. 86
78abf8ae-30f1-4160-b57e-b568dab5e695	\N	f	\N	\N	\N	\N	\N	t	f	f	{"automatic_critical": true, "instant_death_chance_secondary_npc": 75, "instant_death_chance_pc_or_important_npc": 25}	PDF v1.1, p. 87
b9585436-3516-42d7-be1c-fc587294256e	\N	f	1	\N	-5	2.00	3.00	t	f	f	{"straight_line": true, "can_free_overrun": true, "forbidden_in_difficult_terrain": true, "cannot_overrun_and_attack_same_target": true}	PDF v1.1, p. 87
73701f1c-f7fe-4c9b-88ae-9f9be8119728	\N	f	\N	\N	\N	\N	\N	f	f	f	{"result_condition": "caido"}	PDF v1.1, p. 88
9a990249-04cd-4316-a4cf-94b3f9f0c53a	\N	f	\N	\N	\N	\N	\N	f	f	f	{}	PDF v1.1, p. 88
411a418c-22a7-4649-96ee-616fe5ed60c4	\N	f	\N	\N	\N	\N	\N	f	f	f	{}	PDF v1.1, p. 87
b9d5beee-0967-4f2c-a8f6-4eaf6589de29	\N	f	\N	\N	\N	\N	\N	f	f	f	{}	PDF v1.1, p. 87
6a3995e5-a1ed-40f3-8f69-faec01b6a3b0	30b4680b-1aea-481e-a428-c47a99263cf4	t	\N	\N	\N	\N	\N	f	t	t	{"removes_engaged_target_penalty": -5}	PDF v1.1, p. 87
7f903f41-60d3-424c-a4ec-c77cbdc38f18	\N	f	\N	\N	\N	1.00	\N	f	f	f	{}	PDF v1.1, p. 87
7ef346d8-4598-4956-a5dc-a70ccdfabd80	\N	f	\N	\N	\N	\N	\N	f	f	f	{"prepared_action_becomes": "REACTION"}	PDF v1.1, p. 86
0113a6f8-8459-47c2-af02-5b7584719440	\N	f	\N	\N	\N	\N	\N	f	f	f	{}	PDF v1.1, p. 87
86409c6e-da18-4c42-8755-e3c29bd5cce5	\N	f	\N	\N	\N	\N	\N	f	f	f	{}	PDF v1.1, p. 86
\.


--
-- Data for Name: combat_maneuver; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.combat_maneuver (id, name, slug, base_skill_id, opposed_skill_id, action_id, effect_condition_id, movement_on_success_m, extra_effect_per_margin, size_rule, description, rule_data, source_ref) FROM stdin;
082f5d1c-2a7f-4629-ba59-f51a7becf7c0	Agarrar	agarrar	8cf55386-5621-415f-9ca3-c1dfc4e81348	8cf55386-5621-415f-9ca3-c1dfc4e81348	98dc256c-4200-4d4d-a31b-8ba39ca9d24a	ae3ac528-f87e-465c-9494-a1dc410da37d	\N	\N	Teste de manobra segue os modificadores de tamanho do sistema.	Usa ataque desarmado para agarrar. Enquanto mantém a manobra, ocupa uma mão e move-se com metade do deslocamento ao arrastar o alvo.	{"requires_unarmed_attack": true, "grabber_movement_multiplier": 0.5, "ranged_wrong_target_chance_percent": 50}	PDF v1.1, pp. 85-86
e9e8731e-a43d-43dd-b202-9a2894dd4b62	Derrubar	derrubar	8cf55386-5621-415f-9ca3-c1dfc4e81348	8cf55386-5621-415f-9ca3-c1dfc4e81348	98dc256c-4200-4d4d-a31b-8ba39ca9d24a	4f62a307-aac4-4482-bff9-ebdfd3d55bed	1.50	5	Teste de manobra segue os modificadores de tamanho do sistema.	Deixa o alvo caído. Se vencer o teste oposto por 5 ou mais, também empurra o alvo 1,5m em direção escolhida.	{"ledge_reflex_dt": 20}	PDF v1.1, pp. 85-86
f3a4a642-5343-443c-afbd-2c78ce7f8442	Desarmar	desarmar	8cf55386-5621-415f-9ca3-c1dfc4e81348	8cf55386-5621-415f-9ca3-c1dfc4e81348	98dc256c-4200-4d4d-a31b-8ba39ca9d24a	\N	1.50	5	Teste de manobra segue os modificadores de tamanho do sistema.	Derruba um item que o alvo esteja segurando. Se vencer por 5 ou mais, também desloca o item 1,5m em direção escolhida.	{}	PDF v1.1, pp. 85-86
2dc18fae-f6f7-4585-ab74-4f5617764d5f	Empurrar	empurrar	8cf55386-5621-415f-9ca3-c1dfc4e81348	8cf55386-5621-415f-9ca3-c1dfc4e81348	98dc256c-4200-4d4d-a31b-8ba39ca9d24a	\N	1.50	5	Teste de manobra segue os modificadores de tamanho do sistema.	Empurra o alvo 1,5m, mais 1,5m para cada 5 pontos de diferença entre os testes. Pode gastar ação de movimento para acompanhar o alvo.	{"extra_distance_m_per_margin": 1.5, "may_follow_with_movement_action": true}	PDF v1.1, pp. 85-86
f2840809-8783-4273-96f0-11eac2e5e3b6	Quebrar	quebrar	8cf55386-5621-415f-9ca3-c1dfc4e81348	8cf55386-5621-415f-9ca3-c1dfc4e81348	98dc256c-4200-4d4d-a31b-8ba39ca9d24a	\N	\N	\N	Teste de manobra segue os modificadores de tamanho do sistema.	Atinge um item que o alvo esteja segurando, usando as regras de quebrar objetos.	{"targets_held_object": true}	PDF v1.1, pp. 85-86
61d1e6d6-e763-44d2-ac0a-978cd2371400	Atropelar	atropelar-manobra	8cf55386-5621-415f-9ca3-c1dfc4e81348	8cf55386-5621-415f-9ca3-c1dfc4e81348	b10939df-271d-4104-b413-20158761f3e4	4f62a307-aac4-4482-bff9-ebdfd3d55bed	\N	\N	Teste de manobra segue os modificadores de tamanho do sistema.	Usada para atravessar o espaço ocupado por um ser durante movimento; se ele resistir, faz-se teste de manobra oposto.	{"during_movement": true, "free_during_charge": true}	PDF v1.1, p. 86
\.


--
-- Data for Name: combat_situation_modifier; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.combat_situation_modifier (id, name, slug, applies_to, attack_dice_modifier, defense_modifier, failure_chance_percent, prevents_attack, melee_only, ranged_only, description, rule_data, source_ref) FROM stdin;
fc44ca65-073e-44ec-a44f-9177014561de	Atacante Caído	atacante-caido	ATTACKER	-2	\N	\N	f	f	f	Atacante caído sofre -2 dados no ataque.	{}	PDF v1.1, Tabela 4.4 p. 89
4315dd1b-5ba7-4083-ba26-ebaf1194e77e	Atacante Cego	atacante-cego	ATTACKER	\N	\N	50	f	f	f	Atacante cego tem 50% de chance de falha.	{}	PDF v1.1, Tabela 4.4 p. 89
207d4757-d362-4cf7-849b-7927f95484f7	Posição Elevada	posicao-elevada	ATTACKER	1	\N	\N	f	f	f	Atacante em posição elevada recebe +1 dado no ataque.	{}	PDF v1.1, Tabela 4.4 p. 89
28ae5a0c-5a4b-442d-bdbb-2fb9a875b850	Flanqueando	flanqueando	ATTACKER	1	\N	\N	f	t	f	Ao flanquear o alvo, recebe +1 dado em ataque corpo a corpo.	{}	PDF v1.1, Tabela 4.4 p. 89
77ed7005-edcf-44e4-af39-f5254e03e58e	Invisível	invisivel-atacante	ATTACKER	2	\N	\N	f	f	f	Atacante invisível recebe +2 dados, exceto contra alvos cegos.	{"not_against_blind_target": true}	PDF v1.1, Tabela 4.4 p. 89
8ae61706-c20e-4655-aeae-d88c9b424305	Ofuscado	ofuscado-atacante	ATTACKER	-1	\N	\N	f	f	f	Atacante ofuscado sofre -1 dado no ataque.	{}	PDF v1.1, Tabela 4.4 p. 89
486935c1-8797-4df2-939a-ade481ae9f78	Alvo Caído — Corpo a Corpo	alvo-caido-corpo-a-corpo	TARGET	\N	-5	\N	f	t	f	Alvo caído sofre -5 Defesa contra ataques corpo a corpo.	{}	PDF v1.1, Tabela 4.4 p. 89
c80f6e41-4ac6-4ebb-9ef2-37eea6889edb	Alvo Caído — Distância	alvo-caido-distancia	TARGET	\N	5	\N	f	f	t	Alvo caído recebe +5 Defesa contra ataques à distância.	{}	PDF v1.1, Tabela 4.4 p. 89
75b855ab-ca2d-4180-995f-d88d33e40089	Alvo Cego	alvo-cego	TARGET	\N	-5	\N	f	f	f	Alvo cego sofre -5 Defesa.	{}	PDF v1.1, Tabela 4.4 p. 89
cccad0e9-1995-4e36-9012-35bd33db6fb0	Alvo Desprevenido	alvo-desprevenido	TARGET	\N	-5	\N	f	f	f	Alvo desprevenido sofre -5 Defesa.	{}	PDF v1.1, Tabela 4.4 p. 89
2e55c093-65af-45a7-bc47-f86d785275f0	Camuflagem	camuflagem	TARGET	\N	\N	20	f	f	f	Ataques contra alvo sob camuflagem têm 20% de chance de falha.	{"d10_fail_results": [1, 2]}	PDF v1.1, p. 89
ee035b71-7cb5-4e1e-9699-fe80fbb580c0	Camuflagem Total	camuflagem-total	TARGET	\N	\N	50	f	f	f	Ataques contra alvo sob camuflagem total têm 50% de chance de falha.	{"d10_fail_results": [1, 2, 3, 4, 5]}	PDF v1.1, p. 89
77e3921d-a2c4-481d-924d-a554c8e1b1e0	Cobertura	cobertura	TARGET	\N	5	\N	f	f	f	Cobertura fornece +5 Defesa.	{}	PDF v1.1, p. 89
2372cee7-c960-4a98-a204-7a01ad58bc04	Cobertura Total	cobertura-total	TARGET	\N	\N	\N	t	f	f	Alvo sob cobertura total não pode ser atacado diretamente.	{}	PDF v1.1, Tabela 4.4 p. 89
\.


--
-- Data for Name: combat_turn_rule; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.combat_turn_rule (id, standard_actions, movement_actions, can_standard_be_movement, can_movement_be_standard, full_replaces_standard, full_replaces_movement, free_actions_unbounded, reactions_unbounded, round_duration_seconds, source_ref) FROM stdin;
1	1	1	t	f	t	t	t	t	6	PDF v1.1, p. 84
\.


--
-- Data for Name: condition_relation; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.condition_relation (condition_id, related_condition_id, relation_type, source_ref) FROM stdin;
be04194f-60b1-4205-b86e-8996d77fa3b3	64096f70-3d22-4354-a4fc-0199e0f9f831	REAPPLY_BECOMES	PDF v1.1, Apêndice Condições pp. 310-312
ae3ac528-f87e-465c-9494-a1dc410da37d	837ecb02-12dc-4c1b-913a-2595edea9e7e	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
ae3ac528-f87e-465c-9494-a1dc410da37d	96dd0958-c381-4e38-b62e-e774a8dbc4d8	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
1fc60f99-edf0-4096-a207-2c1920384467	837ecb02-12dc-4c1b-913a-2595edea9e7e	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
daddccc7-ef49-44cd-87d5-3ef755efba80	837ecb02-12dc-4c1b-913a-2595edea9e7e	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
daddccc7-ef49-44cd-87d5-3ef755efba80	a658cb99-66dd-4434-a2bd-e2f58aafbd43	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
aca3619d-90ba-48b3-b030-d185ce80f128	af248f43-8e98-4872-86c9-61bc85bdff58	REAPPLY_BECOMES	PDF v1.1, Apêndice Condições pp. 310-312
468cb901-973c-4727-b9cd-f3cfb30f0158	a658cb99-66dd-4434-a2bd-e2f58aafbd43	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
468cb901-973c-4727-b9cd-f3cfb30f0158	4fb34607-8122-44e6-8e6f-5f68bf584574	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
729c8fb2-ce9d-48c5-86ef-c446ebe85aa8	aca3619d-90ba-48b3-b030-d185ce80f128	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
729c8fb2-ce9d-48c5-86ef-c446ebe85aa8	a658cb99-66dd-4434-a2bd-e2f58aafbd43	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
729c8fb2-ce9d-48c5-86ef-c446ebe85aa8	4fb34607-8122-44e6-8e6f-5f68bf584574	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
729c8fb2-ce9d-48c5-86ef-c446ebe85aa8	af248f43-8e98-4872-86c9-61bc85bdff58	REAPPLY_BECOMES	PDF v1.1, Apêndice Condições pp. 310-312
4c12b325-c0a1-4de7-838c-b2bb95620506	e7b56e52-e6ec-4640-956f-95ad80a3cd42	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
4c12b325-c0a1-4de7-838c-b2bb95620506	4fb34607-8122-44e6-8e6f-5f68bf584574	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
4c12b325-c0a1-4de7-838c-b2bb95620506	729c8fb2-ce9d-48c5-86ef-c446ebe85aa8	REAPPLY_BECOMES	PDF v1.1, Apêndice Condições pp. 310-312
e7b56e52-e6ec-4640-956f-95ad80a3cd42	aca3619d-90ba-48b3-b030-d185ce80f128	REAPPLY_BECOMES	PDF v1.1, Apêndice Condições pp. 310-312
c637bce6-fd8a-4aa9-806f-abf6f59172f5	1031c974-0897-46d9-875d-e8ee2f4b46ad	REAPPLY_BECOMES	PDF v1.1, Apêndice Condições pp. 310-312
af248f43-8e98-4872-86c9-61bc85bdff58	e1b7dfee-1cf5-4a03-8d15-2ee988818b0f	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
e1b7dfee-1cf5-4a03-8d15-2ee988818b0f	837ecb02-12dc-4c1b-913a-2595edea9e7e	COUNTS_AS	PDF v1.1, Apêndice Condições pp. 310-312
9120e461-a698-4d13-932b-fe876baa600a	af248f43-8e98-4872-86c9-61bc85bdff58	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
41f69422-7922-43ba-bd9b-a296b01cfaf4	96dd0958-c381-4e38-b62e-e774a8dbc4d8	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
41f69422-7922-43ba-bd9b-a296b01cfaf4	e1b7dfee-1cf5-4a03-8d15-2ee988818b0f	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
0cbe97bf-e1e9-42e9-80fa-16bc27fca258	af248f43-8e98-4872-86c9-61bc85bdff58	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
02119314-84e7-496d-9bcf-5368cb8321b9	837ecb02-12dc-4c1b-913a-2595edea9e7e	IMPOSES	PDF v1.1, Apêndice Condições pp. 310-312
\.


--
-- Data for Name: condition_rule; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.condition_rule (condition_id, movement_effect, defense_effect, action_effect, attack_effect, skill_effect, recovery_text, default_end, stacks, source_ref, rule_data) FROM stdin;
be04194f-60b1-4205-b86e-8996d77fa3b3	\N	\N	\N	\N	-1 dado em testes	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
ae3ac528-f87e-465c-9494-a1dc410da37d	Deslocamento 0m por impor Imóvel	Impõe Desprevenido	\N	Penalidade de 1 dado; só pode atacar com armas leves	\N	Pode tentar se soltar conforme a manobra Agarrar.	SOURCE_DEFINED	f	PDF v1.1, Apêndice Condições pp. 310-312	{"ranged_attack_wrong_target_chance_percent": 50}
d15a9e43-3ee0-47d9-9263-4e5edeeee8fd	\N	\N	\N	\N	\N	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{"pe_cost_increase": 1}
64096f70-3d22-4354-a4fc-0199e0f9f831	Deve fugir da fonte do medo quando possível	\N	\N	\N	-2 dados em testes de perícia	Pode parar de fugir ao perder a fonte de vista ou ficar além de alcance médio dela.	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
30487b83-5cdc-425c-a112-1f966194f731	\N	\N	\N	\N	\N	Termina quando volta a respirar.	SPECIAL	f	PDF v1.1, Apêndice Condições pp. 310-312	{"breath_rounds": "VIG", "on_last_round": "MORRENDO", "damage_reduces_remaining_rounds": 1}
1fc60f99-edf0-4096-a207-2c1920384467	\N	Impõe Desprevenido	Não pode fazer ações	\N	\N	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
4f62a307-aac4-4482-bff9-ebdfd3d55bed	Deslocamento 1,5m	-5 contra corpo a corpo; +5 contra ataques à distância	\N	-2 dados em ataques corpo a corpo	\N	Levantar-se remove a condição conforme as regras de movimento.	SOURCE_DEFINED	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
daddccc7-ef49-44cd-87d5-3ef755efba80	Impõe Lento	Impõe Desprevenido	\N	\N	Não pode fazer Percepção para observar; -2 dados em perícias baseadas em Agilidade ou Força	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{"targets_have_total_concealment": true}
52906482-edfe-4682-a7c0-3696b01fcdd6	Pode mover em direção aleatória conforme 1d6	\N	Ações determinadas por 1d6; alguns resultados impedem ações	\N	\N	Resultado 6 na rolagem de 1d6 encerra a condição.	SPECIAL	f	PDF v1.1, Apêndice Condições pp. 310-312	{"ends_on": 6, "turn_roll": "1d6"}
aca3619d-90ba-48b3-b030-d185ce80f128	\N	\N	\N	\N	-2 dados em testes de Agilidade, Força e Vigor	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
837ecb02-12dc-4c1b-913a-2595edea9e7e	\N	-5 Defesa	\N	\N	-1 dado em Reflexos	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
e0207c60-9954-4583-9aba-c0678182b153	\N	\N	\N	\N	\N	Termina conforme a regra da doença que a causou.	SOURCE_DEFINED	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
abe5c1d6-ce53-4052-a410-a2aa16b297a7	\N	\N	Pode gastar ação padrão para apagar o fogo	\N	\N	Uma ação padrão para apagar com as mãos ou imersão em água remove a condição.	SPECIAL	f	PDF v1.1, Apêndice Condições pp. 310-312	{"damage_type": "fogo", "start_turn_damage": "1d6"}
05711998-18bf-4119-8a5a-3beddd30cb62	\N	\N	Apenas uma ação padrão ou uma ação de movimento por rodada	\N	\N	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
468cb901-973c-4727-b9cd-f3cfb30f0158	Impõe Lento	Impõe Vulnerável	\N	-1 dado em ataques	\N	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
6b773401-3d0c-4b06-baf4-39cdafb252d6	\N	\N	\N	\N	\N	A duração é definida pelo veneno; se não houver duração indicada, dura pela cena.	SOURCE_DEFINED	t	PDF v1.1, Apêndice Condições pp. 310-312	{"recurrent_damage_stacks": true}
1031c974-0897-46d9-875d-e8ee2f4b46ad	\N	\N	\N	\N	-2 dados em testes de Intelecto e Presença	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
729c8fb2-ce9d-48c5-86ef-c446ebe85aa8	Impõe Lento	Impõe Vulnerável	\N	\N	Impõe Debilitado	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
0f1256c1-0b1e-4c58-bf99-a94d96f78ebe	\N	\N	Só pode observar aquilo que o fascinou	\N	-2 dados em Percepção	Qualquer ação hostil contra o personagem encerra a condição.	SPECIAL	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
4c12b325-c0a1-4de7-838c-b2bb95620506	\N	Impõe Vulnerável	\N	\N	Impõe Fraco	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
e7b56e52-e6ec-4640-956f-95ad80a3cd42	\N	\N	\N	\N	-1 dado em testes de Agilidade, Força e Vigor	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
c637bce6-fd8a-4aa9-806f-abf6f59172f5	\N	\N	\N	\N	-1 dado em testes de Intelecto e Presença	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
96dd0958-c381-4e38-b62e-e774a8dbc4d8	Todas as formas de deslocamento = 0m	\N	\N	\N	\N	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
af248f43-8e98-4872-86c9-61bc85bdff58	\N	Impõe Indefeso	Não pode fazer ações ou reações	\N	\N	Uma ação padrão pode ser usada para balançar um ser e acordá-lo, quando aplicável.	SOURCE_DEFINED	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
e1b7dfee-1cf5-4a03-8d15-2ee988818b0f	\N	-10 Defesa; conta como Desprevenido	\N	\N	Falha automaticamente em Reflexos	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{"allows_coup_de_grace": true}
a658cb99-66dd-4434-a2bd-e2f58aafbd43	Deslocamento pela metade; não pode correr ou investir	\N	\N	\N	\N	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
f93fea15-9b8b-4fe8-bd24-a4aa90f2ed5d	\N	\N	\N	\N	\N	Termina ao voltar a ter pelo menos metade dos PV totais.	SPECIAL	f	PDF v1.1, Apêndice Condições pp. 310-312	{"threshold": "current_hp < max_hp/2"}
9120e461-a698-4d13-932b-fe876baa600a	\N	Impõe Inconsciente	\N	\N	\N	Termina ao voltar a ter pelo menos 1 PV.	SPECIAL	f	PDF v1.1, Apêndice Condições pp. 310-312	{"hp_equals": 0, "death_after_rounds": 3, "rounds_need_not_be_consecutive": true}
3a1672a8-4d33-44ff-ad68-562a87eec145	\N	\N	\N	-1 dado em ataques	-1 dado em Percepção	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
41f69422-7922-43ba-bd9b-a296b01cfaf4	Impõe Imóvel	Impõe Indefeso	Só pode realizar ações puramente mentais	\N	\N	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
c1e5740e-1767-4a63-9b2f-7921fc4b550f	\N	\N	Não pode fazer ações	\N	\N	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
0cbe97bf-e1e9-42e9-80fa-16bc27fca258	\N	Impõe Inconsciente; resistência a dano 10	\N	\N	\N	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{"damage_resistance": 10}
04c48909-505a-4363-a617-62232bdf9942	\N	\N	\N	\N	\N	Teste de Vigor DT 20 no início do turno; sucesso remove a condição.	SPECIAL	f	PDF v1.1, Apêndice Condições pp. 310-312	{"dt": 20, "failure_hp_loss": "1d6", "start_turn_test": "Vigor"}
896bd68a-75cf-40ca-81a4-92094c66b42a	\N	\N	\N	\N	Não pode fazer Percepção para ouvir; -2 dados em Iniciativa	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{"ritual_casting_condition": "ruim"}
02119314-84e7-496d-9bcf-5368cb8321b9	\N	Impõe Desprevenido	Não pode fazer ações	\N	\N	\N	SOURCE_DEFINED	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
4fb34607-8122-44e6-8e6f-5f68bf584574	\N	-5 Defesa	\N	\N	\N	\N	END_OF_SCENE	f	PDF v1.1, Apêndice Condições pp. 310-312	{}
\.


--
-- Data for Name: element; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.element (id, name, slug, description, source_ref) FROM stdin;
9290710c-ae4d-486c-8d69-2afb4db4c030	Sangue	sangue	\N	PDF v1.1, Cap. 5
bca15d0f-87ca-4375-aaef-b639c7295552	Morte	morte	\N	PDF v1.1, Cap. 5
d855bb6c-9321-48db-8e24-05e58697a31d	Conhecimento	conhecimento	\N	PDF v1.1, Cap. 5
52779391-a501-4a9e-b780-684349da1c1c	Energia	energia	\N	PDF v1.1, Cap. 5
76759131-d2e3-4de1-964f-7c865e4dc5f9	Medo	medo	\N	PDF v1.1, Cap. 5
\.


--
-- Data for Name: curse_definition; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.curse_definition (id, element_id, name, slug, applies_to, variable_element, effect_summary, source_ref) FROM stdin;
a69732f0-eab9-4b37-a6eb-72f9f43295a0	9290710c-ae4d-486c-8d69-2afb4db4c030	Sanguinária	arma-sanguinaria	WEAPON	f	Um ser atingido fica sangrando e o sangramento causado pela arma é cumulativo. Em acerto crítico, o alvo fica fraco e o usuário recebe 2d10 PV temporários.	PDF v1.1, p. 147
434530df-3421-4a9b-8b48-654cbc8a6af1	9290710c-ae4d-486c-8d69-2afb4db4c030	Predadora	arma-predadora	WEAPON	f	Anula penalidades por camuflagem e cobertura, exceto cobertura total. Em ataques à distância aumenta o alcance em uma categoria e duplica a margem de ameaça.	PDF v1.1, p. 147
4a524a41-c32f-4f7c-8fe9-2438c3508cdc	9290710c-ae4d-486c-8d69-2afb4db4c030	Lancinante	arma-lancinante	WEAPON	f	Causa +1d8 de dano de Sangue. Esse dado adicional é multiplicado em acertos críticos.	PDF v1.1, p. 147
6a52e99a-c910-4e86-abb4-259a291e848f	bca15d0f-87ca-4375-aaef-b639c7295552	Repulsora	arma-repulsora	WEAPON	f	Enquanto empunhada concede +2 de Defesa. Ao realizar um bloqueio, pode gastar 2 PE para receber +5 adicional em Defesa.	PDF v1.1, pp. 146-147
336f17b0-8cfa-4d62-b34d-a86a4562d24c	bca15d0f-87ca-4375-aaef-b639c7295552	Erosiva	arma-erosiva	WEAPON	f	Causa +1d8 de dano de Morte. Ao atacar, pode gastar 2 PE; se acertar, o alvo sofre 2d4 de dano de Morte no início de seus turnos pelas duas rodadas seguintes.	PDF v1.1, p. 146
548695e1-cb46-4a1e-b019-90476c574f9c	bca15d0f-87ca-4375-aaef-b639c7295552	Consumidora	arma-consumidora	WEAPON	f	Alvos atingidos ficam lentos até o final da cena. Ao atacar, pode gastar 2 PE; se acertar, o alvo também fica imóvel por uma rodada.	PDF v1.1, p. 146
3369cd1c-34e1-49b7-b871-9f489dd1d533	d855bb6c-9321-48db-8e24-05e58697a31d	Senciente	arma-senciente	WEAPON	f	Com ação de movimento e 2 PE, a arma passa a flutuar e pode atacar uma vez por rodada em alcance curto ou no próprio alcance, o que for maior. Manter o efeito exige 1 PE no início de cada turno.	PDF v1.1, p. 146
5779e089-7ee6-4a59-9d3a-40d7893d8513	d855bb6c-9321-48db-8e24-05e58697a31d	Ritualística	arma-ritualistica	WEAPON	f	Permite armazenar na arma um ritual que tenha um ser como alvo ou afete uma área, pagando o custo normalmente. Ao acertar um ataque, o ritual armazenado pode ser descarregado como ação livre sobre o ser atingido ou centrado nele.	PDF v1.1, p. 146
0b3cd237-2c8f-4623-a4ec-d1cee5616aef	d855bb6c-9321-48db-8e24-05e58697a31d	Antielemento	arma-antielemento	WEAPON	f	Escolhe um elemento. Contra criatura desse elemento, pode gastar 2 PE antes do ataque; se acertar, causa +4d8 de dano. A escolha aleatória usa 1d4 entre Conhecimento, Energia, Morte e Sangue.	PDF v1.1, p. 146
5ac3657a-8a3d-4a71-8423-d60d17ea4641	52779391-a501-4a9e-b780-684349da1c1c	Vibrante	arma-vibrante	WEAPON	f	Concede a habilidade Ataque Extra da trilha Operações Especiais. Se o usuário já possui essa habilidade, o custo para usá-la diminui em 1 PE.	PDF v1.1, p. 146
c81e4b8b-24ad-40e7-86d7-6fa83ed355ba	52779391-a501-4a9e-b780-684349da1c1c	Energética	arma-energetica	WEAPON	f	Pode gastar 2 PE por ataque para converter arma ou munição em Energia pura. Nesse ataque recebe +5 no teste de ataque, ignora resistência a dano e converte todo o dano causado para Energia.	PDF v1.1, p. 146
3c098549-68eb-47bc-87e3-3d03ad340a13	52779391-a501-4a9e-b780-684349da1c1c	Empuxo	arma-empuxo	WEAPON	f	Somente arma corpo a corpo. Pode ser arremessada em alcance curto; se já era arremessável, aumenta o alcance em uma categoria. Quando arremessada, causa um dado adicional de dano do mesmo tipo e retorna no mesmo turno.	PDF v1.1, p. 146
80279c47-c13b-417d-94a7-cef4413a2ddc	9290710c-ae4d-486c-8d69-2afb4db4c030	Sádica	protecao-sadica	PROTECTION	f	No início do turno, concede +1 em testes de ataque e rolagens de dano para cada 10 pontos de dano sofridos desde o fim do turno anterior.	PDF v1.1, p. 147
9b51fd75-06cc-48f8-a245-95eb70338101	9290710c-ae4d-486c-8d69-2afb4db4c030	Regenerativa	protecao-regenerativa	PROTECTION	f	Concede resistência 10 a Sangue e permite gastar ação de movimento e 1 PE para recuperar 1d12 PV.	PDF v1.1, p. 147
38419a70-549e-4795-9e3c-03672e7a51e5	bca15d0f-87ca-4375-aaef-b639c7295552	Repulsiva	protecao-repulsiva	PROTECTION	f	Concede resistência 10 a Morte. Com ação de movimento e 2 PE, até o fim da cena ataques corpo a corpo contra o usuário fazem o atacante sofrer 2d8 de dano de Morte.	PDF v1.1, p. 147
dff5e58f-3030-4d38-b514-99ad20352dd9	bca15d0f-87ca-4375-aaef-b639c7295552	Letárgica	protecao-letargica	PROTECTION	f	Concede +2 de Defesa e chance de ignorar dano adicional de crítico e ataque furtivo: 25% para proteção leve ou escudo e 50% para proteção pesada.	PDF v1.1, p. 147
b7df4b14-a8e8-40c1-85a9-7cde9f1dc8a5	d855bb6c-9321-48db-8e24-05e58697a31d	Sombria	protecao-sombria	PROTECTION	f	Concede +5 em Furtividade e ignora a penalidade de carga nessa perícia. Com ação de movimento e 1 PE pode assumir aparência de roupa comum mantendo suas propriedades.	PDF v1.1, p. 147
f56f1b08-5796-4644-8185-d2b92dfc6bc1	d855bb6c-9321-48db-8e24-05e58697a31d	Profética	protecao-profetica	PROTECTION	f	Concede resistência 10 a Conhecimento e permite gastar 2 PE para repetir uma vez um teste de resistência.	PDF v1.1, p. 147
80358807-8a59-40c9-b4cd-1c05abe3f2bc	d855bb6c-9321-48db-8e24-05e58697a31d	Abascanta	protecao-abascanta	PROTECTION	f	Concede +5 em testes de resistência contra rituais. Uma vez por cena, quando alvo de ritual, permite gastar reação e PE igual ao custo para refletir o ritual ao conjurador.	PDF v1.1, p. 147
d1bfeac9-b820-4663-932e-5d5b40b72a94	52779391-a501-4a9e-b780-684349da1c1c	Voltaica	protecao-voltaica	PROTECTION	f	Concede resistência 10 a Energia. Com ação de movimento e 2 PE, pode emitir arcos até o fim da cena, causando 2d6 de dano de Energia aos seres adjacentes no fim de cada turno.	PDF v1.1, p. 147
d5ed58d1-1306-46d9-afbe-0d40e9fa5b76	52779391-a501-4a9e-b780-684349da1c1c	Lépida	protecao-lepida	PROTECTION	f	Concede +10 em Atletismo e +3m de deslocamento. Pode gastar 2 PE para ignorar terreno difícil, receber deslocamento de escalada igual ao terrestre e ignorar dano de queda de até 9m até o fim do turno.	PDF v1.1, p. 147
29430da8-b355-4d28-bd01-14db3a9e41ee	52779391-a501-4a9e-b780-684349da1c1c	Cinética	protecao-cinetica	PROTECTION	f	Concede +2 de Defesa e resistência a dano 2 para proteção leve ou escudo, ou resistência a dano 5 para proteção pesada.	PDF v1.1, p. 147
2f2f8b55-b9c2-47e1-8c5d-54e55479a2bf	9290710c-ae4d-486c-8d69-2afb4db4c030	Vitalidade	acessorio-vitalidade	ACCESSORY	f	Concede +15 PV. O efeito só se torna ativo após um dia de uso.	PDF v1.1, p. 148
3e2de6b7-d42c-4b81-b8f5-0f9d43632608	9290710c-ae4d-486c-8d69-2afb4db4c030	Pujança	acessorio-pujanca	ACCESSORY	f	Concede +1 em Força.	PDF v1.1, p. 148
5531a148-90e8-4a13-838e-40a92b0b8bcd	9290710c-ae4d-486c-8d69-2afb4db4c030	Disposição	acessorio-disposicao	ACCESSORY	f	Concede +1 em Vigor.	PDF v1.1, p. 148
f75984e4-da6b-4d01-991a-276a79494111	bca15d0f-87ca-4375-aaef-b639c7295552	Esforço Adicional	acessorio-esforco-adicional	ACCESSORY	f	Concede +5 PE. O efeito só se torna ativo após um dia de uso.	PDF v1.1, p. 148
89dd400d-f99e-495a-9c3f-ffba17dcc3dd	d855bb6c-9321-48db-8e24-05e58697a31d	Sagacidade	acessorio-sagacidade	ACCESSORY	f	Concede +1 em Intelecto. Esse aumento não fornece perícias treinadas.	PDF v1.1, p. 148
b8a4d1b2-f4f9-42bf-aaa7-5032ce0da2c6	d855bb6c-9321-48db-8e24-05e58697a31d	Reflexão	acessorio-reflexao	ACCESSORY	f	Uma vez por rodada, quando alvo de ritual, permite gastar PE igual ao custo do ritual para refleti-lo ao conjurador, mantendo suas características.	PDF v1.1, p. 148
b8967886-1c68-40a2-8c6d-0d0ff2529772	d855bb6c-9321-48db-8e24-05e58697a31d	Escudo Mental	acessorio-escudo-mental	ACCESSORY	f	Concede resistência mental 10.	PDF v1.1, p. 148
f10b001c-d226-41dd-9b64-612fb88b0c83	d855bb6c-9321-48db-8e24-05e58697a31d	Conjuração	acessorio-conjuracao	ACCESSORY	f	O acessório contém um ritual de 1º círculo. Enquanto empunhado, permite conjurá-lo como se fosse conhecido; se o usuário já conhece o ritual, o custo é reduzido em 1 PE.	PDF v1.1, p. 148
c090fad5-2384-43d5-87a2-327442920bca	d855bb6c-9321-48db-8e24-05e58697a31d	Carisma	acessorio-carisma	ACCESSORY	f	Concede +1 em Presença. Esse aumento não fornece PE adicionais.	PDF v1.1, pp. 147-148
0c2004f0-ad41-4e7c-8cac-99b4146fa634	52779391-a501-4a9e-b780-684349da1c1c	Potência	acessorio-potencia	ACCESSORY	f	Aumenta em +1 a DT contra magias e habilidades do usuário.	PDF v1.1, p. 148
64594a1f-9991-4c89-a152-80bc3a16921d	52779391-a501-4a9e-b780-684349da1c1c	Destreza	acessorio-destreza	ACCESSORY	f	Concede +1 em Agilidade.	PDF v1.1, p. 148
55f2167e-3099-4f8d-9ec7-c55ada008693	52779391-a501-4a9e-b780-684349da1c1c	Defesa	acessorio-defesa	ACCESSORY	f	Concede +5 de Defesa.	PDF v1.1, p. 148
ecc7becd-5140-43a0-a0af-bb5e3898dd28	\N	Proteção Elemental	acessorio-protecao-elemental	ACCESSORY	t	Escolhe um elemento. Concede resistência 10 contra esse elemento e o acessório passa a contar como item desse elemento para efeitos relacionados.	PDF v1.1, p. 148
\.


--
-- Data for Name: curse_price_rule; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.curse_price_rule (element_id, trigger_attribute_slugs, sanity_loss_per_curse, custom_price, rule_summary, source_ref) FROM stdin;
9290710c-ae4d-486c-8d69-2afb4db4c030	{FOR,VIG}	2	f	Ao falhar em teste baseado em Força ou Vigor, perde 2 SAN por maldição de Sangue aceita.	PDF v1.1, p. 145
bca15d0f-87ca-4375-aaef-b639c7295552	{PRE}	2	f	Ao falhar em teste baseado em Presença, perde 2 SAN por maldição de Morte aceita.	PDF v1.1, p. 145
d855bb6c-9321-48db-8e24-05e58697a31d	{INT}	2	f	Ao falhar em teste baseado em Intelecto, perde 2 SAN por maldição de Conhecimento aceita.	PDF v1.1, p. 145
52779391-a501-4a9e-b780-684349da1c1c	{AGI}	2	f	Ao falhar em teste baseado em Agilidade, perde 2 SAN por maldição de Energia aceita.	PDF v1.1, p. 145
76759131-d2e3-4de1-964f-7c865e4dc5f9	{}	\N	t	Itens de Medo possuem um preço específico definido pelo mestre, que pode variar entre portadores.	PDF v1.1, p. 145
\.


--
-- Data for Name: cursed_item_rule; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.cursed_item_rule (id, first_curse_category_increase, subsequent_curse_category_increase, hp_bonus_per_curse, rd_bonus_per_curse, resistance_test_bonus_per_curse, minimum_patent_slug, same_curse_stacks, cursed_item_bonuses_stack, rule_summary, source_ref) FROM stdin;
1	2	1	10	10	10	agente-especial	f	f	A primeira maldição aumenta a categoria do item em II e cada maldição posterior em I. Maldições iguais não se acumulam. Itens amaldiçoados são liberados a partir da patente Agente Especial. Mantêm o espaço do item mundano equivalente. Para cada maldição, o objeto recebe +10 PV, +10 RD e +10 em seus próprios testes de resistência. Bônus fornecidos por itens amaldiçoados não se acumulam entre si.	PDF v1.1, Itens Amaldiçoados pp. 144-146
\.


--
-- Data for Name: defensive_reaction_rule; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.defensive_reaction_rule (id, name, slug, required_skill_id, trigger_text, effect_text, once_per_round_group, rule_data, source_ref) FROM stdin;
42230376-0692-48d2-b4a2-29c71cf7a746	Bloqueio	bloqueio	07fc0547-5b68-4f71-8cdd-06dde575b4d2	Quando é alvo de ataque corpo a corpo.	Usa reação antes do teste de ataque e recebe RD igual ao bônus de Fortitude contra esse ataque.	special-defense	{"effect": "RD_EQUAL_SKILL_BONUS", "melee_only": true}	PDF v1.1, p. 88
42d4d1c1-0adf-47b4-95d4-a3734659f6e3	Contra-ataque	contra-ataque	8cf55386-5621-415f-9ca3-c1dfc4e81348	Quando é alvo de ataque corpo a corpo e o atacante erra.	Usa reação para realizar um ataque contra o atacante.	special-defense	{"effect": "COUNTER_ATTACK", "melee_only": true, "trigger_requires_miss": true}	PDF v1.1, p. 88
f478d2f9-3030-49aa-b0ad-993a3c3f9eb6	Esquiva	esquiva	8372aaee-85ba-4abc-bbca-6b0625883bbc	Quando é alvo de um ataque.	Usa reação antes do teste de ataque e adiciona o bônus de Reflexos à Defesa contra esse ataque.	special-defense	{"effect": "ADD_SKILL_BONUS_TO_DEFENSE"}	PDF v1.1, p. 88
\.


--
-- Data for Name: interlude_action_rule; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.interlude_action_rule (action_id, max_uses_per_interlude, repeatable, base_resource, recovery_basis, test_bonus_expression, bonus_attribute_limit, effect_summary, rule_data, source_ref) FROM stdin;
279a3e3c-9026-4610-9841-1467dcac8793	1	f	\N	NONE	\N	\N	Escolhe uma opção de prato; um personagem só pode se beneficiar de uma refeição por interlúdio.	{"requires_available_meal": true}	PDF v1.1, pp. 92-93
4f2be75b-b9ea-424d-8db3-dc9465532604	1	f	\N	PE_LIMIT	\N	\N	Recupera PV e PE com base no Limite de PE multiplicado pela condição de descanso.	{"resources": ["PV", "PE"], "uses_rest_condition": true}	PDF v1.1, p. 93
3919b9a3-0075-42c3-98b0-e57056336eef	\N	t	\N	NONE	+1d6	VIG	Recebe +1d6 para um teste baseado em Agilidade, Força ou Vigor até o fim da missão; acumula até Vigor, usando apenas um bônus por teste.	{"expires": "END_OF_MISSION", "one_bonus_per_test": true, "eligible_attributes": ["AGI", "FOR", "VIG"]}	PDF v1.1, p. 93
024571d1-7b08-4805-8b1c-475da2ab38ee	\N	t	\N	NONE	+1d6	INT	Recebe +1d6 para um teste baseado em Intelecto ou Presença até o fim da missão; acumula até Intelecto, usando apenas um bônus por teste.	{"expires": "END_OF_MISSION", "one_bonus_per_test": true, "eligible_attributes": ["INT", "PRE"]}	PDF v1.1, p. 93
ab4e511d-fe4c-4d9c-bf9e-dc254ed334d3	\N	t	\N	FULL_ITEM_HP	\N	\N	Recupera os PV de um item quebrado até o máximo.	{}	PDF v1.1, p. 93
31704f70-e4e6-4a69-8058-790a503e27b7	1	f	SAN	REST_LIKE_SLEEP	\N	\N	Funciona como Dormir, mas recupera SAN em vez de PV e PE. Cada participante que também relaxa concede +1 SAN a todos os participantes.	{"uses_rest_condition": true, "group_bonus_san_per_participant": 1}	PDF v1.1, p. 93
c3be56fd-7d54-404d-9f1b-0713e3de22f9	\N	t	\N	NONE	\N	\N	Escolhe uma cena de investigação e uma perícia apropriada; em sucesso recebe uma pista complementar perdida. Pode repetir no mesmo interlúdio.	{"dt_from": "INVESTIGATION_ACTION", "repeatable_same_interlude": true}	PDF v1.1, p. 93
\.


--
-- Data for Name: interlude_meal_option; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.interlude_meal_option (id, name, slug, related_action_slug, effect_summary, rule_data, source_ref) FROM stdin;
4b78a0c8-16b6-43a6-a094-8a7cdffe0aa6	Prato Favorito	prato-favorito	relaxar	Se realizar Relaxar no mesmo interlúdio, recupera +2 SAN.	{"san_bonus": 2, "san_bonus_if_action": "relaxar"}	PDF v1.1, p. 93
c12fc8ad-26ba-40cf-a36a-73e44111bf9f	Prato Nutritivo	prato-nutritivo	dormir	Se realizar Dormir no mesmo interlúdio, aumenta a recuperação de PV em uma vez.	{"pv_recovery_multiplier_bonus": 1}	PDF v1.1, p. 93
24be9456-c681-4da6-95e8-c96cfd9ff8a6	Prato Energético	prato-energetico	dormir	Se realizar Dormir no mesmo interlúdio, aumenta a recuperação de PE em uma vez.	{"pe_recovery_multiplier_bonus": 1}	PDF v1.1, p. 93
468d980d-3485-4c6a-b0ef-e1440bd247f8	Prato Rápido	prato-rapido	revisar-caso	Se realizar Revisar Caso no mesmo interlúdio, recebe +5 no teste de perícia.	{"test_bonus": 5, "test_bonus_if_action": "revisar-caso"}	PDF v1.1, p. 93
\.


--
-- Data for Name: interlude_rule; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.interlude_rule (id, max_actions_per_character, fixed_duration, requires_safe_place, description, rule_data, source_ref) FROM stdin;
1	2	f	t	Cada personagem pode realizar até duas ações em um interlúdio. O mestre define quando a cena começa e termina; não há duração fixa em horas.	{"outdoor_without_camp": false, "master_controls_availability": true, "forced_interludes_may_increase_urgency": true}	PDF v1.1, p. 92
\.


--
-- Data for Name: item_modification; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.item_modification (id, name, slug, applies_to, category_increase, effect_summary, source_ref) FROM stdin;
3f01fe3b-edef-4b65-8303-9ce404abd2c9	Certeira	certeira	MELEE_PROJECTILE	1	+2 em testes de ataque.	PDF v1.1, Tabela 3.5 p. 61
32c57ed4-c217-4cda-8e9d-54d5a8fd3a5b	Cruel	cruel	MELEE_PROJECTILE	1	+2 em rolagens de dano.	PDF v1.1, Tabela 3.5 p. 61
2611b3cd-7242-4baa-9b47-437145829978	Discreta	discreta-arma	MELEE_PROJECTILE	1	Melhora ocultação e reduz espaço conforme o tipo de arma.	PDF v1.1, pp. 60-61
b7d446ea-e663-4d66-a6d8-a28018b2d52f	Perigosa	perigosa	MELEE_PROJECTILE	1	+2 em margem de ameaça.	PDF v1.1, Tabela 3.5 p. 61
d0517182-6676-4a84-9bb2-a7b50d83aeeb	Tática	tatica-arma	MELEE_PROJECTILE	1	Permite sacar como ação livre.	PDF v1.1, Tabela 3.5 p. 61
eb8ffa61-5020-4e4a-9f67-075d1a6018fe	Alongada	alongada	FIREARM	1	+2 em testes de ataque.	PDF v1.1, Tabela 3.5 p. 61
d808c28b-856f-43ed-9f5e-3ff8373a1640	Calibre Grosso	calibre-grosso	FIREARM	1	Aumenta o dano em um dado do mesmo tipo.	PDF v1.1, Tabela 3.5 p. 61
9c2f8f6f-8911-477c-8aef-1af28cf1471f	Compensador	compensador	FIREARM	1	Anula a penalidade por rajadas.	PDF v1.1, Tabela 3.5 p. 61
9fa23dcb-8d37-4236-99a1-135dc9ff954c	Discreta	discreta-arma-de-fogo	FIREARM	1	+5 em ocultar e espaço -1.	PDF v1.1, Tabela 3.5 p. 61
b9e7030b-4447-4b81-ba4a-77b3933cf348	Ferrolho Automático	ferrolho-automatico	FIREARM	1	A arma se torna automática.	PDF v1.1, Tabela 3.5 p. 61
95bef2cc-3913-4b77-b236-feb647e29fbd	Mira Laser	mira-laser	FIREARM	1	+2 em margem de ameaça.	PDF v1.1, Tabela 3.5 p. 61
dedb5df2-d203-4f2b-99fc-2b186d527d71	Mira Telescópica	mira-telescopica	FIREARM	1	Aumenta alcance da arma e da habilidade Ataque Furtivo.	PDF v1.1, Tabela 3.5 p. 61
cf1fe731-fd09-4d5c-85df-d6c7a24185ce	Silenciador	silenciador	FIREARM	1	Reduz em 10 a penalidade de Furtividade para se esconder após atacar.	PDF v1.1, Tabela 3.5 p. 61
3b14766b-b7fc-4b99-b35c-4778a5441ace	Tática	tatica-arma-de-fogo	FIREARM	1	Permite sacar como ação livre.	PDF v1.1, Tabela 3.5 p. 61
141a4901-6c29-4b81-9dfb-bee177db1d42	Visão de Calor	visao-de-calor	FIREARM	1	Ignora camuflagem.	PDF v1.1, Tabela 3.5 p. 61
23042727-8c3a-4e56-8391-d643008180e1	Dum dum	dum-dum	AMMUNITION	1	+1 no multiplicador de crítico.	PDF v1.1, Tabela 3.5 p. 61
66b39591-1f2b-4116-87bd-8796e8789ffd	Explosiva	explosiva	AMMUNITION	1	Aumenta o dano em +2d6.	PDF v1.1, Tabela 3.5 p. 61
831bf5e3-7c54-4090-a166-a7e2e0669484	Antibombas	antibombas	PROTECTION	1	+5 em testes de resistência contra efeitos de área.	PDF v1.1, Tabela 3.7 p. 62
331c1956-caaf-4e3f-9fc4-ac89800132fe	Blindada	blindada	PROTECTION	1	Aumenta RD para 5 e espaço em +1.	PDF v1.1, Tabela 3.7 p. 62
01cc13e1-380d-4abc-becc-bb3eea85b75f	Discreta	discreta-protecao	PROTECTION	1	+5 em ocultar e espaço -1.	PDF v1.1, Tabela 3.7 p. 62
5fc7ce6f-9286-4967-bcb1-02e00dd5d2ab	Reforçada	reforcada	PROTECTION	1	Defesa +2 e espaço +1.	PDF v1.1, Tabela 3.7 p. 62
2a64bef2-859e-4166-9637-48d36bac0fd9	Aprimorado	aprimorado	ACCESSORY	1	Aumenta um dos bônus em perícia para +5.	PDF v1.1, Tabela 3.9 p. 64
2136275f-b8e9-4527-b21d-66383ddc60d2	Discreto	discreto-acessorio	ACCESSORY	1	+5 em ocultar e espaço -1.	PDF v1.1, Tabela 3.9 p. 64
1e1f830c-3993-4375-a83e-63f693a8809b	Função Adicional	funcao-adicional	ACCESSORY	1	Concede +2 a uma perícia adicional.	PDF v1.1, Tabela 3.9 p. 64
6011080b-5d57-4ddf-988e-9be1f0d5702a	Instrumental	instrumental	ACCESSORY	1	O acessório funciona como um kit de perícia.	PDF v1.1, Tabela 3.9 p. 64
\.


--
-- Data for Name: item_rule; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.item_rule (item_id, inventory_category, spaces, special_spaces_rule, source_ref) FROM stdin;
383fbb9e-ceab-4128-9d0b-58ecc7601e0f	2	1	\N	PDF v1.1, Tabela 3.10 e descrição pp. 66-67
4ee205f3-50f8-4813-bd30-e124e3f0bf65	2	1	\N	PDF v1.1, Tabela 3.10 e descrição p. 66
98ff934b-b8b3-4912-93c9-9386aa228fd4	0	1	\N	PDF v1.1, Tabela 3.10 e descrição p. 66
a5fb822f-ef91-486c-9689-b9f085402952	2	1	\N	PDF v1.1, Tabela 3.10 e descrição p. 67
10ba4b7f-205d-4f52-aec3-8defbf196f54	2	1	\N	PDF v1.1, Tabela 3.10 e descrição p. 67
fbb63902-52f5-4d86-acec-0cd1762f4f40	\N	\N	A versão 1.1 descreve este item, mas o omite da Tabela 3.10; categoria e espaços não são inferidos neste seed.	PDF v1.1, descrição pp. 66-67; ausente da Tabela 3.10 v1.1
c49ef9fa-f7ef-455b-9e03-ef0479f70a97	2	1	\N	PDF v1.1, Tabela 3.10 e descrição p. 67
0e06beed-b3b9-4499-ade6-f4fb86e4cd7a	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 150
cf52e92a-2833-4477-bbb0-e20e3e07b1d2	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 150
58650147-9f8e-4b18-ac8e-b0cf7c70efbf	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 150
ff0e93b4-db09-4124-803e-21f4562385ef	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 150
53b4555b-e446-4335-adc9-a445ba083659	0	1	\N	PDF v1.1, Tabela 3.4 p. 59
cc792318-e26e-4841-93e5-4b6707f802de	1	1	\N	PDF v1.1, Tabela 3.4 p. 59
395bf90d-d51c-44a3-a37d-8e895dd73104	1	1	\N	PDF v1.1, Tabela 3.4 p. 59
f4635410-9f0b-4784-a02f-cb7810059f9b	1	1	\N	PDF v1.1, Tabela 3.4 p. 59
31b0f633-04b1-488d-ad4f-b71aa4ce66ec	0	1	\N	PDF v1.1, Tabela 3.4 p. 59
79671d81-d320-4c86-aa57-f15a74f64164	1	1	\N	PDF v1.1, Tabela 3.4 p. 59
2a03f265-77cf-4198-8ec1-313bc60c57b2	0	0	\N	PDF v1.1, Tabela 3.3 pp. 56-57
f006cf61-cf4c-44ad-b6bd-3b5572943831	0	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
9841f810-b40e-48f0-a30f-edb09e0b9e3f	0	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
f5f41815-1280-44a7-ba89-2653cb568ae1	0	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
1b6b7bec-ea6f-49df-83d2-1d01aba0ca89	0	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
65a4f42a-1d7f-4b1c-afff-58780de65f74	0	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
7ef0a39b-c538-4e5e-8057-41a5a43a65eb	0	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
ad09228f-4b31-45ad-a2c6-cd24a96e4b43	0	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
cffdb0d5-3f0b-4cec-af72-095d3b1065a5	0	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
85d54c02-ed53-4c01-9e7f-d64a0ea964a4	0	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
ab571040-908c-4c06-a6f7-2ffca307360f	1	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
5c1716e3-e12f-4d76-b1b0-b6ca9412baa9	1	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
7419f5db-0b38-4729-817f-6dd8eeb28102	1	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
5d927ec1-33aa-41c8-b50e-e8100e4add4d	0	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
d9761921-ea0b-4cc8-a08f-c23f5803740a	0	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
00229d7c-8ac4-4931-afdb-eae0739002cd	0	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
013cf605-2a17-497d-9256-cd12983b6d1c	1	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
84e059f1-fd54-45bb-b3eb-904b8b0856ee	1	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
08f23594-8c5e-46c8-8302-bd5981b27548	1	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
54853ae4-d9bc-4f7c-a5d7-a3cc9e8b2436	1	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
a236ba82-e0f8-4698-ad57-f68342bd16cf	1	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
420a81d7-3b32-4494-b689-31265aab1fb7	1	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
7e947a37-1106-4cd6-b978-db8e238f7d40	1	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
9ff75b0d-fea4-412e-9905-3cb05b05e6f7	1	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
38b796fe-e581-47db-b7e4-e2704979b5aa	1	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
8aa191b4-b7a8-4899-84d5-744f5db6c64f	1	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
939eb1ab-25ce-4edb-92ed-38eb9d9c4e53	1	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
d28c7613-c52d-4b47-8779-34e8239831ff	1	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
48772a13-c938-4e39-87d5-99913fbaa6e6	1	1	\N	PDF v1.1, Tabela 3.3 pp. 56-57
ca60c4f8-85e1-416b-853f-93843bc016b5	1	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
385a729f-b5e6-48c8-b545-1b13ac41d7f3	2	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
0ddc72d6-5f59-4511-bbdf-dc14c9157718	3	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
29cc2007-98fc-4a83-850e-640887fa7de1	3	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
c840c186-9ef5-4273-aa2f-a1678d4deac3	3	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
8b6c90e5-bb56-464a-b37c-50d9c0bbf8e8	2	2	\N	PDF v1.1, Tabela 3.3 pp. 56-57
bfc79980-3691-46e0-b9bf-0a185e5b4398	1	2	\N	PDF v1.1, Tabela 3.6 p. 62
7015769c-d533-4974-b4c2-35332f58f0f0	1	2	\N	PDF v1.1, Tabela 3.6 p. 62
cc7349b0-c449-41e4-85c3-12f1a6acb823	2	5	\N	PDF v1.1, Tabela 3.6 p. 62
e5781039-d00d-4f94-932c-4b26f07df835	0	1	\N	PDF v1.1, Tabela 3.8 p. 63
a01a1615-868e-46dd-8fa0-a1074cc65097	1	1	\N	PDF v1.1, Tabela 3.8 p. 63
a5be980b-bec7-4fc5-bc99-c679635a387c	1	1	\N	PDF v1.1, Tabela 3.8 p. 63
39263678-522e-4c00-8818-e158049ebe63	0	1	\N	PDF v1.1, Tabela 3.8 p. 63
9436a317-4b37-4793-83bd-f56fb26a048d	1	1	\N	PDF v1.1, Tabela 3.8 p. 63
55ff885d-dcc8-40ea-bd4d-4a66fc7f4581	0	1	\N	PDF v1.1, Tabela 3.8 p. 63
f4564a3f-d89d-4f84-be10-b7e6df90c694	1	1	\N	PDF v1.1, Tabela 3.8 p. 63
d316f3c6-1dbe-4ff8-ad2d-5d9522d5a802	1	1	\N	PDF v1.1, Tabela 3.8 p. 63
6d7293af-76e1-4204-a356-282faf18d115	0	1	\N	PDF v1.1, Tabela 3.8 p. 63
1faf5cc0-8ebe-4c5d-91c4-abbd109b1dc6	0	1	\N	PDF v1.1, Tabela 3.8 p. 63
ca7e6f35-3fb2-43ff-9848-fef26f18dcdd	1	1	\N	PDF v1.1, Tabela 3.8 p. 63
121b2dac-40a1-4817-8814-c56585363fa6	0	1	\N	PDF v1.1, Tabela 3.8 p. 63
9bd8c7d6-009b-4ef6-8d16-8c395095330c	1	1	\N	PDF v1.1, Tabela 3.8 p. 63
324d519e-bf3d-46ed-a203-bba8e6530870	1	1	\N	PDF v1.1, Tabela 3.8 p. 63
15570622-eb6b-4b01-b4c4-6528fc5056a8	0	1	\N	PDF v1.1, Tabela 3.8 p. 63
bd96d88e-9240-4cf7-96c9-17741508c6c7	0	2	\N	PDF v1.1, Tabela 3.8 p. 63
13f1d4cc-92ef-4784-be44-167c91faa965	1	1	\N	PDF v1.1, Tabela 3.8 p. 63
5474f0f4-9ddb-41dc-94b4-d56b7e21e183	0	1	\N	PDF v1.1, Tabela 3.8 p. 63
067cb40d-abb8-47c8-bac3-1dd7987001a9	1	0	Não ocupa espaço e aumenta a capacidade de carga em 2 espaços.	PDF v1.1, Tabela 3.8 p. 63
f6f827b6-7c4b-4a5d-bdb8-1fc7277fabfd	1	1	\N	PDF v1.1, Tabela 3.8 p. 63
e2f04b54-67a1-4353-80f2-edfaaab84800	0	1	\N	PDF v1.1, Tabela 3.8 p. 63
80178930-50c0-4a08-b3fc-d682739fb14b	1	1	\N	PDF v1.1, Tabela 3.8 p. 63
7647dd6a-1c91-4c3b-a106-658dc556df5b	0	1	\N	PDF v1.1, Tabela 3.8 p. 63
a37f18b1-753c-4d63-adec-c51ce6afba9a	0	1	\N	PDF v1.1, Tabela 3.8 p. 63
57bdecfd-8af8-4bc7-b214-258c97e0ab11	1	1	\N	PDF v1.1, Tabela 3.8 p. 63
a82cd550-1117-480e-958b-d7e22ea07fb6	1	1	\N	PDF v1.1, Tabela 3.8 p. 63
ca6ee024-40e6-4dd6-b25d-e713ba95baee	1	2	\N	PDF v1.1, Tabela 3.8 p. 63
1edf9132-543b-46cf-9406-67472c8072bc	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 150
89873742-deaf-4b9d-b640-8bae95cafbf7	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 150
e4ba7bc5-403f-427c-b1d6-79eeb7e99154	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, pp. 150-151
d3d3e810-cfbc-4535-b806-e2bf62c1dde3	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 151
2d6b71b1-0ee0-4511-80f0-a1f5fb72f25f	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 151
90317f8e-1ea2-4d19-b242-a7839e71f4b7	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 151
1481983b-e1c4-4702-a45c-6fe1960590b5	4	1	Categoria IV explícita; espaço 1 decorre da regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 151
5077ff76-8154-449f-ba0c-0f917ed12c5d	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 148
d386d4b4-e689-4f4d-97fc-4774585e92eb	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 148
a9450faa-413a-43d9-a201-4c4801d90eff	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 148
e6f60a15-29fa-474a-8fb9-aa7dc881a3e4	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 148
82f2c5fd-291f-405d-9ebc-d34721d39de3	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 148
edec1c28-f343-4368-8625-dba996f9a283	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, pp. 148-149
12fc8472-32c2-457d-9571-e6b878217eb3	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 149
7cd71efd-7c4f-4aec-90e6-e88231cffe86	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 149
b27a6267-dc98-44bb-bbb7-52d5a3be1697	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 149
a54e7348-9f3a-43ed-bc71-2e5a53ca3210	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 149
901620e5-904d-4efd-ac78-7fe93c3c75f7	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 149
89938177-68b2-4843-bc24-ed1741149714	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 149
c6636b06-7dae-46c4-8a32-9062caf6320f	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, pp. 149-150
d8681053-5ab6-42d3-b6c7-909187aec931	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 150
aa72bf67-e439-49ce-95b6-8bbfb901efc1	2	1	Categoria II e 1 espaço pela regra geral dos Itens Amaldiçoados Especiais.	PDF v1.1, p. 150
\.


--
-- Data for Name: movement_rule; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.movement_rule (id, name, slug, multiplier, flat_modifier_m, description, rule_data, source_ref) FROM stdin;
fbfee38e-174e-431f-8639-2ba12cb0df82	Deslocamento Padrão	deslocamento-padrao	1.000	\N	Uma ação de movimento percorre o deslocamento do personagem; o valor padrão é 9m.	{"square_m": 1.5, "default_movement_m": 9.0}	PDF v1.1, p. 89
d8f64f23-3deb-4e79-b545-33b9348914e9	Sobrecarregado	sobrecarregado	\N	-3.00	Estar sobrecarregado reduz o deslocamento em 3m.	{}	PDF v1.1, p. 89
6d699c1b-d9a0-40d0-8e89-ac80dc4d3e6b	Diagonal	diagonal	2.000	\N	No mapa, mover-se 1,5m na diagonal consome 3m de deslocamento.	{"square_cost_multiplier": 2}	PDF v1.1, p. 89
051fab8e-db41-4ef9-a6a7-17156b402b92	Terreno Difícil	terreno-dificil	2.000	\N	Mover-se em terreno difícil custa o dobro do deslocamento normal.	{"movement_cost_multiplier": 2}	PDF v1.1, p. 89
d881fdb6-03d0-4376-8633-f9337a42bdbb	Subida Vertical	subida-vertical	2.000	\N	Voando ou nadando, movimento vertical para cima custa o dobro; em diagonal vertical custa o triplo.	{"diagonal_multiplier": 3}	PDF v1.1, p. 89
cb9b28a7-44a3-4862-8b09-9c46cf481d9f	Descida Vertical	descida-vertical	0.500	\N	Voando ou nadando, movimento vertical para baixo custa metade; em diagonal custa o normal.	{"diagonal_multiplier": 1}	PDF v1.1, p. 89
\.


--
-- Data for Name: nex_rule; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.nex_rule (nex, pe_limit, source_ref) FROM stdin;
5	1	PDF v1.1, Tabela 1.2 p. 23
10	2	PDF v1.1, Tabela 1.2 p. 23
15	3	PDF v1.1, Tabela 1.2 p. 23
20	4	PDF v1.1, Tabela 1.2 p. 23
25	5	PDF v1.1, Tabela 1.2 p. 23
30	6	PDF v1.1, Tabela 1.2 p. 23
35	7	PDF v1.1, Tabela 1.2 p. 23
40	8	PDF v1.1, Tabela 1.2 p. 23
45	9	PDF v1.1, Tabela 1.2 p. 23
50	10	PDF v1.1, Tabela 1.2 p. 23
55	11	PDF v1.1, Tabela 1.2 p. 23
60	12	PDF v1.1, Tabela 1.2 p. 23
65	13	PDF v1.1, Tabela 1.2 p. 23
70	14	PDF v1.1, Tabela 1.2 p. 23
75	15	PDF v1.1, Tabela 1.2 p. 23
80	16	PDF v1.1, Tabela 1.2 p. 23
85	17	PDF v1.1, Tabela 1.2 p. 23
90	18	PDF v1.1, Tabela 1.2 p. 23
95	19	PDF v1.1, Tabela 1.2 p. 23
99	20	PDF v1.1, Tabela 1.2 p. 23
\.


--
-- Data for Name: origin_skill_grant; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.origin_skill_grant (id, origin_id, skill_id, grant_group, choice_count, master_choice, notes) FROM stdin;
090152c9-c2b5-47cf-82f5-487682a6a4d2	2e972664-8ec6-4cd2-9fa7-c74cf278d7fd	0859d45c-5039-4d4a-8ca9-b0935107e533	1	0	f	\N
e989490b-5969-4a27-ab71-9ccafaf58d62	2e972664-8ec6-4cd2-9fa7-c74cf278d7fd	4c0358e5-dab8-4778-a4f5-3de3b34bd2d7	2	0	f	\N
35894be8-a282-4531-9f5a-c8fce7b5864a	0a1ef649-4dbe-4e61-adf2-8863a5a425ba	6addb566-ad62-47fc-ada7-3a4789206784	1	0	f	\N
77dad66c-f4bd-4f94-8829-d6454d0fd303	0a1ef649-4dbe-4e61-adf2-8863a5a425ba	72482ffd-cb13-4b1e-bece-303fb9c3685f	2	0	f	\N
dd9963ce-e11d-4f2c-830a-6a89fd052491	d4c64c0d-b88b-42dc-9abb-f2110a6158b7	8f05e179-5621-4e25-a969-a23dff5d6941	1	0	f	\N
d69f794c-a972-4220-8b50-f63dbbf2305f	d4c64c0d-b88b-42dc-9abb-f2110a6158b7	83b28425-380e-4b8c-b244-c8c9cfe3e0d7	2	0	f	\N
1580cf23-4a9f-4479-a368-87a83897c643	1479018f-d88e-4baa-9d24-1e8e7f416bc4	922c3c2d-32bf-4414-bbf2-a741f63c50b6	1	0	f	\N
040f98ca-2b23-4337-ab68-b91c7799e7df	1479018f-d88e-4baa-9d24-1e8e7f416bc4	6c2d9b01-f885-4d52-90e6-53d307409f12	2	0	f	\N
d9017032-52a6-4f84-b604-f6e4471f9804	92b069e1-c8c2-41b4-8abf-bec0dd3dffc3	07fc0547-5b68-4f71-8cdd-06dde575b4d2	1	0	f	\N
252be543-adec-4e4e-bf0f-e09939b6a226	92b069e1-c8c2-41b4-8abf-bec0dd3dffc3	02239e12-80b2-4762-8b4b-3e5edf4d89a9	2	0	f	\N
18200769-ba2d-497c-ac82-f1b4a8ead3f8	17dd0e12-e007-40fc-a0db-85b78c081ce1	487a4440-5a08-4a97-badf-cc59a6af8d78	1	0	f	\N
0ff1631e-e700-46a5-b234-38fe453e11ab	17dd0e12-e007-40fc-a0db-85b78c081ce1	c3841196-d89d-4c41-a890-93bee7644b03	2	0	f	\N
89f89ac9-34af-4ba0-9a4b-7dc65367a349	289ee8bb-c711-43b9-b1a5-b93f99e648ea	1a2ed4bd-bed4-446b-b743-d18d60c130e5	1	0	f	\N
8ff8554e-e372-4f07-888a-513c783a54fa	289ee8bb-c711-43b9-b1a5-b93f99e648ea	5c7ac341-4006-499e-a262-3cf85498a442	2	0	f	\N
5ced78a0-5ab7-43b0-8f3b-f99c69834720	097d9de7-26f3-4ebe-835c-c859280e7b1f	07fc0547-5b68-4f71-8cdd-06dde575b4d2	1	0	f	\N
e3c2db7a-7c37-434a-bec8-fa6ff23cd7e3	097d9de7-26f3-4ebe-835c-c859280e7b1f	902d9e87-64b2-4da8-b4ea-165283027f1a	2	0	f	\N
e9908a82-04ae-46b0-80e6-46c15156d337	883052b1-9f27-49a6-be69-3742358d44d7	02239e12-80b2-4762-8b4b-3e5edf4d89a9	1	0	f	\N
5620825e-aeca-4384-8456-79157b20cd70	883052b1-9f27-49a6-be69-3742358d44d7	80194d65-0aa6-4cec-926f-82561e36750e	2	0	f	\N
113e1327-a257-463a-883f-b193522bbbc2	123fbb6c-9ed5-4f38-b6a2-6f7337b2a628	93ffe95b-b0ef-4faa-b693-c375bcdd22cb	1	0	f	\N
04bfaaaa-a5ca-4e57-82e5-542afd962d24	123fbb6c-9ed5-4f38-b6a2-6f7337b2a628	02239e12-80b2-4762-8b4b-3e5edf4d89a9	2	0	f	\N
0c7cb914-d398-4f36-9846-dde792e9edf8	d1beb8d2-c004-45d3-a6a0-eee1be25a38c	4c0358e5-dab8-4778-a4f5-3de3b34bd2d7	1	0	f	\N
4d2a1885-d899-4692-8de2-12c1847d494a	d1beb8d2-c004-45d3-a6a0-eee1be25a38c	fb22f984-cd2b-41e5-af86-812d9591e6aa	2	0	f	\N
9b41084a-f84a-4430-accf-f04f025c85ed	882b5f8b-d41f-4e40-80c1-a7ac0c53d64a	8cf55386-5621-415f-9ca3-c1dfc4e81348	1	0	f	\N
63f6aeae-ebf2-47d4-ba36-38714ff1fe5a	882b5f8b-d41f-4e40-80c1-a7ac0c53d64a	8372aaee-85ba-4abc-bbca-6b0625883bbc	2	0	f	\N
5e951b6f-4e40-4bf4-bf49-b4e8ef87a718	09e327c6-d066-411d-9e02-d7d0072a2903	93ffe95b-b0ef-4faa-b693-c375bcdd22cb	1	0	f	\N
cc269f93-6f1f-4f4b-84a8-2f3b0746d652	09e327c6-d066-411d-9e02-d7d0072a2903	e1f4663c-d0d3-4cb1-9da6-9d99e22c1177	2	0	f	\N
77da05eb-5286-4903-9753-5b50381591b8	7c562c48-86ba-49f0-9642-55d10455e35e	64cf1a15-4bbf-4086-80a8-bdab541beb54	1	0	f	\N
066d4de4-a286-4e1a-8c8d-0e58d8e40b42	7c562c48-86ba-49f0-9642-55d10455e35e	3fd8bc69-1f47-4b7c-b6c3-48e260b37148	2	0	f	\N
b03e7811-6217-411d-a0bb-826bc3b4cd1d	467a76cc-fb73-4598-8a19-9e77f285fc83	30b4680b-1aea-481e-a428-c47a99263cf4	1	0	f	\N
527b05d8-6d35-42ce-8984-613bcbf894e6	467a76cc-fb73-4598-8a19-9e77f285fc83	028f7ff4-efab-4bd3-8922-a9f431b9da2c	2	0	f	\N
d537c613-7bbc-4fdc-8b7c-c282762e95ef	6a28b1fb-36f8-4033-b83e-af82c577aefd	07fc0547-5b68-4f71-8cdd-06dde575b4d2	1	0	f	\N
8ec3353b-1027-480c-95f6-2c281e6f14ca	6a28b1fb-36f8-4033-b83e-af82c577aefd	02239e12-80b2-4762-8b4b-3e5edf4d89a9	2	0	f	\N
837212d7-e403-4bd6-a63e-017e5bd01bbe	6fa66243-9b26-44ac-84f9-79735b67b2ce	fb22f984-cd2b-41e5-af86-812d9591e6aa	1	0	f	\N
c29c76c5-6dd4-4426-961f-391a3fd4740b	6fa66243-9b26-44ac-84f9-79735b67b2ce	30b4680b-1aea-481e-a428-c47a99263cf4	2	0	f	\N
0b7a2aa1-888c-4e0e-90df-652e46e44a08	662569e1-99fb-48b3-b8a2-ad3a915c3d98	5c7ac341-4006-499e-a262-3cf85498a442	1	0	f	\N
69054fcb-e7f0-4882-af63-c9e846a7f554	662569e1-99fb-48b3-b8a2-ad3a915c3d98	352f5340-7a8a-4d88-ad7c-70cb86d6fbef	2	0	f	\N
9ef5f31c-1fb9-4115-82d3-1707a3df75ce	fc4f66fd-9ced-44be-a074-f53872b5c5c1	6addb566-ad62-47fc-ada7-3a4789206784	1	0	f	\N
3e16fab5-60ad-4086-a84f-62adc40fe54c	fc4f66fd-9ced-44be-a074-f53872b5c5c1	352f5340-7a8a-4d88-ad7c-70cb86d6fbef	2	0	f	\N
8e474ef2-f47e-465f-a531-5b9e9a8e3155	b8fe5383-2e7f-4076-bd28-d806cbef7d02	4c0358e5-dab8-4778-a4f5-3de3b34bd2d7	1	0	f	\N
c1fe5920-45be-4209-b13b-dd8129624ee6	b8fe5383-2e7f-4076-bd28-d806cbef7d02	1a2ed4bd-bed4-446b-b743-d18d60c130e5	2	0	f	\N
e01e8f8c-ce59-4688-9358-88e1a1997585	448dac9f-0ea0-4f5e-ac5c-e105776cdbf8	4c0358e5-dab8-4778-a4f5-3de3b34bd2d7	1	0	f	\N
e84b2da1-a030-4566-b5fc-bb8cb9feae50	448dac9f-0ea0-4f5e-ac5c-e105776cdbf8	80194d65-0aa6-4cec-926f-82561e36750e	2	0	f	\N
d1b314a7-1be4-482a-8455-8020b70c5eb9	cc315fc5-08e9-40f4-9aad-02f882e01c1b	30156222-5290-4ddc-8c83-739aff02497f	1	0	f	\N
05a4ebec-4222-4ecf-9b08-c02d1b15796a	cc315fc5-08e9-40f4-9aad-02f882e01c1b	902d9e87-64b2-4da8-b4ea-165283027f1a	2	0	f	\N
09eec518-e31d-4d70-9512-c66fbb712680	dd7234fe-f31e-4ee4-8eee-98dac48b7431	487a4440-5a08-4a97-badf-cc59a6af8d78	1	0	f	\N
fb5011d8-5567-4f82-9f6b-5ef93fcb09d6	dd7234fe-f31e-4ee4-8eee-98dac48b7431	83b28425-380e-4b8c-b244-c8c9cfe3e0d7	2	0	f	\N
30f7cf0c-5c7d-49ee-abf4-4429ae96e054	812534d9-66e1-40cb-ab22-5c8839b3e1b5	96e4e0b9-f67c-4aee-99fc-668d9c46a2b2	1	0	f	\N
21377659-c949-4b67-95bd-3bd300d4c526	812534d9-66e1-40cb-ab22-5c8839b3e1b5	4c0358e5-dab8-4778-a4f5-3de3b34bd2d7	2	0	f	\N
be7b01df-10c3-4889-98ac-56a2a92428aa	e806e5b5-7626-48bd-97be-ba4fafe7ff90	8372aaee-85ba-4abc-bbca-6b0625883bbc	1	0	f	\N
3fc73c1b-5f6f-4d09-9c8b-14341679d2a3	e806e5b5-7626-48bd-97be-ba4fafe7ff90	352f5340-7a8a-4d88-ad7c-70cb86d6fbef	2	0	f	\N
37421a6a-c7fb-4285-a238-4e11b4047e6c	8bcbd258-0259-457a-8eb5-6314e3412491	\N	1	2	t	Duas perícias à escolha do mestre.
\.


--
-- Data for Name: patent_rule; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.patent_rule (progression_tier_id, credit_limit, category_i_limit, category_ii_limit, category_iii_limit, category_iv_limit, source_ref) FROM stdin;
87c7f84e-91dc-4a32-8f7e-46208b74b10d	ILIMITADO	3	3	3	2	PDF v1.1, Tabela 3.1 p. 52
10659be7-48ca-4776-98a1-dbf2eb19f740	MEDIO	3	2	1	0	PDF v1.1, Tabela 3.1 p. 52
c16a3c99-3114-4525-8126-3d1880373c40	ALTO	3	3	2	1	PDF v1.1, Tabela 3.1 p. 52
43f99edf-fd95-46bf-8921-04c14eec8064	MEDIO	3	1	0	0	PDF v1.1, Tabela 3.1 p. 52
b46b1e06-21f8-4ae7-a95a-1dc064e73132	BAIXO	2	0	0	0	PDF v1.1, Tabela 3.1 p. 52
\.


--
-- Data for Name: protection; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.protection (item_id, proficiency_id, defense_bonus, rd_text, load_penalty_value, source_ref) FROM stdin;
bfc79980-3691-46e0-b9bf-0a185e5b4398	260af6d5-9ff2-4a7f-a0fe-612819b92b13	2	\N	\N	PDF v1.1, p. 62
7015769c-d533-4974-b4c2-35332f58f0f0	00be5026-3797-441d-b03a-231579e67224	5	\N	\N	PDF v1.1, p. 62
cc7349b0-c449-41e4-85c3-12f1a6acb823	260af6d5-9ff2-4a7f-a0fe-612819b92b13	10	Balístico, corte, impacto e perfuração 2	-5	PDF v1.1, p. 62
\.


--
-- Data for Name: rest_condition; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.rest_condition (id, name, slug, recovery_multiplier, sort_order, description, source_ref) FROM stdin;
fb7e1b43-1fe0-44b3-a546-8cad58dea09d	Precária	precaria	0.50	1	Recuperação reduzida pela metade.	PDF v1.1, p. 93
447f8a8d-df91-4091-a76a-7b5ed3fb53d9	Normal	normal	1.00	2	Recuperação igual ao Limite de PE.	PDF v1.1, p. 93
16c5dfb6-4112-494c-8528-45aef0192d91	Confortável	confortavel	2.00	3	Recuperação dobrada.	PDF v1.1, p. 93
f6347961-8bc5-4ab5-952e-1a3f3b6df458	Luxuosa	luxuosa	3.00	4	Recuperação triplicada.	PDF v1.1, p. 93
\.


--
-- Data for Name: ritual; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.ritual (ability_id, element_id, circle, pe_cost, execution, range_text, target_text, area_text, duration_text, resistance_text, source_ref) FROM stdin;
2c8d37f4-e82b-4ca6-8e40-0255a2788739	52779391-a501-4a9e-b780-684349da1c1c	4	10	reação	pessoal	você	\N	instantânea	\N	PDF v1.1, ritual p. 124
0eae77b1-8e67-4b2b-aa0d-249bb2a51087	d855bb6c-9321-48db-8e24-05e58697a31d	3	6	padrão	toque	1 pessoa	\N	instantânea	Vontade anula	PDF v1.1, ritual p. 124
2163550a-2419-4042-9156-7987c84e3004	d855bb6c-9321-48db-8e24-05e58697a31d	1	1	padrão	toque	1 arma corpo a corpo ou pacote de munição	\N	cena	\N	PDF v1.1, ritual p. 124
f35cd399-f732-4a66-bf6b-c8104ee5a0bf	52779391-a501-4a9e-b780-684349da1c1c	1	1	padrão	toque	1 arma corpo a corpo ou pacote de munição	\N	cena	\N	PDF v1.1, ritual p. 124
b129ac9c-23ba-4318-b0d1-34fa3f043de9	bca15d0f-87ca-4375-aaef-b639c7295552	1	1	padrão	toque	1 arma corpo a corpo ou pacote de munição	\N	cena	\N	PDF v1.1, ritual p. 124
0bdf7448-ed3f-4783-ab7c-7406ba6df0e9	9290710c-ae4d-486c-8d69-2afb4db4c030	1	1	padrão	toque	1 arma corpo a corpo ou pacote de munição	\N	cena	\N	PDF v1.1, ritual p. 124
2047fef0-b7e9-4f92-8c3c-3b6a23542777	52779391-a501-4a9e-b780-684349da1c1c	1	1	padrão	toque	1 acessório ou arma de fogo	\N	cena	\N	PDF v1.1, ritual p. 124
2ea4c50c-a34f-4157-ae1b-4872d40d1a65	bca15d0f-87ca-4375-aaef-b639c7295552	3	6	padrão	curto	1 ser	\N	cena	Vontade parcial	PDF v1.1, ritual p. 124
f5648ca6-a4c2-4ea1-a0a0-d43337cfce3c	9290710c-ae4d-486c-8d69-2afb4db4c030	2	3	padrão	toque	1 ser	\N	cena	\N	PDF v1.1, ritual p. 125
9a32cea2-906f-4226-b2a9-5df0809cc754	d855bb6c-9321-48db-8e24-05e58697a31d	2	3	padrão	toque	1 ser	\N	cena	\N	PDF v1.1, ritual p. 125
c7716109-254f-439f-8ec0-17f4edac5594	9290710c-ae4d-486c-8d69-2afb4db4c030	1	1	padrão	toque	1 arma corpo a corpo	\N	sustentada	\N	PDF v1.1, ritual p. 125
fd2c6ae0-2f1a-44ce-a160-0a3879f83c06	9290710c-ae4d-486c-8d69-2afb4db4c030	1	1	padrão	pessoal	você	\N	cena	\N	PDF v1.1, ritual p. 125
2abc7564-9063-4ef4-82db-6e015457f284	76759131-d2e3-4de1-964f-7c865e4dc5f9	4	10	padrão	toque	1 pessoa	\N	permanente até ser descarregada	\N	PDF v1.1, ritual p. 125
c065d959-47c8-42a2-975d-903575c78aac	9290710c-ae4d-486c-8d69-2afb4db4c030	4	10	padrão	curto	1 pessoa	\N	cena	Vontade parcial	PDF v1.1, ritual p. 125
14bfb442-c14a-4c55-9c05-1d0f9302e842	52779391-a501-4a9e-b780-684349da1c1c	2	3	padrão	curto	veja texto	\N	cena	\N	PDF v1.1, ritual p. 126
e723b128-dced-4940-bfbc-cb4c9bc4dfb7	bca15d0f-87ca-4375-aaef-b639c7295552	1	1	padrão	toque	1 ser	\N	instantânea	\N	PDF v1.1, ritual p. 126
5425bfd8-3df0-4bf3-a6cc-177766d52080	76759131-d2e3-4de1-964f-7c865e4dc5f9	1	1	padrão	curto	\N	nuvem de 6m de raio	cena	\N	PDF v1.1, ritual p. 126
96871314-cd14-47cb-adb1-cc39840fd656	52779391-a501-4a9e-b780-684349da1c1c	1	1	padrão	curto	1 ser	\N	cena	\N	PDF v1.1, ritual p. 126
58e7e59e-05da-4efd-b979-375ee1df922c	d855bb6c-9321-48db-8e24-05e58697a31d	1	1	padrão	toque	1 ser ou objeto	\N	cena	Vontade anula (veja texto)	PDF v1.1, ritual p. 126
8c7f5fd2-79cd-40fd-9634-de96cd1e9a5b	76759131-d2e3-4de1-964f-7c865e4dc5f9	4	10	padrão	toque	1 pessoa	\N	cena	Vontade parcial	PDF v1.1, ritual p. 127
f4eb79f7-d170-4e15-898d-26ac10a644e4	bca15d0f-87ca-4375-aaef-b639c7295552	1	1	padrão	pessoal	você	\N	instantânea	\N	PDF v1.1, ritual p. 127
e606a428-2361-4a6b-9b36-d88ee0413ba6	d855bb6c-9321-48db-8e24-05e58697a31d	3	6	completa	pessoal	você	\N	1 dia	\N	PDF v1.1, ritual p. 127
2405ec4f-6ed8-447c-85cc-71b90703e09b	52779391-a501-4a9e-b780-684349da1c1c	2	3	padrão	médio	1 ser	\N	cena	Reflexos anula	PDF v1.1, ritual p. 127
6c8eac70-d6f0-4ecf-93c5-6db46d6f48d0	d855bb6c-9321-48db-8e24-05e58697a31d	4	10	padrão	médio	1 pessoa ou animal	\N	sustentada	Vontade parcial	PDF v1.1, ritual p. 128
74b87116-c584-4830-a8ac-b403da05d969	52779391-a501-4a9e-b780-684349da1c1c	3	6	padrão	ilimitado	1 objeto de até 2 espaços	\N	instantânea	Vontade anula	PDF v1.1, ritual p. 128
b678aa48-0e59-4c84-84ac-22454f6a7de0	bca15d0f-87ca-4375-aaef-b639c7295552	4	10	padrão	1,5m	1 pessoa	\N	sustentada	Vontade parcial, Fortitude parcial	PDF v1.1, ritual p. 128
47124fdf-0974-49af-8e79-6e3ea8863bb8	9290710c-ae4d-486c-8d69-2afb4db4c030	1	1	padrão	toque	1 pessoa ou animal	\N	cena	\N	PDF v1.1, ritual p. 128
675025ed-84af-43b7-96e5-8338efe9a129	bca15d0f-87ca-4375-aaef-b639c7295552	1	1	padrão	toque	1 ser	\N	instantânea	Fortitude reduz à metade	PDF v1.1, ritual p. 129
0c076548-f470-41c3-b448-bbe7a59a7ea8	bca15d0f-87ca-4375-aaef-b639c7295552	1	1	padrão	curto	1 ser	\N	cena	Fortitude parcial	PDF v1.1, ritual p. 129
be1d4147-cca6-4a3b-96a6-8476925a542d	52779391-a501-4a9e-b780-684349da1c1c	4	10	completa	pessoal	\N	explosão de 15m de raio	\N	Fortitude parcial	PDF v1.1, ritual p. 129
9cecc9eb-9fb1-4fc7-9561-95127a6b85da	bca15d0f-87ca-4375-aaef-b639c7295552	2	3	reação	curto	1 ser ou objetos somando até 10 espaços	\N	até chegar ao solo ou cena, o que vier primeiro	\N	PDF v1.1, ritual p. 129
0e606536-bef9-43cd-aec6-e07f79ecc216	9290710c-ae4d-486c-8d69-2afb4db4c030	2	3	padrão	toque	1 ser	\N	instantânea	Fortitude parcial	PDF v1.1, ritual p. 129
b326548e-31fc-4acd-b6cc-b2a4865ec882	d855bb6c-9321-48db-8e24-05e58697a31d	2	3	padrão	pessoal	\N	esfera de 18m de raio	cena	\N	PDF v1.1, ritual p. 130
b98d707e-e27a-4fd4-a8e6-e8b5675aeb1f	76759131-d2e3-4de1-964f-7c865e4dc5f9	3	6	padrão	médio	1 ser ou objeto	esfera com 3m de raio	instantânea	\N	PDF v1.1, ritual p. 130
8ef60ca3-8415-489e-b84e-7dfacebb5739	52779391-a501-4a9e-b780-684349da1c1c	2	3	padrão	médio	\N	esfera com 6m de raio	sustentada	\N	PDF v1.1, ritual p. 130
7c76245f-58fe-4a13-b740-d1770fe35b69	bca15d0f-87ca-4375-aaef-b639c7295552	4	10	padrão	pessoal	veja texto	\N	veja texto	\N	PDF v1.1, ritual p. 130
8eb514d3-cfa8-4887-86dc-3a76a260057b	9290710c-ae4d-486c-8d69-2afb4db4c030	1	1	padrão	pessoal	você	\N	cena	Vontade desacredita	PDF v1.1, ritual p. 130
ffa681e1-5bbd-4486-8762-ec2864f3f4d9	bca15d0f-87ca-4375-aaef-b639c7295552	2	3	padrão	curto	1 ser	\N	2 rodadas	Fortitude reduz à metade	PDF v1.1, ritual p. 131
2bfbf8e3-9764-467a-9e0a-2e84d1fc8808	52779391-a501-4a9e-b780-684349da1c1c	1	1	padrão	curto	1 ser ou objeto	\N	instantânea	Fortitude parcial	PDF v1.1, ritual p. 131
19e0b0a2-fecc-47d9-8107-2e9f953a68e0	52779391-a501-4a9e-b780-684349da1c1c	1	1	padrão	pessoal	você	\N	cena	\N	PDF v1.1, ritual p. 131
5ceb3b7e-6f87-4248-895a-a6ff99111e0a	d855bb6c-9321-48db-8e24-05e58697a31d	1	1	padrão	curto	1 pessoa	\N	cena	Vontade anula	PDF v1.1, ritual p. 131
d5657ce4-3488-4d35-8880-9c83ebd15eae	d855bb6c-9321-48db-8e24-05e58697a31d	2	3	livre	pessoal	você	\N	1 rodada	\N	PDF v1.1, ritual p. 132
746611f0-4bfe-48ab-9420-6596a1026b5b	bca15d0f-87ca-4375-aaef-b639c7295552	1	1	padrão	curto	1 ser	\N	cena	\N	PDF v1.1, ritual p. 132
634711eb-9d5a-4ad3-bc20-1e09e3ca006e	9290710c-ae4d-486c-8d69-2afb4db4c030	3	6	padrão	curto	1 ser	\N	sustentada	Fortitude parcial	PDF v1.1, ritual p. 132
f94059e2-bbbe-4811-a620-2d5540386a2d	bca15d0f-87ca-4375-aaef-b639c7295552	4	10	completa	extremo	Efeito: buraco negro com 1,5m de diâmetro	\N	4 rodadas	Fortitude parcial	PDF v1.1, ritual p. 132
68906119-abd6-4edc-b553-d44a2601e465	9290710c-ae4d-486c-8d69-2afb4db4c030	2	3	padrão	toque	1 pessoa	\N	cena	Fortitude parcial	PDF v1.1, ritual p. 133
f870b656-aee7-462d-ae08-cf4b57c7297f	9290710c-ae4d-486c-8d69-2afb4db4c030	3	6	padrão	pessoal	você	\N	cena	\N	PDF v1.1, ritual p. 133
0f48f60c-7d75-4a9f-aeb0-625865fbaf77	9290710c-ae4d-486c-8d69-2afb4db4c030	1	1	padrão	pessoal	você	\N	cena	\N	PDF v1.1, ritual p. 133
352c32b0-4383-4479-b925-bafc2ed1f5ac	9290710c-ae4d-486c-8d69-2afb4db4c030	2	3	padrão	toque	1 ser	\N	instantânea	Fortitude reduz à metade	PDF v1.1, ritual p. 133
a31d1ec9-14da-467e-b4a8-64793844bd5d	d855bb6c-9321-48db-8e24-05e58697a31d	4	10	padrão	toque	1 ser	\N	instantânea	Vontade parcial	PDF v1.1, ritual p. 134
029ed9d6-922f-4af6-ab5a-92c492a7cb27	d855bb6c-9321-48db-8e24-05e58697a31d	2	3	padrão	médio ou toque	1 ser ou 2 pessoas voluntárias	\N	instantânea ou 1 dia	Vontade parcial ou nenhuma	PDF v1.1, ritual p. 134
70255d54-db1c-45f3-8c7e-4662941074b8	9290710c-ae4d-486c-8d69-2afb4db4c030	4	10	padrão	curto	Efeito: 1 clone seu	\N	cena	\N	PDF v1.1, ritual p. 134
85d43c4f-c14d-487a-bb2e-79c2704ca4d3	76759131-d2e3-4de1-964f-7c865e4dc5f9	4	10	padrão	toque	1 ser	\N	instantânea	Fortitude parcial	PDF v1.1, ritual p. 135
1819c4e9-409d-4051-8c93-c2fec070dd43	d855bb6c-9321-48db-8e24-05e58697a31d	2	3	padrão	pessoal	\N	círculo com 90m de raio	cena	\N	PDF v1.1, ritual p. 135
40752128-44f0-47da-8c5d-f3763e46b7ed	52779391-a501-4a9e-b780-684349da1c1c	1	1	padrão	curto	1 objeto	\N	cena	Vontade anula (veja texto)	PDF v1.1, ritual p. 135
63f84939-2425-4e9e-884b-de8fe9eb674d	76759131-d2e3-4de1-964f-7c865e4dc5f9	4	10	padrão	pessoal	você	\N	cena	\N	PDF v1.1, ritual p. 135
aa007c8c-da36-443a-bbfa-fe1138be3674	d855bb6c-9321-48db-8e24-05e58697a31d	3	6	padrão	toque	1 pessoa	\N	sustentada	Vontade parcial (veja texto)	PDF v1.1, ritual p. 136
059735fa-b8a8-40b5-bd9d-cb2e6a1b4c07	bca15d0f-87ca-4375-aaef-b639c7295552	2	3	padrão	médio	\N	nuvem com 6m de raio	instantânea	Fortitude parcial (veja texto)	PDF v1.1, ritual p. 136
7367a744-b0a9-40d3-8879-259531799286	bca15d0f-87ca-4375-aaef-b639c7295552	1	1	padrão	curto	Efeito: nuvem com 6m de raio e 6m de altura	\N	cena	\N	PDF v1.1, ritual p. 136
d5890474-e7ff-490d-bbad-bb01431a7340	9290710c-ae4d-486c-8d69-2afb4db4c030	1	1	padrão	toque	1 pessoa	\N	cena	\N	PDF v1.1, ritual p. 136
aaf7fce1-94d7-4893-9412-77a861be5c67	d855bb6c-9321-48db-8e24-05e58697a31d	1	1	completa	pessoal	você	\N	instantânea	\N	PDF v1.1, ritual p. 137
7c4406b9-df35-462c-82f3-3bf376a3d737	bca15d0f-87ca-4375-aaef-b639c7295552	2	3	padrão	médio	\N	esfera com 6m de raio	instantânea	Fortitude reduz à metade	PDF v1.1, ritual p. 137
c9cdf410-fe29-499a-8586-1dd087326e22	d855bb6c-9321-48db-8e24-05e58697a31d	1	1	padrão	curto	1 pessoa	\N	1 rodada	Vontade (anula)	PDF v1.1, ritual p. 137
e9f793cc-c54f-4862-9f87-fee73caf5474	bca15d0f-87ca-4375-aaef-b639c7295552	3	6	padrão	médio	\N	nuvem com 6m de raio	sustentada	Fortitude (veja texto)	PDF v1.1, ritual p. 138
ed0f50df-8c77-4c78-b012-95dbbdb4adec	52779391-a501-4a9e-b780-684349da1c1c	1	1	padrão	curto	você	\N	sustentada	Vontade anula	PDF v1.1, ritual p. 138
fc8aab2d-c245-4c67-8610-cb5609b2d31e	d855bb6c-9321-48db-8e24-05e58697a31d	4	10	padrão	longo	1 pessoa viva ou morta	\N	1 dia	Vontade anula	PDF v1.1, ritual p. 138
c747d4e9-db06-4899-84b2-7b0525b3c94e	76759131-d2e3-4de1-964f-7c865e4dc5f9	4	10	padrão	pessoal	\N	emanação de 9m de raio	sustentada	\N	PDF v1.1, ritual p. 139
50f8e24a-3ad7-41b3-8233-1ab6b49241d2	76759131-d2e3-4de1-964f-7c865e4dc5f9	2	3	padrão	toque	1 ser	\N	cena	\N	PDF v1.1, ritual p. 139
6e209bb3-5207-417c-848b-604cb0009a02	9290710c-ae4d-486c-8d69-2afb4db4c030	3	6	padrão	curto	área de 6m de raio	\N	sustentada	Fortitude parcial	PDF v1.1, ritual p. 139
09a4ced8-395b-470d-b908-9b7a7fdbbfe9	76759131-d2e3-4de1-964f-7c865e4dc5f9	2	3	padrão	curto	\N	nuvem de 6m de raio	cena	\N	PDF v1.1, ritual p. 139
9b660863-9c16-492d-bd09-404780d87455	52779391-a501-4a9e-b780-684349da1c1c	3	6	padrão	médio	você	\N	instantânea	\N	PDF v1.1, ritual p. 139
14f656fa-83f3-4054-8421-fff1a1dc29e2	52779391-a501-4a9e-b780-684349da1c1c	2	3	padrão	médio	\N	varia	sustentada	veja texto	PDF v1.1, ritual p. 140
c8be4994-b2f3-40b8-845d-f76794ab3243	d855bb6c-9321-48db-8e24-05e58697a31d	1	1	padrão	médio	Efeito: ilusão que se estende a até 4 cubos de 1,5m	\N	cena	Vontade desacredita	PDF v1.1, ritual p. 140
3b5b45cc-d205-4148-811e-94825fb374a7	52779391-a501-4a9e-b780-684349da1c1c	2	3	padrão	pessoal	você	\N	cena	\N	PDF v1.1, ritual p. 141
0023d1e0-f7b5-4438-99ee-bce572033d38	52779391-a501-4a9e-b780-684349da1c1c	4	10	padrão	toque	até 5 seres voluntários	\N	instantânea	\N	PDF v1.1, ritual p. 141
bb091fa6-8117-428d-893e-e741eba51091	bca15d0f-87ca-4375-aaef-b639c7295552	3	6	padrão	médio	\N	círculo com 6m de raio	cena	\N	PDF v1.1, ritual p. 141
34ef1e15-b5f4-4138-b247-d3475689d844	d855bb6c-9321-48db-8e24-05e58697a31d	1	1	padrão	pessoal	você	\N	cena	\N	PDF v1.1, ritual p. 141
d0ce03ab-7fb1-47f7-87b4-222bd18263c9	52779391-a501-4a9e-b780-684349da1c1c	3	6	padrão	longo	\N	esfera com 30m de raio	cena	veja texto	PDF v1.1, ritual p. 142
e0fdeac8-093e-4a98-99c8-a1b4a013c2b3	52779391-a501-4a9e-b780-684349da1c1c	3	6	padrão	longo	\N	9 cubos com 1,5m de lado	instantânea	veja texto	PDF v1.1, ritual p. 142
8d99146e-aed8-4901-b813-88657a357c6f	9290710c-ae4d-486c-8d69-2afb4db4c030	2	3	padrão	toque	1 ser	\N	instantânea	\N	PDF v1.1, ritual p. 142
5640ef1b-2653-4246-ba68-26bef7f3d459	bca15d0f-87ca-4375-aaef-b639c7295552	2	3	padrão	curto	1 ser	\N	sustentada	\N	PDF v1.1, ritual p. 142
09bbe454-e56b-4f2a-88ac-5236484e0212	d855bb6c-9321-48db-8e24-05e58697a31d	3	6	completa	ilimitado	1 ser	\N	5 rodadas	Vontade anula	PDF v1.1, ritual p. 143
6f9ad5c3-8144-47b4-8f55-7e21914228ee	9290710c-ae4d-486c-8d69-2afb4db4c030	4	10	padrão	curto	1 ser	\N	cena	Fortitude anula	PDF v1.1, ritual p. 143
bbabd94b-c6e8-4e8b-bd23-a4cc94b4705a	9290710c-ae4d-486c-8d69-2afb4db4c030	3	6	padrão	médio	Efeito: 1 enxame Grande (quadrado de 3m)	\N	sustentada	Reflexos reduz à metade	PDF v1.1, ritual p. 143
f51c7a06-21e4-4863-b9a0-be6fbd12c38a	bca15d0f-87ca-4375-aaef-b639c7295552	3	6	padrão	curto	1 pessoa	\N	cena	Vontade parcial	PDF v1.1, ritual p. 143
\.


--
-- Data for Name: skill_rule; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.skill_rule (skill_id, trained_only, load_penalty, requires_kit) FROM stdin;
922c3c2d-32bf-4414-bbf2-a741f63c50b6	f	t	f
30156222-5290-4ddc-8c83-739aff02497f	t	f	f
8f05e179-5621-4e25-a969-a23dff5d6941	t	f	f
6c2d9b01-f885-4d52-90e6-53d307409f12	f	f	f
96e4e0b9-f67c-4aee-99fc-668d9c46a2b2	f	f	f
0859d45c-5039-4d4a-8ca9-b0935107e533	t	f	f
487a4440-5a08-4a97-badf-cc59a6af8d78	t	t	t
93ffe95b-b0ef-4faa-b693-c375bcdd22cb	f	f	f
83b28425-380e-4b8c-b244-c8c9cfe3e0d7	f	f	t
07fc0547-5b68-4f71-8cdd-06dde575b4d2	f	f	f
c3841196-d89d-4c41-a890-93bee7644b03	f	t	f
64cf1a15-4bbf-4086-80a8-bdab541beb54	f	f	f
3fd8bc69-1f47-4b7c-b6c3-48e260b37148	f	f	f
6addb566-ad62-47fc-ada7-3a4789206784	f	f	f
4c0358e5-dab8-4778-a4f5-3de3b34bd2d7	f	f	f
8cf55386-5621-415f-9ca3-c1dfc4e81348	f	f	f
72482ffd-cb13-4b1e-bece-303fb9c3685f	f	f	t
1a2ed4bd-bed4-446b-b743-d18d60c130e5	t	f	f
fb22f984-cd2b-41e5-af86-812d9591e6aa	f	f	f
e1f4663c-d0d3-4cb1-9da6-9d99e22c1177	t	f	f
30b4680b-1aea-481e-a428-c47a99263cf4	f	f	f
02239e12-80b2-4762-8b4b-3e5edf4d89a9	t	f	f
8372aaee-85ba-4abc-bbca-6b0625883bbc	f	f	f
5c7ac341-4006-499e-a262-3cf85498a442	t	f	f
902d9e87-64b2-4da8-b4ea-165283027f1a	f	f	f
028f7ff4-efab-4bd3-8922-a9f431b9da2c	t	f	f
80194d65-0aa6-4cec-926f-82561e36750e	t	f	t
352f5340-7a8a-4d88-ad7c-70cb86d6fbef	f	f	f
\.


--
-- Data for Name: special_cursed_item; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.special_cursed_item (item_id, element_id, curse_count, unique_item, effect_summary, source_ref) FROM stdin;
1edf9132-543b-46cf-9406-67472c8072bc	52779391-a501-4a9e-b780-684349da1c1c	1	f	Ao cair a 0 PV, gasta automaticamente 5 PE do usuário para reanimá-lo com 4d10 PV. Sem PE suficiente não funciona. A cada ativação há chance de 1 em 1d10 de matar o usuário instantaneamente.	PDF v1.1, p. 150
89873742-deaf-4b9d-b640-8bae95cafbf7	52779391-a501-4a9e-b780-684349da1c1c	1	f	Uma vez por rodada pode gastar 1 PE para rolar novamente qualquer dado cujo resultado tenha sido 1. O custo aumenta em +1 PE para cada ativação adicional no mesmo dia.	PDF v1.1, p. 150
e4ba7bc5-403f-427c-b1d6-79eeb7e99154	52779391-a501-4a9e-b780-684349da1c1c	1	f	Ao sofrer dano enquanto veste o talismã, reação e 3 PE permitem rolar 1d4: 2-3 evitam o dano; 4 evita e destrói o talismã; 1 dobra o dano e também destrói o talismã.	PDF v1.1, pp. 150-151
d3d3e810-cfbc-4535-b806-e2bf62c1dde3	52779391-a501-4a9e-b780-684349da1c1c	1	f	Conectar ao computador exige ação de movimento. Remove impedimentos tecnológicos ou de idioma, concede +10 para hackear e reduz à metade o tempo para localizar arquivos; causa 1d6 de dano mental por rodada de uso.	PDF v1.1, p. 151
2d6b71b1-0ee0-4511-80f0-a1f5fb72f25f	52779391-a501-4a9e-b780-684349da1c1c	1	f	Ação padrão e 2 PE armam a tela. A próxima pessoa que tocar faz Vontade contra DT do usuário +5; falha causa atordoamento e 4d6 de dano mental, repetindo o teste nas rodadas seguintes até encerrar o efeito.	PDF v1.1, p. 151
90317f8e-1ea2-4d19-b242-a7839e71f4b7	52779391-a501-4a9e-b780-684349da1c1c	1	f	Não precisa de combustível. O motorista pode usar reação e Pilotagem DT 25 para tornar veículo e ocupantes momentaneamente incorpóreos em forma de Energia e atravessar um objeto, evitando colisão.	PDF v1.1, p. 151
1481983b-e1c4-4702-a45c-6fe1960590b5	76759131-d2e3-4de1-964f-7c865e4dc5f9	1	t	Concede resistência a dano paranormal 15. Quando aliado adjacente sofreria dano, reação e 2 PE permitem que o usuário se torne o alvo do dano. É item único e explicitamente categoria IV.	PDF v1.1, p. 151
5077ff76-8154-449f-ba0c-0f917ed12c5d	9290710c-ae4d-486c-8d69-2afb4db4c030	1	f	Ao sofrer dano enquanto empunha o item, pode usar reação para reduzir esse dano à metade. Cada uso exige Fortitude DT 15 + 5 por uso adicional no mesmo dia; falha destrói o item.	PDF v1.1, p. 148
d386d4b4-e689-4f4d-97fc-4774585e92eb	9290710c-ae4d-486c-8d69-2afb4db4c030	1	f	Uma vez por rodada, pode usar reação para converter dano mental recebido em dano de Sangue. Enquanto veste o item não recupera Sanidade por descanso. Exige uma semana de uso para ativar.	PDF v1.1, p. 148
a9450faa-413a-43d9-a201-4c4801d90eff	9290710c-ae4d-486c-8d69-2afb4db4c030	1	f	Pode sofrer até 20 PV em 1 minuto para armazenar sangue. Beber exige ação padrão e recupera a mesma quantidade armazenada; Fortitude DT 20 evita ficar enjoado por uma rodada.	PDF v1.1, p. 148
e6f60a15-29fa-474a-8fb9-aa7dc881a3e4	9290710c-ae4d-486c-8d69-2afb4db4c030	1	f	Ação de movimento para absorver: recebe +5 em testes de Agilidade, Força e Vigor e testes baseados nesses atributos até o fim da cena. Depois faz Fortitude DT 20; falha causa fadiga, e falha por 5 ou mais deixa morrendo.	PDF v1.1, p. 148
82f2c5fd-291f-405d-9ebc-d34721d39de3	9290710c-ae4d-486c-8d69-2afb4db4c030	1	f	Ataques desarmados causam 1d8 de dano de Sangue. Após acertar, pode atacar novamente o mesmo alvo pagando PE crescente: 2 PE pelo primeiro ataque extra, depois +2 PE a cada novo ataque extra no turno.	PDF v1.1, p. 148
edec1c28-f343-4368-8625-dba996f9a283	9290710c-ae4d-486c-8d69-2afb4db4c030	1	f	Pode coletar sangue de alvo adjacente e injetá-lo em outra pessoa para reproduzir a aparência do dono do sangue por um dia, como Distorcer Aparência. Ao terminar, resultado 1 em 1d6 causa perda permanente de 1 PV.	PDF v1.1, pp. 148-149
12fc8472-32c2-457d-9571-e6b878217eb3	bca15d0f-87ca-4375-aaef-b639c7295552	1	f	Uma vez por rodada, ação padrão e 2 PE permitem agarrar alvo Grande ou menor em alcance curto com +10 no teste oposto. Ação de movimento pode puxar o alvo agarrado para adjacente.	PDF v1.1, p. 149
7cd71efd-7c4f-4aec-90e6-e88231cffe86	bca15d0f-87ca-4375-aaef-b639c7295552	1	f	Concede resistência 5 a corte, impacto, Morte e perfuração, mas torna o usuário vulnerável a dano balístico e de Energia.	PDF v1.1, p. 149
b27a6267-dc98-44bb-bbb7-52d5a3be1697	bca15d0f-87ca-4375-aaef-b639c7295552	1	f	Ação completa para matar uma pessoa morrendo e armazenar 1d8 PE; capacidade máxima 20 PE. Os PE armazenados podem ser usados após portar a adaga por pelo menos uma semana. Enquanto a porta, descanso é sempre ruim.	PDF v1.1, p. 149
a54e7348-9f3a-43ed-bc71-2e5a53ca3210	bca15d0f-87ca-4375-aaef-b639c7295552	1	f	Uma vez por rodada, enquanto empunhado, ação livre concede uma ação padrão adicional. Cada uso exige Vontade DT 15 + 5 por uso adicional no dia; em falha ainda recebe o benefício, envelhece 1d4 anos e não pode usar de novo naquele dia.	PDF v1.1, p. 149
901620e5-904d-4efd-ac78-7fe93c3c75f7	bca15d0f-87ca-4375-aaef-b639c7295552	1	f	Ação padrão em ferimento de até uma rodada recupera 6d8+20 PV. Em ferimento mais antigo, resultado par recupera 3d8+10 PV e resultado ímpar causa 3d8+10 de dano de Morte. Possui uma única ativação.	PDF v1.1, p. 149
89938177-68b2-4843-bc24-ed1741149714	bca15d0f-87ca-4375-aaef-b639c7295552	1	f	Ação de movimento focando um ser visível revela informação sobre sua morte. Contra Marcados ou criaturas informa a pior resistência entre Fortitude, Reflexos e Vontade e as vulnerabilidades do alvo.	PDF v1.1, p. 149
c6636b06-7dae-46c4-8a32-9062caf6320f	d855bb6c-9321-48db-8e24-05e58697a31d	1	f	Duas pessoas devem usar os anéis por 24 horas. Depois permanecem em ligação telepática enquanto os usam; testes de Vontade usam a melhor quantidade de dados e bônus entre as duas, mas dano mental e condições mentais ou de medo são compartilhados.	PDF v1.1, pp. 149-150
d8681053-5ab6-42d3-b6c7-909187aec931	d855bb6c-9321-48db-8e24-05e58697a31d	1	f	Ativar exige ação padrão e 1 PE; dura uma cena e emite luz com propriedades de Terceiro Olho. Criaturas de Sangue iluminadas priorizam atacar o usuário entre alvos na mesma categoria de alcance.	PDF v1.1, p. 150
aa72bf67-e439-49ce-95b6-8bbfb901efc1	d855bb6c-9321-48db-8e24-05e58697a31d	1	f	Concede resistência a Conhecimento 10. Ação de movimento e 2 PE permitem entrar em sombra adjacente e teleportar para outra sombra visível em alcance médio.	PDF v1.1, p. 150
0e06beed-b3b9-4499-ade6-f4fb86e4cd7a	d855bb6c-9321-48db-8e24-05e58697a31d	1	f	Ritual de uma hora vincula a munição a um ser conhecido. Contra esse alvo concede +10 no ataque, dobra a margem de ameaça e causa +6d12 de Conhecimento; enquanto a possui, sofre -2 em Defesa e ataques contra outros alvos.	PDF v1.1, p. 150
cf52e92a-2833-4477-bbb0-e20e3e07b1d2	d855bb6c-9321-48db-8e24-05e58697a31d	1	f	Ação padrão concede 5 PE temporários até o fim da cena. Cada uso exige Ocultismo DT 15 + 5 por uso adicional no mesmo dia; em falha o pergaminho se desfaz.	PDF v1.1, p. 150
58650147-9f8e-4b18-ac8e-b0cf7c70efbf	52779391-a501-4a9e-b780-684349da1c1c	1	f	Arma simples de fogo e uma mão, +2 em ataques, alcance curto, crítico x3 e sem munição. Em cada disparo rola 1d6: o resultado define o dano entre 2d4, 2d6, 2d8, 2d10, 2d12 ou 2d20.	PDF v1.1, p. 150
ff0e93b4-db09-4124-803e-21f4562385ef	52779391-a501-4a9e-b780-684349da1c1c	1	f	Ação padrão e 2 PE descarregam dispositivo eletrônico em alcance curto; quando carregada pode reenergizar um dispositivo descarregado. Cada uso exige Ocultismo DT 15 + 5 por uso adicional no dia; falha causa explosão de 12d6 de Energia em raio de 3m.	PDF v1.1, p. 150
\.


--
-- Data for Name: threat_size; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.threat_size (id, name, slug, occupied_space_m, natural_reach_m, stealth_modifier, maneuver_modifier, sort_order, source_ref) FROM stdin;
98ef82fb-71d8-4c60-8763-8b0b1892cccb	Minúsculo	minúsculo	1.50	1.50	5	-5	1	PDF v1.1, Tabela 7.1 p. 179
34570cb9-3b64-4e83-8b21-39aaa0532f11	Pequeno	pequeno	1.50	1.50	2	-2	2	PDF v1.1, Tabela 7.1 p. 179
c25003a0-3cdf-4156-b789-d80918ce3465	Médio	médio	1.50	1.50	0	0	3	PDF v1.1, Tabela 7.1 p. 179
ea840956-9fd0-4487-a074-4b50591a509a	Grande	grande	3.00	3.00	-2	2	4	PDF v1.1, Tabela 7.1 p. 179
049260d2-5264-4c5a-8f12-37002508b731	Enorme	enorme	4.50	4.50	-5	5	5	PDF v1.1, Tabela 7.1 p. 179
dc9e5b7e-13b4-4ffc-a650-2854e689f723	Colossal	colossal	9.00	9.00	-10	10	6	PDF v1.1, Tabela 7.1 p. 179
\.


--
-- Data for Name: threat; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.threat (character_id, being_type_id, challenge_value, size, disturbing_presence, senses, slug, size_id, source_ref, defense, hit_points, wounded_at, agility, strength, intellect, presence, vigor, perception_test, initiative_test, fortitude_test, reflexes_test, will_test, movement_text, presence_dt, presence_damage, presence_immune_nex, fear_enigma_summary, statblock_data) FROM stdin;
a2655898-407a-8e76-c06b-1f88c15aba65	97efe17b-1bb7-4446-97b8-897819f17e98	20	Médio	\N	Percepção O+5 | Iniciativa O+5	javaporco	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 289	14	35	17	1	2	0	1	3	O+5	O+5	3O+5	O+5	O	12m | 8	\N	\N	\N	\N	{"group": "Realidade", "source_page": 289, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
f5de5b9f-880b-44d7-f64a-63819147f4aa	97efe17b-1bb7-4446-97b8-897819f17e98	10	Médio	\N	Percepção O+5 | Iniciativa 2O+5	enxame-de-ratos	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 288	13	15	7	1	0	0	1	0	O+5	2O+5	O+5	O+5	O	9m | 6q, escalar/nadar 6m | 4q	\N	\N	\N	\N	{"group": "Realidade", "source_page": 288, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
42c8eb5b-7fda-8518-d251-45abb6239074	97efe17b-1bb7-4446-97b8-897819f17e98	10	Médio	\N	Percepção O+5 | Iniciativa O+5	enxame-de-abelhas	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 288	15	10	5	1	0	0	1	0	O+5	O+5	–2O	O+5	O	3m | 2, voo 9m | 6	\N	\N	\N	\N	{"group": "Realidade", "source_page": 288, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
d1122566-9223-4957-1667-52b39dfa85b7	97efe17b-1bb7-4446-97b8-897819f17e98	10	Médio	\N	Percepção O+10 | Iniciativa 2O+5	cao-de-guarda	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 288	14	12	6	2	2	0	1	2	O+10	2O+5	2O+5	2O+5	O	12m | 8	\N	\N	\N	\N	{"group": "Realidade", "source_page": 288, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
a04aeb3a-4937-0509-3603-feaa1790ef36	ccbfe321-1a7c-4fa1-b1f4-685a5ebaccb7	100	Médio	\N	Percepção 3O+15 | Iniciativa 2O+10	chefe-de-policia	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 287	25	105	52	2	3	2	3	3	3O+15	2O+10	3O+10	2O+10	3O+15	9m | 6	\N	\N	\N	\N	{"group": "Realidade", "source_page": 287, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
e6407482-d3e0-838d-0683-fa7173f8015c	ccbfe321-1a7c-4fa1-b1f4-685a5ebaccb7	60	Médio	\N	Percepção O+10 | Iniciativa 3O+15	policial-de-elite	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 287	27	40	20	3	3	1	1	3	O+10	3O+15	3O+10	3O+10	O+10	6m | 4q	\N	\N	\N	\N	{"group": "Realidade", "source_page": 287, "immunities_text": null, "resistances_text": "Balístico, corte, impacto e perfuração 5", "vulnerabilities_text": null}
53e7cc77-166b-4062-9521-4ebe729f086c	ccbfe321-1a7c-4fa1-b1f4-685a5ebaccb7	20	Médio	\N	Percepção O+5 | Iniciativa 2O+5	policial	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 287	19	15	7	2	2	1	1	2	O+5	2O+5	2O+5	2O+5	O	9m | 6q	\N	\N	\N	\N	{"group": "Realidade", "source_page": 287, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
5c2807af-f19e-54f2-27a2-22abbb0018eb	ccbfe321-1a7c-4fa1-b1f4-685a5ebaccb7	140	Médio	\N	Percepção 3O+10 | Iniciativa 2O+10	lider-de-culto	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 286	27	150	75	2	1	3	3	2	3O+10	2O+10	2O+10	2O+5	3O+15	9m | 6q	\N	\N	\N	\N	{"group": "Realidade", "source_page": 286, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
ddd48960-8422-2949-b599-893b178948ff	ccbfe321-1a7c-4fa1-b1f4-685a5ebaccb7	40	Médio	\N	Percepção 2O+5 | Iniciativa 2O+5	investido	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 286	17	35	17	2	1	2	2	1	2O+5	2O+5	O	2O	2O+5	9m | 6q	\N	\N	\N	\N	{"group": "Realidade", "source_page": 286, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
e2708871-e31f-4e67-dbba-e5962e66a3a5	ccbfe321-1a7c-4fa1-b1f4-685a5ebaccb7	20	Médio	\N	Percepção 2O+5 | Iniciativa O	iniciado	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 286	16	15	7	1	1	2	2	1	2O+5	O	O	O	2O+5	9m | 6	\N	\N	\N	\N	{"group": "Realidade", "source_page": 286, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
9e5601b2-bd2e-485a-ee50-8082f3a83a92	ccbfe321-1a7c-4fa1-b1f4-685a5ebaccb7	120	Médio	\N	Percepção 2O+10 | Iniciativa 3O+15	comandante-mercenario	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 285	29	145	72	3	3	2	2	3	2O+10	3O+15	3O+10	3O+10	2O+5	6m | 4	\N	\N	\N	\N	{"group": "Realidade", "source_page": 285, "immunities_text": null, "resistances_text": "Balístico, corte, impacto e perfuração 5", "vulnerabilities_text": null}
2f48e0be-c76c-6a21-2b44-5774b1103744	ccbfe321-1a7c-4fa1-b1f4-685a5ebaccb7	80	Médio	\N	Percepção 3O+10 | Iniciativa 4O+15	assassino	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 285	26	90	45	4	2	3	3	2	3O+10	4O+15	2O+5	4O+10	3O+10	9m | 6	\N	\N	\N	\N	{"group": "Realidade", "source_page": 285, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
6854df88-14b7-ca24-c1f7-31288fffdd87	ccbfe321-1a7c-4fa1-b1f4-685a5ebaccb7	40	Médio	\N	Percepção O+5 | Iniciativa 2O+10	soldado-de-aluguel	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 284	18	25	12	2	2	1	1	2	O+5	2O+10	2O+5	2O+5	O	9m | 6	\N	\N	\N	\N	{"group": "Realidade", "source_page": 284, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
bf633d83-4d78-4b53-2e47-316dfd0e1768	ccbfe321-1a7c-4fa1-b1f4-685a5ebaccb7	20	Médio	\N	Percepção O+5 | Iniciativa O+5	capanga	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 284	13	17	8	1	2	1	1	2	O+5	O+5	2O+5	O+5	O	9m | 6	\N	\N	\N	\N	{"group": "Realidade", "source_page": 284, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
cad9d205-0e8c-9d91-0142-7243852739f9	ccbfe321-1a7c-4fa1-b1f4-685a5ebaccb7	10	Médio	\N	Percepção O | Iniciativa 2O+5	bandido	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 284	14	8	4	2	2	1	1	1	O	2O+5	O	2O+5	O	9m | 6	\N	\N	\N	\N	{"group": "Realidade", "source_page": 284, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
f87384c2-4e60-56db-a5de-3d654357a796	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	320	Médio	DT 40 | 9d6 | NEX 95%+ imune	Percepção 4O+15 | Iniciativa 3O	degolificada	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 282	45	850	425	3	5	3	4	4	4O+15	3O	4O+20	3O+15	4O+25	6m | 4	40	9d6	95	A degolificada precisa ser confrontada com a causa de sua morte, de modo que não possa escapar desse confronto. Se for confrontada desta forma, ela perde sua imunidade a dano. PRESENÇA PERTURBADORA DT 40  9d6 mental  NEX 95%+ é imune SENTIDOS PERCEPÇÃO INICIATIVA 4O+15 3O Percepção às cegas DEFESA 45 FORTITUDE REFLEXOS VONTADE 4O+20 3O+15 4O+25 PONTOS DE VIDA 850 | 425 machucado IMUNIDADES Dano ATRIBUTOS AGI 3 FOR 5 INT 3 PRE 4 VIG 4 DESLOCAMENTO 6m | 4 CRIATURA DO MEDO A degolificada é imune a dano, até que se resolva o mistério da sua origem. ENERGIA  CONHECIMENTO  SANGUE  MORTE CRIATURA  MÉDIO AÇÕES	{"group": "Medo", "source_page": 282, "immunities_text": "Dano", "resistances_text": null, "vulnerabilities_text": null}
7c0fbcb9-f9cb-a886-2517-8bd5f4bcc597	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	380	Enorme	DT 40 | 10d6	Percepção 5O+25 | Iniciativa 4O+25	anjo	049260d2-5264-4c5a-8f12-37002508b731	PDF v1.1, p. 234	57	1111	555	4	5	5	5	5	5O+25	4O+25	5O+25	4O+25	5O+30	Voo 24m | 16	40	10d6	\N	Seres puros de Conhecimento, os anjos podem ser enganados por seu alinhamento de Justiça Perfeita. Um anjo que falhe em julgar corretamente pode cair e ser alcançado por mortais. Quando o Enigma de Medo do anjo for resolvido, ele perde sua resistência a dano, seu deslocamento de voo e sua habilidade Julgamento.	{"group": "Conhecimento", "source_page": 234, "immunities_text": "Condições de paralisia, dano e efeitos de Conhecimento", "resistances_text": "Dano 50", "vulnerabilities_text": "Sangue"}
c9a49ecf-895c-9dac-0185-2e23764358cd	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	200	Médio	DT 20 | 6d6	Percepção 4O+15 | Iniciativa 4O+15	viajante	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 274	34	360	180	4	2	3	4	2	4O+15	4O+15	2O+10	4O+15	4O+15	9m 6	20	6d6	\N	A única maneira de enxergar o viajante é usando dispositivos de captura de imagem para fotografá- lo. Capturar a sua existência em uma imagem sem que ele esteja de fato viajando através dela é o suficiente para distraí-lo momentaneamente, fazendo com que se torne visível por alguns segundos. Quando o Enigma de Medo do viajante for resolvido ele perde a habilidade Invisibilidade Permanente até o início do próximo turno do personagem que capturou sua imagem. VIAJANTE Uma criatura maligna e cruel, o viajante das Polaroids é um ser que distorce lentamente as memórias de um alvo, se transportando através de fotografias e consumindo o rosto de todos aqueles registrados nelas. Após gerar traumas e desespero o suficiente, o via- jante se manifesta fisicamente, causando amnésia temporária em sua presa para confundí-la e desestru- turá-la, diminuindo as suas chances de sobrevivência. Todas as fotografias que antes eram apenas rostos vazios se distorcem em sorrisos tétricos e macabros. O viajante é uma criatura bizarra, com um corpo esbranquiçado, membros alongados e uma cabeça com incontáveis rostos terríveis mesclados em expres- sões diferentes. Porém, ele é fisicamente invisível, e…	{"group": "Energia", "source_page": 274, "immunities_text": null, "resistances_text": "Balístico, corte e perfuração 10, Energia 20", "vulnerabilities_text": "Conhecimento"}
cab21581-a023-2e27-8178-fa3898890bd4	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	340	Médio	DT 40 | 10d6 | NEX 99%+ imune	Percepção 5O+25 | Iniciativa 4O+20	telopsia	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 271	48	560	280	4	2	3	5	2	5O+25	4O+20	2O+15	4O+20	5O+25	12m | 8	40	10d6	99	A única maneira teorizada de derrotar o telopsia é de alguma forma destruir a própria fita amaldiçoada que se manifestou na Realidade, mas para isso é necessário investigar suas vítimas para encontrá-la, um trabalho árduo considerando que ninguém parece conseguir lembrar do que fez com ela após assistí- la. Se a fita for destruída, o telopsia tem seus PV reduzidos a 0 e é também destruída. Caso contrário, mesmo que seja derrotado em combate, se o seu Enigma do Medo não tiver sido resolvido, será apenas uma questão de tempo até o telopsia retornar.	{"group": "Energia", "source_page": 271, "immunities_text": "Condições de paralisia", "resistances_text": "Balístico, corte, perfuração e Energia 20", "vulnerabilities_text": "Conhecimento"}
9d273d68-1267-1193-d4e4-d7aade51df78	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	360	Médio	DT 40 | 8d8	Percepção 5O+20 | Iniciativa 4O+25	tempestuoso	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 273	56	950	475	5	4	2	5	4	5O+20	4O+25	4O+20	5O+30	5O+25	24m | 12	40	8d8	\N	A única maneira de enxergar o viajante é usando dispositivos de captura de imagem para fotografá- lo. Capturar a sua existência em uma imagem sem que ele esteja de fato viajando através dela é o suficiente para distraí-lo momentaneamente, fazendo com que se torne visível por alguns segundos. Quando o Enigma de Medo do viajante for resolvido ele perde a habilidade Invisibilidade Permanente até o início do próximo turno do personagem que capturou sua imagem. VIAJANTE Uma criatura maligna e cruel, o viajante das Polaroids é um ser que distorce lentamente as memórias de um alvo, se transportando através de fotografias e consumindo o rosto de todos aqueles registrados nelas. Após gerar traumas e desespero o suficiente, o via- jante se manifesta fisicamente, causando amnésia temporária em sua presa para confundí-la e desestru- turá-la, diminuindo as suas chances de sobrevivência. Todas as fotografias que antes eram apenas rostos vazios se distorcem em sorrisos tétricos e macabros. O viajante é uma criatura bizarra, com um corpo esbranquiçado, membros alongados e uma cabeça com incontáveis rostos terríveis mesclados em expres- sões diferentes. Porém, ele é fisicamente invisível, e…	{"group": "Energia", "source_page": 273, "immunities_text": "Condições de paralisia", "resistances_text": "Balístico, corte, perfuração e Energia 20", "vulnerabilities_text": "Conhecimento"}
20f91d11-1834-d40f-02c1-8e8a0c81ee63	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	160	Médio	DT 25 | 4d8 | NEX 55%+ imune	Percepção 3O+10 | Iniciativa 3O+10	sukkalgir	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 269	34	220	110	3	2	3	3	2	3O+10	3O+10	2O+5	3O+10	3O+15	Voo 18m | 12	25	4d8	55	\N	{"group": "Energia", "source_page": 269, "immunities_text": "Dano balístico, de corte e de perfuração", "resistances_text": "Impacto e Energia 10", "vulnerabilities_text": "Conhecimento"}
7f48783f-86b6-c93c-962d-fbf5c9ccdb5b	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	40	Médio	DT 15 | 2d8 | NEX 30%+ imune	Percepção –2O | Iniciativa 4O+10	perturbado-de-energia	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 268	19	60	30	4	1	0	0	0	–2O	4O+10	–2O	4O+10	–2O	9m | 6	15	2d8	30	\N	{"group": "Energia", "source_page": 268, "immunities_text": null, "resistances_text": "Balístico, corte e perfuração 5, Energia 10", "vulnerabilities_text": "Conhecimento"}
22118520-6be3-b02f-f935-50333c06403e	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	240	Médio	DT 30 | 6d8 | NEX 75%+ imune	Percepção 4O+10 | Iniciativa 5O+15	anomiatico	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 263	41	600	300	5	3	1	4	3	4O+10	5O+15	3O+10	5O+20	4O+15	18m | 12	30	6d8	75	\N	{"group": "Energia", "source_page": 263, "immunities_text": null, "resistances_text": "Balístico, corte e perfuração 10, Energia 20", "vulnerabilities_text": "Conhecimento"}
d6ecb2e4-bd05-093f-d43f-26dca3d354bb	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	380	Médio	DT 45 | 9d8	Percepção — | Iniciativa —	anomalia	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 261	\N	1000	500	\N	\N	5	5	\N	—	—	5O+15	5O+15	5O+15	0m | 0	45	9d8	\N	A anomalia não deveria existir. Ela é o próprio caos colapsando com a Realidade, e não existe lógica para defini-la. A única forma de combater essa criatura é mergulhar na anomalia para entendê-la no Outro Lado. Quando o Enigma de Medo da anomalia for resolvido, ela se transforma em um ser ou objeto aleatório por 2d4 rodadas. Durante esse tempo, ela perde sua imunidade a dano e condições e usa as estatísticas do ser ou objeto, com exceção de seus PV.	{"group": "Energia", "source_page": 261, "immunities_text": "Dano e todas as condições", "resistances_text": null, "vulnerabilities_text": "Conhecimento"}
72b4164d-66cb-3f52-c4c8-8fcb403bba7d	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	120	Médio	DT 21 | 4d6 | NEX 50%+ imune	Percepção 2O+5 | Iniciativa 4O+10	anarquico-descontrolado	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 259	28	120	60	4	3	2	2	3	2O+5	4O+10	3O+10	4O+10	2O+5	12m | 8	21	4d6	50	\N	{"group": "Energia", "source_page": 259, "immunities_text": null, "resistances_text": "Balístico, corte e perfuração 10, Energia 20", "vulnerabilities_text": "Conhecimento"}
eeb94d35-292d-e7b1-8686-0a2ea8a0ee90	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	40	Médio	DT 15 | 3d6 | NEX 30%+ imune	Percepção 2O+5 | Iniciativa 4O+5	vulto	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 251	19	60	30	4	2	2	2	1	2O+5	4O+5	O	4O+5	2O+5	12m | 8	15	3d6	30	\N	{"group": "Conhecimento", "source_page": 251, "immunities_text": null, "resistances_text": "Balístico, corte e perfuração 5, Conhecimento 10", "vulnerabilities_text": "Sangue"}
04f6c70d-ccd0-6736-5a7e-8b4380e81ecc	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	360	Médio	DT 40 | 8d8	Percepção 5O+25 | Iniciativa 4O+20	silhueta	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 250	55	500	250	4	4	5	5	4	5O+25	4O+20	4O+20	4O+20	5O+25	12m | 8	40	8d8	\N	\N	{"group": "Conhecimento", "source_page": 250, "immunities_text": "Condições de paralisia, efeitos e dano de Conhecimento, manobras de combate", "resistances_text": "Dano 30", "vulnerabilities_text": "Sangue"}
63b121c2-516a-f562-feac-b6886de8f29f	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	180	Médio	DT 25 | 6d6 | NEX 60%+ imune	Percepção 3O+15 | Iniciativa 4O+15	rastejador-sombrio	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 248	41	330	165	4	3	3	3	3	3O+15	4O+15	3O+15	4O+15	3O+10	12m | 8	25	6d6	60	\N	{"group": "Conhecimento", "source_page": 248, "immunities_text": null, "resistances_text": "Balístico, corte e impacto 10, Conhecimento 20", "vulnerabilities_text": "Sangue"}
4c29680f-753d-b300-6316-69ab128fbd3f	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	60	Médio	DT 20 | 2d6 | NEX 35%+ imune	Percepção 4O | Iniciativa O	parasita-de-culpa	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 246	15	90	45	2	0	4	4	1	4O	O	O+10	2O+10	4O+10	6m | 4	20	2d6	35	Para derrotar o parasita de culpa, os personagens devem perceber que estão vivendo um sonho compartilhado, e identificar qual personagem dentro do sonho é o hospedeiro do parasita. Após descobrir isso, o hospedeiro deve confrontar as manifestações e derrotá-las dentro do sonho, sozinho. Um sonho compartilhado é uma sequência de cenas que ocorrem na mente dos personagens. Com exceção dos próprios personagens, tudo que existe no sonho é um construto de Conhecimento. Enquanto estiverem dentro do sonho, os agentes agem normalmente, conforme o tipo de cena que o sonho está simulando. O mestre determina como os personagens podem descobrir que estão em um sonho, e quais ameaças enfrentarão nele.	{"group": "Conhecimento", "source_page": 246, "immunities_text": "Dano (exceto causado pelo hospedeiro)", "resistances_text": null, "vulnerabilities_text": null}
edbeef88-be85-94ce-b3af-00e5692c338e	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	220	Médio	DT 30 | 7d6 | NEX 70%+ imune	Percepção 3O+15 | Iniciativa 4O+15	o-espreitador	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 238	34	500	250	4	2	3	3	2	3O+15	4O+15	2O+10	4O+15	3O+15	12m | 8	30	7d6	70	Para derrotar o espreitador, é necessário que o alvo que está sendo espreitado o atraia para fora de seu esconderijo simulando estar dormindo na escuridão. Especificamente no horário das 2h11, a criatura sai de seu esconderijo para espreitar suas vítimas de perto, caso sinta que o ambiente é seguro. Quando isso acontece, a porta do esconderijo da qual saiu deve ser fechada antes que o espreitador consiga retornar, deixando-o encurralado e obrigado a combater os agentes ou tentar fugir para outra fresta. Quando encurralado, ele perde sua imunidade a dano. ESPREITADOR CONHECIMENTO  CRIATURA  MÉDIO PRESENÇA PERTURBADORA DT 30  7d6 mental  NEX 70%+ é imune SENTIDOS PERCEPÇÃO INICIATIVA 3O+15 4O+15 Percepção às cegas DEFESA 34 FORTITUDE REFLEXOS VONTADE 2O+10 4O+15 3O+15 PONTOS DE VIDA 500 | 250 machucado IMUNIDADES Dano VULNERABILIDADES Sangue ATRIBUTOS AGI 4 FOR 2 INT 3 PRE 3 VIG 2 PERÍCIAS FURTIVIDADE 4O+20 DESLOCAMENTO 12m | 8 VD 220 AÇÕES	{"group": "Conhecimento", "source_page": 238, "immunities_text": "Dano", "resistances_text": null, "vulnerabilities_text": "Sangue"}
368972da-2308-bf04-7103-bca0de4932fd	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	100	Médio	DT 20 | 4d6 | NEX 45%+ imune	Percepção 2O+10 | Iniciativa 2O+10	lembrado	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 241	22	180	90	2	2	4	2	2	2O+10	2O+10	2O+5	2O	2O+10	9m | 6	20	4d6	45	\N	{"group": "Conhecimento", "source_page": 241, "immunities_text": null, "resistances_text": "Balístico, corte e impacto 10, Conhecimento 20", "vulnerabilities_text": "Sangue"}
189034de-8f01-36a7-87c6-1126d93d3450	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	20	Médio	DT 14 | 1d6 | NEX 25%+ imune	Percepção 2O+5 | Iniciativa O+5	existido	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 240	13	36	18	1	1	4	2	2	2O+5	O+5	2O	O	2O+10	9m | 6	14	1d6	25	\N	{"group": "Conhecimento", "source_page": 240, "immunities_text": null, "resistances_text": "Balístico, corte e impacto 5, Conhecimento 10", "vulnerabilities_text": "Sangue"}
99c9e528-e4ec-2c7b-da9c-1fb4cece6b74	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	40	Médio	DT 15 | 3d6 | NEX 30%+ imune	Percepção O+5 | Iniciativa 4O+5	succ	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 227	20	65	32	4	2	0	1	1	O+5	4O+5	O	4O+10	O+5	12m | 8	15	3d6	30	\N	{"group": "Morte", "source_page": 227, "immunities_text": null, "resistances_text": "Corte, impacto e perfuração 5, Morte 10", "vulnerabilities_text": "Energia"}
a7e35038-1680-908a-be3a-60ad1debd522	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	360	Médio	DT 40 | 8d8	Percepção 5O+20 | Iniciativa 5O+25	sempiternal	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 226	53	990	445	5	5	4	5	4	5O+20	5O+25	4O+20	5O+30	5O+25	12m | 8	40	8d8	\N	\N	{"group": "Morte", "source_page": 226, "immunities_text": "Condições lento e de paralisia, e dano e efeitos de Morte", "resistances_text": "Corte, impacto e perfuração 20", "vulnerabilities_text": "Energia"}
af9ebb2d-0f65-c58e-27bd-dbdb8f62445c	6e50b6e6-58fc-4807-b48f-7c1cb2f10b47	400	Minúsculo	DT 45 | 10d8	Percepção 6O+35 | Iniciativa 4O+25	mascara-do-desespero	98ef82fb-71d8-4c60-8763-8b0b1892cccb	PDF v1.1, p. 254	55	1200	600	4	4	6	6	5	6O+35	4O+25	5O+35	4O+25	6O+35	Voo 12m | 8	45	10d8	\N	\N	{"group": "Conhecimento", "source_page": 254, "immunities_text": "Condições, dano", "resistances_text": null, "vulnerabilities_text": "Sangue"}
3587d753-20e6-0197-2b96-f948f5ca6bc9	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	340	Enorme	DT 35 | 10d6 | NEX 99%+ imune	Percepção 3O+20 | Iniciativa 4O+15	kerberos	049260d2-5264-4c5a-8f12-37002508b731	PDF v1.1, p. 194	46	1150	575	4	5	0	3	5	3O+20	4O+15	5O+25	4O+20	3O+15	18m | 12	35	10d6	99	\N	{"group": "Sangue", "source_page": 194, "immunities_text": null, "resistances_text": "Balístico, impacto, perfuração e Sangue 20", "vulnerabilities_text": "Morte"}
0234288f-2f0c-872d-cbae-239b25da9cc7	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	60	Enorme	DT 20 | 3d6 | NEX 35%+ imune	Percepção 2O+10 | Iniciativa 2O	dama-de-sangue	049260d2-5264-4c5a-8f12-37002508b731	PDF v1.1, p. 190	20	105	52	2	3	1	2	2	2O+10	2O	2O+10	2O+5	2O	12m | 8	20	3d6	35	A dama de sangue é uma criatura poderosa, invocada através de um ritual que envolve o sacrifício de sete pessoas para o desabrochar de sete flores. Porém, cada flor possui uma fraqueza, conforme descrito nas habilidades ao lado.	{"group": "Sangue", "source_page": 190, "immunities_text": null, "resistances_text": "Balístico, impacto e perfuração 10, Sangue 20", "vulnerabilities_text": "Morte"}
5e226c8d-e09f-ddc9-7963-811bd3cfa346	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	240	Médio	DT 30 | 6d8 | NEX 75%+ imune	Percepção 3O+10 | Iniciativa 5O+15	mumia-xipofaga	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 221	35	400	200	5	4	2	3	4	3O+10	5O+15	4O+15	5O+15	3O+10	9m | 6	30	6d8	75	Para enfrentar um nidere, é preciso primeiro encontrar seu covil, que muitas vezes é formado por cavernas naturais nas profundezas da floresta, enquanto ele não estiver lá. Se o nidere enfrentar os personagens dentro do seu covil, a afinidade com seu lar labiríntico o tornará ainda mais mortal. Para acessar a origem de sua manifestação, é primeiro necessário entender a lógica distorcida por trás dos padrões misteriosos dos restos ósseos de suas vítimas deixados pendurados no lar pelo nidere. Estes ossos formam uma espécie de engenhoca bizarra criada pela própria criatura. É como se a criatura preparasse uma armadilha para atrair e distrair seus caçadores, com uma lógica que sempre tem uma conexão com as identidades das vítimas que devora, como um desafio. Quando a origem for destruída, a criatura entrará em uma fúria incontrolável. Ela sofre –10 na Defesa e –OO em testes de resistência, e perde suas habilidades Regeneração Acelerada e Senso de Direção Perfeito, o que a torna suscetível a cair em armadilhas que seriam facilmente evitadas em seu estado original, possibilitando a sua captura e morte.	{"group": "Morte", "source_page": 221, "immunities_text": null, "resistances_text": "Corte, impacto e perfuração 10, Morte 20", "vulnerabilities_text": "Energia, fogo"}
48f329fb-339b-2f3c-ab5e-69c01707ec0e	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	20	Médio	DT 14 | 2d4 | NEX 25%+ imune	Percepção O | Iniciativa 2O	esqueleto-de-lodo	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 217	14	40	20	2	2	0	1	1	O	2O	2O	2O+5	O	6m | 4	14	2d4	25	\N	{"group": "Morte", "source_page": 217, "immunities_text": null, "resistances_text": "Corte, impacto e perfuração 5, Morte 10", "vulnerabilities_text": "Energia"}
0bcc85f7-b3dd-c1dd-d8b9-95c8f01a8dda	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	160	Médio	DT 25 | 4d8 | NEX 55%+ imune	Percepção 2O+10 | Iniciativa 4O+10	escutado	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 216	29	290	145	4	3	1	2	3	2O+10	4O+10	3O+10	4O+10	2O+5	12m | 8	25	4d8	55	Tocar a melodia do escutado exige gastar uma ação padrão e passar em um teste de Artes (DT 25) por rodada, ou ligar um aparelho como um rádio ou celular que possua essa música. Enquanto a melodia estiver tocando, o escutado ficará se multiplicando. Porém, se escutar a melodia por 4 rodadas ininterruptas, perde sua imunidade a dano até o fim da cena e pode enfim ser derrotado. Como o escutado precisa escutar a melodia por 4 rodadas, terá a chance de se multiplicar quatro vezes. Isso significa que, se nenhuma cópia for destruída, no fim da quarta rodada haverá 16 criaturas (o original mais 15 cópias)! Para ter alguma chance de sobrevivência, os agentes devem tentar destruir as cópias enquanto tocam a melodia, para impedir que elas também se multipliquem — e, obviamente, parar de tocar a música assim que as 4 rodadas passarem e o escutado perder sua imunidade a dano. MULTIPLICAÇÃO MELÓDICA No início do turno do escutado, se ele estiver ouvindo a melodia de sua criação, manifesta uma cópia sua em um ponto a sua escolha em alcance curto. A cópia possui 145 PV, não tem imunidade a dano e age junto com o escutado original, a partir do próximo turno dele. As cópias também possuem essa…	{"group": "Morte", "source_page": 216, "immunities_text": "Dano", "resistances_text": null, "vulnerabilities_text": null}
40b5007f-2005-de03-e7f4-64783809fd47	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	120	Médio	DT 20 | 4d6 | NEX 50%+ imune	Percepção O+10 | Iniciativa 3O+10	enraizado	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 214	28	140	70	3	3	1	1	3	O+10	3O+10	3O+10	3O+10	O+5	9m | 6	20	4d6	50	\N	{"group": "Morte", "source_page": 214, "immunities_text": null, "resistances_text": "Corte, impacto e perfuração 10, Morte 20", "vulnerabilities_text": "Energia"}
981e0906-addf-ca9b-c5e8-82659e6c64cf	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	200	Médio	DT 30 | 6d6 | NEX 65%+ imune	Percepção 3O+15 | Iniciativa 4O+15	carnical	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 211	38	400	200	4	4	3	3	3	3O+15	4O+15	3O+15	4O+15	3O+15	12m | 8	30	6d6	65	\N	{"group": "Morte", "source_page": 211, "immunities_text": "Dano balístico", "resistances_text": "Corte, impacto e perfuração 10, Morte 20", "vulnerabilities_text": "Energia"}
2faad71f-e963-0d04-806c-e49455fac533	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	20	Médio	DT 14 | 2d6 | NEX 25%+ imune	Percepção –2O | Iniciativa 3O+5	anarquico	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 257	21	30	15	3	2	0	0	1	–2O	3O+5	O	3O+10	–2O	9m | 6	14	2d6	25	\N	{"group": "Energia", "source_page": 257, "immunities_text": null, "resistances_text": "Energia 5", "vulnerabilities_text": "Conhecimento"}
67052271-cab5-1982-3cfc-2fff9fcf2c74	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	280	Médio	DT 35 | 8d6 | NEX 85%+ imune	Percepção 5O+15 | Iniciativa 3O+15	marionete	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 219	40	700	350	3	5	1	5	2	5O+15	3O+15	2O+10	3O+15	5O+20	6m | 4	35	8d6	85	\N	{"group": "Morte", "source_page": 219, "immunities_text": null, "resistances_text": "Corte, impacto, perfuração e Morte 20", "vulnerabilities_text": "Energia"}
cf30b492-cace-69d4-8b39-8f091caf2499	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	20	Médio	DT 15 | 2d6 | NEX 25%+ imune	Percepção O+10 | Iniciativa 2O+5	zumbi-de-sangue	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 202	17	45	22	2	2	0	1	2	O+10	2O+5	2O+5	2O+5	O+5	9m | 6	15	2d6	25	\N	{"group": "Sangue", "source_page": 202, "immunities_text": null, "resistances_text": "Balístico, impacto e perfuração 5, Sangue 10", "vulnerabilities_text": "Morte"}
e13d6f64-cbd7-8f33-a624-429f6f1ea8f8	97efe17b-1bb7-4446-97b8-897819f17e98	40	Grande	\N	Percepção O+10 | Iniciativa 3O+10	onca-pintada	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 289	16	55	27	3	3	0	1	2	O+10	3O+10	2O+5	3O+5	O+5	12m | 8q, escalar/nadar 6m | 4q	\N	\N	\N	\N	{"group": "Realidade", "source_page": 289, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
c1fe7c0a-1581-4610-0326-6176fca42f03	97efe17b-1bb7-4446-97b8-897819f17e98	40	Grande	\N	Percepção O+5 | Iniciativa O+5	jacare	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 288	16	40	20	1	3	0	1	2	O+5	O+5	2O+5	O+5	O	6m | 4q, nadar 9m | 6q	\N	\N	\N	\N	{"group": "Realidade", "source_page": 288, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
68da4a77-b1ae-6eef-aa7d-2d68a617bc8a	97efe17b-1bb7-4446-97b8-897819f17e98	40	Grande	\N	Percepção O+5 | Iniciativa 2O+5	sucuri	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 289	16	68	34	2	3	0	1	3	O+5	2O+5	3O+5	2O+5	O	6m | 4q, escalar/nadar 9m | 6q	\N	\N	\N	\N	{"group": "Realidade", "source_page": 289, "immunities_text": null, "resistances_text": null, "vulnerabilities_text": null}
15b07f11-8cdc-d86d-eebd-b745d86cb108	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	260	Grande	DT 35 | 8d6 | NEX 80%+ imune	Percepção 5O+15 | Iniciativa O	ocioso	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 244	37	390	195	1	5	1	5	3	5O+15	O	3O+15	O	5O+20	Voo 0m | 0	35	8d6	80	\N	{"group": "Conhecimento", "source_page": 244, "immunities_text": null, "resistances_text": "Balístico, corte, impacto e Conhecimento 20", "vulnerabilities_text": "Sangue"}
35167a4a-1da4-3662-c53c-1cc057cd8a9d	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	340	Grande	DT 40 | 10d6 | NEX 99%+ imune	Percepção 5O+25 | Iniciativa 3O+20	estrangeiro	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 243	50	750	375	3	5	5	5	3	5O+25	3O+20	3O+15	3O+20	5O+25	Voo 15m | 10	40	10d6	99	As intenções do Estrangeiro são complexas e devem ser decifradas para que ele possa ser derrotado. Investigar os sinais deixados pela criatura e aprender a entender sua linguagem e suas mensagens crípticas é a única forma de tentar se comunicar com esse ser e compreender a maneira de utilizar suas tecnologias paranormais para derrotá-lo. Um Estrangeiro cujas intenções sejam decifradas perde sua imunidade a dano (mas permanece imune a dano de Conhecimento) e não pode usar sua ação Incubar. 243 243 ESTRANGEIRO CONHECIMENTO ENERGIA   CRIATURA  GRANDE PRESENÇA PERTURBADORA DT 40  10d6 mental  NEX 99%+ é imune SENTIDOS PERCEPÇÃO INICIATIVA 5O+25 3O+20 Percepção às cegas DEFESA 50 FORTITUDE REFLEXOS VONTADE 3O+15 3O+20 5O+25 PONTOS DE VIDA 750 | 375 machucado IMUNIDADES Dano VULNERABILIDADES Sangue ATRIBUTOS AGI 3 FOR 5 INT 5 PRE 5 VIG 3 PERÍCIAS CIÊNCIA OCULTISMO FURTIVIDADE 5O+20 5O+20 3O+20 DESLOCAMENTO Voo 15m | 10 AÇÕES	{"group": "Conhecimento", "source_page": 243, "immunities_text": "Dano", "resistances_text": null, "vulnerabilities_text": "Sangue"}
25556b0f-1ee2-f31a-5f84-21662ea3eeca	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	300	Grande	DT 35 | 7d8 | NEX 90%+ imune	Percepção 5O+20 | Iniciativa 5O+20	bicho-papao	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 237	41	750	375	5	4	3	5	4	5O+20	5O+20	4O+15	5O+25	5O+20	15m | 10	35	7d8	90	Para derrotar o espreitador, é necessário que o alvo que está sendo espreitado o atraia para fora de seu esconderijo simulando estar dormindo na escuridão. Especificamente no horário das 2h11, a criatura sai de seu esconderijo para espreitar suas vítimas de perto, caso sinta que o ambiente é seguro. Quando isso acontece, a porta do esconderijo da qual saiu deve ser fechada antes que o espreitador consiga retornar, deixando-o encurralado e obrigado a combater os agentes ou tentar fugir para outra fresta. Quando encurralado, ele perde sua imunidade a dano. ESPREITADOR CONHECIMENTO  CRIATURA  MÉDIO PRESENÇA PERTURBADORA DT 30  7d6 mental  NEX 70%+ é imune SENTIDOS PERCEPÇÃO INICIATIVA 3O+15 4O+15 Percepção às cegas DEFESA 34 FORTITUDE REFLEXOS VONTADE 2O+10 4O+15 3O+15 PONTOS DE VIDA 500 | 250 machucado IMUNIDADES Dano VULNERABILIDADES Sangue ATRIBUTOS AGI 4 FOR 2 INT 3 PRE 3 VIG 2 PERÍCIAS FURTIVIDADE 4O+20 DESLOCAMENTO 12m | 8 VD 220 AÇÕES	{"group": "Conhecimento", "source_page": 237, "immunities_text": null, "resistances_text": "Balístico, corte, impacto e Conhecimento 20", "vulnerabilities_text": "Sangue"}
37785bcb-c312-1207-fa57-7c2553052220	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	320	Grande	DT 35 | 8d6 | NEX 95%+ imune	Percepção 4O+25 | Iniciativa 5O+25	nidere	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 224	50	800	400	5	5	3	4	5	4O+25	5O+25	5O+25	5O+25	4O+15	normal sem penalidade em Furtividade.	35	8d6	95	\N	{"group": "Morte", "source_page": 224, "immunities_text": null, "resistances_text": "Corte, impacto, perfuração e Morte 20", "vulnerabilities_text": "Energia"}
3e733982-0435-ca3a-40e2-20e2ac8d5195	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	380	Grande	DT 45 | 9d8	Percepção 5O+20 | Iniciativa 5O+20	ceifador-espiral	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 213	58	999	499	5	5	5	5	5	5O+20	5O+20	5O+25	5O+25	5O+25	15m | 10	45	9d8	\N	\N	{"group": "Morte", "source_page": 213, "immunities_text": "Condições de paralisia e lento, efeitos e dano de Morte", "resistances_text": "Dano 50", "vulnerabilities_text": "Energia"}
600edb81-50a4-7ce3-bd94-7597458ec444	6e50b6e6-58fc-4807-b48f-7c1cb2f10b47	400	Médio	DT 45 | 10d8	Percepção 6O+25 | Iniciativa 7O+35	o-anfitriao	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 278-279	59	1413	706	7	5	6	6	5	6O+25	7O+35	5O+25	7O+35	6O+25	12m | 8	45	10d8	\N	O Anfitrião é a personificação do caos e da irracionalidade, capaz de transformar tudo que toca de forma abstrata e incompreensível. A única maneira de possivelmente enfrentá-lo de forma justa é sob a proteção soberana do Equilíbrio. Isso é algo que apenas a manifestação que rege as correntes da Realidade, a Máscara do Desespero, pode oferecer.	{"group": "Energia", "source_page": 278, "immunities_text": "Condições de paralisia, dano, dano e efeitos de Energia", "resistances_text": null, "vulnerabilities_text": "Conhecimento"}
e247cdc1-d609-fa24-f339-7adb397a6ec7	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	220	Colossal	DT 30 | 7d6 | NEX 70%+ imune	Percepção O+15 | Iniciativa 2O+10	tita-de-sangue	dc9e5b7e-13b4-4ffc-a650-2854e689f723	PDF v1.1, p. 201	35	550	275	2	5	1	1	4	O+15	2O+10	4O+15	2O+10	O+10	12m | 8	30	7d6	70	\N	{"group": "Sangue", "source_page": 201, "immunities_text": null, "resistances_text": "Balístico, impacto, perfuração e Sangue 20", "vulnerabilities_text": "Morte"}
e4866d22-2413-8a10-dc2f-30681c33a483	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	80	Grande	DT 20 | 4d6 | NEX 40%+ imune	Percepção O+10 | Iniciativa 3O+10	aracnasita	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 209	23	140	70	3	2	1	1	2	O+10	3O+10	2O+5	3O+10	O+5	12m | 8	20	4d6	40	A aracnasita se forma a partir de uma aranha que entra em contato com o lodo da Morte através de um símbolo poderoso e cresce quando captura um ser humano para parasitar. Por isso, ela continua a manifestar esse lodo por todo seu corpo e guarda uma grande quantidade em seu abdômen, onde fica a vítima que está sendo parasitada. O lodo serve como uma proteção paranormal e faz com que seu corpo seja impossível de ser ferido. Ainda assim, existe uma forma de derrotá-la. O lodo de Morte em seu corpo procura fugir do fogo e do calor, movimentando-se lentamente para longe da fonte quente. Caso sofra dano de fogo, a Aracnasita perde sua imunidade a dano até o início do seu próximo turno. 209 ARACNASITA MORTE  CRIATURA  GRANDE PRESENÇA PERTURBADORA DT 20  4d6 mental  NEX 40%+ é imune SENTIDOS PERCEPÇÃO INICIATIVA O+10 3O+10 Percepção às cegas DEFESA 23 FORTITUDE REFLEXOS VONTADE 2O+5 3O+10 O+5 PONTOS DE VIDA 140 | 70 machucado IMUNIDADES Dano VULNERABILIDADES Energia ATRIBUTOS AGI 3 FOR 2 INT 1 PRE 1 VIG 2 PERÍCIAS FURTIVIDADE 3O+8 DESLOCAMENTO 12m | 8 PERCEPÇÃO TÁTIL A aracnasita percebe tudo que está em contato com sua teia. Ela ignora penalidades por visão ou condições de sentidos…	{"group": "Morte", "source_page": 209, "immunities_text": "Dano", "resistances_text": null, "vulnerabilities_text": "Energia"}
d4da78e2-01d5-3a2c-cb04-bc56d7df0a5c	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	100	Grande	DT 20 | 4d6 | NEX 45%+ imune	Percepção 2O+10 | Iniciativa 2O+15	zumbi-de-sangue-bestial	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 203	23	200	100	2	3	0	2	3	2O+10	2O+15	3O+10	2O+5	2O+5	12m | 8	20	4d6	45	\N	{"group": "Sangue", "source_page": 203, "immunities_text": null, "resistances_text": "Balístico, impacto e perfuração 5, Sangue 10", "vulnerabilities_text": "Morte"}
dc030186-e4b0-6b26-a3eb-cdb5e2980571	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	300	Grande	DT 35 | 7d8 | NEX 90%+ imune	Percepção 3O+10 | Iniciativa 4O+15	carente	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 188	40	700	350	4	4	2	3	4	3O+10	4O+15	4O+25	4O+25	3O+15	12m | 8	35	7d8	90	\N	{"group": "Sangue", "source_page": 188, "immunities_text": null, "resistances_text": "Balístico, impacto, perfuração e Sangue 20", "vulnerabilities_text": "Morte"}
553a94fb-382c-69c5-eac0-dfb12b2665bb	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	140	Grande	DT 25 | 4d8 | NEX 50%+ imune	Percepção 2O+5 | Iniciativa 4O+10	mulher-afogada	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 199	28	240	120	4	3	2	2	3	2O+5	4O+10	3O+10	4O+10	2O+5	9m 6	25	4d8	50	\N	{"group": "Sangue", "source_page": 199, "immunities_text": null, "resistances_text": "Balístico, Energia, impacto e perfuração 10, Sangue 20", "vulnerabilities_text": "Morte"}
0f60fed6-a659-b802-3fb1-8f53d4278aaa	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	280	Grande	DT 35 | 8d6 | NEX 80%+ imune	Percepção 3O+20 | Iniciativa 4O+15	minotauro	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 197	44	750	375	4	5	1	3	5	3O+20	4O+15	5O+20	4O+15	3O+10	12m | 8	35	8d6	80	Quando a mulher afogada assombra um local, todas as fontes de água se tornam armadilhas potenciais: torneiras, canos, privadas, chuveiros... Tudo que estiver conectado a um sistema hidráulico será um possível “ponto de invocação” da criatura e, caso um personagem se aproxime de um desses pontos, ela pode se manifestar em forma física com seu líquido de Sangue, agarrando esse personagem e tentando arrastá-lo para dentro dos canos onde o devorará lentamente. Tentar enfrentar a mulher afogada diretamente é inútil, já que ela consegue se mover livremente por dentro dos encanamentos e se recuperar de seus ferimentos caso seja atacada. A única maneira de derrotá-la é bloquear todas as saídas de água e fechar o registro hidráulico do local, e então abrir todas as torneiras, forçando a sua manifestação física e a deixando sem lugar para fugir caso esteja próxima de ser derrotada.	{"group": "Sangue", "source_page": 197, "immunities_text": null, "resistances_text": "Balístico, impacto, perfuração e Sangue 20", "vulnerabilities_text": "Morte"}
64b81aec-4e03-2fca-94e7-851dbd04b7a0	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	180	Grande	DT 25 | 6d6 | NEX 60%+ imune	Percepção 2O+10 | Iniciativa 2O+10	enpap-x	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 193	36	360	180	2	4	1	2	3	2O+10	2O+10	3O+15	2O+15	2O+10	12m | 8	25	6d6	60	\N	{"group": "Sangue", "source_page": 193, "immunities_text": null, "resistances_text": "Balístico, impacto e perfuração 10, Sangue 20", "vulnerabilities_text": "Morte"}
e2be0bb4-7c11-800b-ce51-7c9de1342c43	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	40	Grande	DT 15 | 3d6 | NEX 30%+ imune	Percepção O+5 | Iniciativa O	aberracao-de-carne	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 182	19	70	35	1	3	0	1	3	O+5	O	3O+10	O	O	9m | 6	15	3d6	30	\N	{"group": "Sangue", "source_page": 182, "immunities_text": null, "resistances_text": "Balístico, impacto, perfuração 5, Sangue 10", "vulnerabilities_text": "Morte"}
4686e4e2-c047-5691-fbc4-11eb224493eb	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	280	Enorme	DT 35 | 8d6 | NEX 85%+ imune	Percepção O+10 | Iniciativa 3O+15	infecticidio	049260d2-5264-4c5a-8f12-37002508b731	PDF v1.1, p. 267	25	600	300	3	5	1	1	5	O+10	3O+15	5O+20	3O +15	O+15	9m | 6	35	8d6	85	\N	{"group": "Energia", "source_page": 267, "immunities_text": null, "resistances_text": "Balístico, corte, perfuração e Energia 20", "vulnerabilities_text": "Conhecimento"}
e7ff9a66-e094-d347-aeb8-11e733c4a6df	6e50b6e6-58fc-4807-b48f-7c1cb2f10b47	400	Médio	DT 45 | 10d8	Percepção 6O+25 | Iniciativa 6O+35	o-diabo	c25003a0-3cdf-4156-b789-d80918ce3465	PDF v1.1, p. 205-207	66	1666	833	6	6	6	6	6	6O+25	6O+35	6O+35	6O+35	6O+35	18m | 12	45	10d8	\N	Ninguém sabe como derrotar o Diabo. Registros antigos falam sobre símbolos sagrados que afastariam a Besta, mas nada parece funcionar de verdade. Se existe uma forma de derrotar essa criatura, esse é um segredo muito bem guardado. Sabe-se, entretanto, que a Morte é a entidade opressora do Sangue. Talvez a resposta não esteja no Sangue escarlate, mas sim no lodo da Morte. Seria uma manifestação de Morte com força equivalente ao Diabo a chave para derrotá-lo? Quando o Enigma de Medo do Diabo for resolvido ele perde sua imunidade a dano seus bônus de testes de resistência são reduzidos para +25.	{"group": "Sangue", "source_page": 206, "immunities_text": "Condições de atordoamento e paralisia, dano, dano e efeitos de Sangue", "resistances_text": "Balístico, impacto e perfuração 20", "vulnerabilities_text": "Morte"}
0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	6e50b6e6-58fc-4807-b48f-7c1cb2f10b47	400	Grande	DT 45 | 10d8	Percepção 5O+30 | Iniciativa 6O+30	o-deus-da-morte	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 230	60	2000	1000	6	6	5	5	7	5O+30	6O+30	7O+35	6O+35	5O+35	15m | 10	45	10d8	\N	\N	{"group": "Morte", "source_page": 230, "immunities_text": "Condições de atordoamento e paralisia, dano e efeitos de Morte", "resistances_text": "Corte, impacto e perfuração 20", "vulnerabilities_text": "Energia"}
b55d1509-2803-fc09-cd9a-66772751e758	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	80	Grande	DT 15 | 2d6 | NEX 40%+ imune	Percepção 2O+5 | Iniciativa 2O+10	ciborgue	ea840956-9fd0-4487-a074-4b50591a509a	PDF v1.1, p. 265	25	160	80	3	3	2	2	3	2O+5	2O+10	3O+10	3O+5	2O	9m | 6	15	2d6	40	O Ciborgue possui quatro estados de combate, cada um com uma fraqueza específica. Uma fraqueza só pode ser resolvida enquanto o estado correspondente estiver ativo. Ao perder todos os estados, o Ciborgue se desativa: sua Defesa cai para 10 e seu deslocamento para 0m.	{"group": "Energia", "source_page": 265, "immunities_text": "Condições de paralisia", "resistances_text": "Balístico, corte e perfuração 10, Energia 20", "vulnerabilities_text": "Conhecimento"}
2fd41391-37dd-20d2-871e-cb71f4ebb278	67fc1e4b-2f6c-42e1-8dee-170f6c4c806f	380	Colossal	DT 45 | 9d8	Percepção 4O+20 | Iniciativa 4O+20	aniquilacao	dc9e5b7e-13b4-4ffc-a650-2854e689f723	PDF v1.1, p. 186	58	1200	600	4	5	3	4	5	4O+20	4O+20	5O+30	4O+25	4O+20	15m | 10	45	9d8	\N	O Enigma de Medo da Aniquilação é desconhecido. Quando ele for resolvido, a Aniquilação perde sua resistência a dano e sua habilidade Tempestade de Espinhos.	{"group": "Sangue", "source_page": 186, "immunities_text": null, "resistances_text": "Dano 50", "vulnerabilities_text": "Morte"}
\.


--
-- Data for Name: threat_ability; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.threat_ability (id, threat_id, name, effect_summary, sort_order, source_ref) FROM stdin;
229956b0-97a9-4ac6-83ea-cce613068e63	5c2807af-f19e-54f2-27a2-22abbb0018eb	CONJURADOR	Escolhe dois rituais de 1º, dois de 2º e dois de 3º círculo de até dois elementos. Conjura sem pagar o custo de PE, até o limite de 10 PE por conjuração; DT 25.	1	PDF v1.1, p. 286
5244375f-a2ee-4f76-a3ad-3b7adcd8df34	ddd48960-8422-2949-b599-893b178948ff	CONJURADOR	Escolhe dois rituais de 1º círculo e dois de 2º círculo de até dois elementos. Conjura sem pagar o custo de PE, até o limite de 5 PE por conjuração; DT 17.	1	PDF v1.1, p. 286
8fcae388-42a1-4cf1-8706-862ca422bb77	e2708871-e31f-4e67-dbba-e5962e66a3a5	CONJURADOR	Escolhe dois rituais de 1º círculo de um elemento. Pode conjurá-los até o limite de 3 PE por conjuração; DT 15.	1	PDF v1.1, p. 286
9d376840-ee0e-4520-9115-1b751809b175	3e733982-0435-ca3a-40e2-20e2ac8d5195	DECEPAR	Em acerto crítico com Foice da Morte, reduz o alvo a 25 PV e causa perda permanente de 1 ponto de Força, Agilidade ou Vigor, escolhido aleatoriamente. Se o alvo já tiver 25 PV ou menos, morre. Ao matar uma criatura, recebe 50 PV temporários e suas Foices da Morte causam +1d10 de dano até o fim da cena.	1	PDF v1.1, p. 213
1a8fb0f5-ccb4-498d-b164-f9693913ca19	5e226c8d-e09f-ddc9-7963-811bd3cfa346	FAIXAS DA PERMANÊNCIA	Ao ser reduzida a 0 PV, não é destruída imediatamente e pode agir até o fim do próximo turno. Se não terminar esse turno com ao menos 1 PV, morre.	1	PDF v1.1, p. 221
2773907f-d05d-4e1f-a17f-b0462b47ffd4	25556b0f-1ee2-f31a-5f84-21662ea3eeca	TAMANHO ADAPTÁVEL	Pode reduzir paranormalmente seu corpo para qualquer categoria de tamanho menor. Seu deslocamento não é reduzido por andar furtivamente ou escalar.	1	PDF v1.1, p. 237
7d7540fb-d589-43fc-a8c8-46fb6da3baef	25556b0f-1ee2-f31a-5f84-21662ea3eeca	TORMENTO INFANTIL	Fica desprevenido ao ouvir cantiga de ninar ou outra canção infantil. Ao ouvir uma criança chorando, usa suas ações disponíveis para encontrar e silenciar a fonte do choro.	2	PDF v1.1, p. 237
80a23277-06ba-4f59-b17f-768159ed17da	d6ecb2e4-bd05-093f-d43f-26dca3d354bb	IMATERIAL	É imune a dano e a todas as condições, não faz testes e não age como criaturas comuns. A forma de derrotá-la depende da resolução de seu Enigma de Medo.	1	PDF v1.1, p. 261
aecd6d5e-3665-4618-bf2f-0ba49d18a28d	d6ecb2e4-bd05-093f-d43f-26dca3d354bb	EXISTÊNCIA IMPOSSÍVEL	Não se desloca normalmente. Existe dentro de objetos que possam ser abertos por uma porta; quando manifestada, pode usar seus poderes e passa a perseguir quem a manifestou.	2	PDF v1.1, p. 261
d7404b34-865f-4803-96a7-121168471ed9	b55d1509-2803-fc09-cd9a-66772751e758	ESTADO DE COMBATE	No começo do turno assume um dos quatro estados disponíveis: Alpha, Beta, Gama ou Delta. Cada estado define quais ações pode realizar e deixa de estar disponível quando sua fraqueza é resolvida.	1	PDF v1.1, pp. 264-265
23db7333-b3cd-439a-a234-398742afa165	b55d1509-2803-fc09-cd9a-66772751e758	REGENERAÇÃO ENERGÉTICA	No começo do turno recupera 20 PV. Se perder três ou mais estados de combate, perde esta habilidade.	2	PDF v1.1, p. 265
6767ff02-e4a2-4a8e-b9c3-25ebdb9a46fa	553a94fb-382c-69c5-eac0-dfb12b2665bb	FORMA DE SANGUE	Na forma líquida de Sangue, possui resistência 20 a balístico, corte, impacto, perfuração e Sangue, deslocamento 36m, pode atravessar canos/frestas e recebe Afogar em Sangue, Arrancar Sangue e Invadir Órgãos. Perde esta habilidade ao assumir sua forma física.	1	PDF v1.1, p. 199
3f7a06bd-33d6-47d2-9076-90bc8f1ff9f2	0234288f-2f0c-872d-cbae-239b25da9cc7	CONSUMIR	Quando invocada, a dama de sangue não possui as habilidades da coluna ao lado. Sempre que consome um corpo, recebe uma das habilidades, na ordem da ficha (ou seja, ganha primeiro Arremessar, depois Chuva de Ácido e assim por diante). Para consumir um corpo, a dama de sangue precisa estar adjacente ao cadáver e gastar uma ação padrão. No começo de seu turno, se não tiver consumido sete corpos, a dama de sangue irá utilizar suas ações para se deslocar na direção de um corpo e consumí-lo. Assim que tiver consumido sete corpos, ela pode agir normalmente.	1	PDF v1.1, p. 190
2132a58d-d32d-460c-9d47-9b1a32e0d123	64b81aec-4e03-2fca-94e7-851dbd04b7a0	TRANSFORMAÇÃO	O enpap-X começa o combate como um existido comum, usando todas as estatísticas da ficha da página 240. Quando ele é reduzido a 0 PV, porém, em vez de morrer, se transforma: passa a usar a ficha desta página (inclusive gerando o efeito de sua presença perturbadora) e recupera todos os seus PV, ficando com 360 PV.	1	PDF v1.1, p. 193
fa4cc9d3-93ea-483c-ad1b-df96a5d4a84e	dc030186-e4b0-6b26-a3eb-cdb5e2980571	CARÊNCIA	Qualquer ser que já esteve envolvido em uma gestação recebe +O em ataques contra o carente, porém o carente também recebe +O em ataques contra esse ser.	1	PDF v1.1, p. 188
49e2c4b5-e6f2-420f-8ce4-d3e24d240ac5	dc030186-e4b0-6b26-a3eb-cdb5e2980571	REGENERAÇÃO DE SANGUE	O carente possui Cura Acelerada 20. Se o carente ficar inconsciente ou sofrer dano de Energia, esta habilidade deixa de funcionar até o fim da cena.	2	PDF v1.1, p. 188
9ca8a1f2-e2f5-4c6e-9b8e-1caacb202613	d4da78e2-01d5-3a2c-cb04-bc56d7df0a5c	FURTIVO E LETAL	Quando ataca um personagem desprevenido, o zumbi de sangue bestial recebe +O nos testes de ataque e, se acertar, cada ata- que causa dois dados de dano adicional do mesmo tipo.	1	PDF v1.1, p. 203
02826261-40d3-47e2-bf32-9ca7b7b42dd6	d4da78e2-01d5-3a2c-cb04-bc56d7df0a5c	INSTINTO PREDATÓRIO	O zumbi de sangue bestial não sofre penalidade em Furtividade por se mover seu desloca- mento normal.	2	PDF v1.1, p. 203
136da929-f307-4272-9f7c-ecfa50750ede	67052271-cab5-1982-3cfc-2fff9fcf2c74	MOMENTO PASSIVO	Apesar de não ser rápida, a marionete não pode ter seu deslocamento reduzido e ignora qualquer tipo de terreno difícil. Além disso, ela não sofre dano ou efeitos que dependam que ela toque no chão.	1	PDF v1.1, p. 219
d5ad5837-8d56-44eb-a82e-5f1d56e663e3	e4866d22-2413-8a10-dc2f-30681c33a483	PERCEPÇÃO TÁTIL	A aracnasita percebe tudo que está em contato com sua teia. Ela ignora penalidades por visão ou condições de sentidos para objetos e seres em contato com a teia.	1	PDF v1.1, p. 209
a35b8276-2a08-4f33-94f4-45ba288178d1	40b5007f-2005-de03-e7f4-64783809fd47	IMORTALIDADE	Quando o enraizado morre, se desfaz em uma poça de lodo, galhos e raízes. Ele retornará após 1d2 rodadas com 70 PV. Se sofrer 20 pontos de dano de fogo ou de Energia somados enquanto estiver na forma de poça, será permanentemente destruído.	1	PDF v1.1, p. 214
3bea9393-4e53-425d-b65a-c9f142d17c20	40b5007f-2005-de03-e7f4-64783809fd47	VENENO PÚTRIDO	A primeira vez que um personagem sofre dano do punho espinhento em uma cena, fica envenenado. No início de cada um de seus turnos, o personagem deve fazer um teste de Fortitude (DT 23). Se falhar, sofre 4d12 pontos de dano de Morte. Se passar, se cura do veneno.	2	PDF v1.1, p. 214
7fb48177-1300-49af-b8eb-b77d33440c8c	0bcc85f7-b3dd-c1dd-d8b9-95c8f01a8dda	ENIGMA DE MEDO	Tocar a melodia do escutado exige gastar uma ação padrão e passar em um teste de Artes (DT 25) por rodada, ou ligar um aparelho como um rádio ou celular que possua essa música. Enquanto a melodia estiver tocando, o escutado ficará se multiplicando. Porém, se escutar a melodia por 4 rodadas ininterruptas, perde sua imunidade a dano até o fim da cena e pode enfim ser derrotado. Como o escutado precisa escutar a melodia por 4 rodadas, terá a chance de se multiplicar quatro vezes. Isso significa que, se nenhuma cópia for destruída, no fim da quarta rodada haverá 16 criaturas (o original mais 15 cópias)! Para ter alguma chance de sobrevivência, os agentes devem tentar destruir as cópias enquanto tocam a melodia, para impedir que elas também se multipliquem — e, obviamente, parar de tocar a música assim que as 4 rodadas passarem e o escutado perder sua imunidade a dano.	1	PDF v1.1, p. 216
c4b3964a-685e-48cd-b089-6a59f742570a	0bcc85f7-b3dd-c1dd-d8b9-95c8f01a8dda	MULTIPLICAÇÃO MELÓDICA	No início do turno do escutado, se ele estiver ouvindo a melodia de sua criação, manifesta uma cópia sua em um ponto a sua escolha em alcance curto. A cópia possui 145 PV, não tem imunidade a dano e age junto com o escutado original, a partir do próximo turno dele. As cópias também possuem essa habilidade, gerando novas cópias caso aplicável. O escutado e suas cópias tentarão eliminar o ser que estiver tocando a melodia.	2	PDF v1.1, p. 216
6c817575-c5fb-4666-9b14-d5d1ffbe03a2	48f329fb-339b-2f3c-ab5e-69c01707ec0e	IMORTALIDADE	Quando o esqueleto morre, se desfaz em uma poça de lodo e ossos. Ele retornará após 1d3 rodadas com 20 PV. Se sofrer dano de fogo ou de Energia enquanto estiver na forma de poça, será permanentemente destruído.	1	PDF v1.1, p. 217
8aaee7ca-e2c4-4657-aaff-218c4245f904	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	CICLO INFINITO	O Deus da Morte recupera 50 PV no início de cada um de seus turnos. Quando é reduzido a 0 PV ou menos, ele se transforma em uma poça de lodo. No começo do seu próximo turno, ele se manifesta no cadáver mais próximo do corpo original (ou no corpo com maior NEX a seu alcance), recuperando todos os seus PV e se curando de todas as condições. Quando seu Enigma de Medo for resolvido, ele perde a regeneração e a capacidade de se manifestar em um corpo próximo quando reduzido a 0 PV ou menos.	1	PDF v1.1, p. 230
b844fe3b-6c9d-496f-808f-31c2ab1e81bd	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	DESTRUIR O DIABO	O Deus da Morte é a única coisa capaz de causar a solução do Enigma de Medo do Diabo.	2	PDF v1.1, p. 230
cc201d1b-98dd-4dc4-90c7-b53df50e85ab	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	POTÊNCIA DE MORTE	O modificador do Deus da Morte para todos os testes de perícia baseados em Força, Vigor ou Presença é +35, e para testes baseados nos demais atributos, é +25.	3	PDF v1.1, p. 230
7e0e0020-b32b-4f16-812e-cf22d66b1b54	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	SENHOR DO TEMPO	O Deus da Morte é um manipulador do tempo. No início de cada rodada, ele rola 1d20 e recebe um turno adicional na contagem de iniciativa correspondente ao resultado desta jogada.	4	PDF v1.1, p. 230
afbbc470-70c8-4f09-983f-8b180b8223d5	25556b0f-1ee2-f31a-5f84-21662ea3eeca	DESTRUIR MENTE	O bicho papão destrói e devora a mente assustada de seus alvos. Sempre que acerta um alvo perturbado com suas Garras Atormentadoras, o bicho papão causa também 1d8 pontos de dano mental por acerto.	2	PDF v1.1, p. 237
1e9e7d68-518b-40a4-8709-77e1a66d56c7	368972da-2308-bf04-7103-bca0de4932fd	AURA MANIFESTADA	O lembrado é cercado por uma aura dourada de faces flutuantes, que gritam com todos aqueles que se aproximam. Personagens em alcance curto do lembrado sofrem –OO em todos os testes.	1	PDF v1.1, p. 241
21d45639-badf-4dbc-8c1d-03428641bb3b	af9ebb2d-0f65-c58e-27bd-dbdb8f62445c	DESTRONAR O ANFITRIÃO	A Máscara do Desespero é a única que consegue resolver o Enigma de Medo do Anfitrião.	1	PDF v1.1, p. 254
5151e8f5-3b4b-4cd5-8fbc-c8d35aaba6ec	af9ebb2d-0f65-c58e-27bd-dbdb8f62445c	POTÊNCIA DO CONHECIMENTO	O modificador da Máscara do Desespero para todos os testes de perícia baseados em Intelecto, Presença e Vigor é +35, e para testes baseados nos demais atributos, é +25.	2	PDF v1.1, p. 254
3ff2f850-e194-44a3-b7dc-4bdad6b1ed28	15b07f11-8cdc-d86d-eebd-b745d86cb108	SEMPRE PRESENTE	No começo de uma cena, o ocioso escolhe um personagem que possa ver para ser seu alvo. O alvo é o único ser que consegue enxergar o ocioso; para todos os demais, ele é invisível.	1	PDF v1.1, p. 244
e07764d3-1282-442a-bbef-203cb5a6b4aa	04f6c70d-ccd0-6736-5a7e-8b4380e81ecc	CONHECIMENTO VERDADEIRO	A silhueta alcançou o Outro Lado através do Conhecimento e, por isso, sabe tudo. Ela faz testes baseados em Intelecto e Presença com +25 e testes baseados em Agilidade, Força e Vigor com +20.	1	PDF v1.1, p. 250
24d49cb8-63b6-4cf8-8808-7d468543afc8	eeb94d35-292d-e7b1-8686-0a2ea8a0ee90	AURA TANGÍVEL	O vulto procura pessoas assustadas para que possa se alimentar dos sentimentos disparados pelos sustos. Seus ataques contra criaturas sob efeito de qualquer condição de medo causam +2d6 pontos de dano de Conhecimento.	1	PDF v1.1, p. 251
b8d5da34-bd97-45e0-b46a-b39003f875de	2faad71f-e963-0d04-806c-e49455fac533	COMPORTAMENTO ERRÁTICO	No começo do seu turno, o anárquico é tomado pelo fluxo de Energia em seu corpo e age de modo aleatório. Role 1d6 para determinar o que ele faz. Se não puder realizar a ação, fica parado se contorcendo, mas recebe resistência a dano 5 até o início do seu próximo turno.  1 2 O anárquico pula sobre o personagem mais próximo, fazendo a ação investida (ou a ação agredir, se estiver muito próximo do personagem). Se não conseguir atacar alguém, corre na direção do personagem mais próximo.  3 4 O anárquico projeta uma luz prismática de dentro de si na direção de um ser em alcance médio. O alvo sofre 2d8 pontos de dano de Energia e fica atordoado por uma rodada (Fortitude DT 14 reduz o dano à metade e evita a condição).  5 Uma explosão de Energia emana do anárquico. Cada ser em alcance curto sofre 2d6 pontos de dano de Energia (Reflexos DT 14 reduz à metade). Seres adjacentes ao anárquico sofrem +1d6 pontos de dano.  6 Uma risada descontrolada toma o anárquico enquanto ele faz a ação agredir contra o personagem mais próximo. Até o final de seu próximo turno, o anárquico fica desprevenido, mas seus ataques ficam completamente imprevisíveis e o defensor não pode se esquivar deles.	1	PDF v1.1, p. 257
22948216-c5bd-415f-9810-49e0949bf791	20f91d11-1834-d40f-02c1-8e8a0c81ee63	AURA DESESPERADA	Qualquer ser que comece seu turno em alcance curto da sukkalgir sofre 2d12 pontos de dano mental (Vontade DT 25 reduz à metade).	1	PDF v1.1, p. 269
aba6688e-b4f3-42fa-9b37-fd00a6ea9594	20f91d11-1834-d40f-02c1-8e8a0c81ee63	ESPÍRITO PLASMÁTICO	A sukkalgir é parcialmente intangível, e pode atravessar obstáculos sólidos como paredes.	2	PDF v1.1, p. 269
f056bbf5-4afb-4490-9655-fde0cd3ae1e2	9d273d68-1267-1193-d4e4-d7aade51df78	ESPECTRO RADIOATIVO	O tempestuoso manifesta um espectro de radiação à sua volta, que atua como uma extensão de seu corpo físico. Todos os ataques e habilidades corpo a corpo do tempestuoso podem ser feitos em alcance curto.	1	PDF v1.1, p. 273
625ec70c-b9c6-49aa-8752-0c4742bc4285	c9a49ecf-895c-9dac-0185-2e23764358cd	INVISIBILIDADE PERMANENTE	O viajante é invisível. Ele recebe camuflagem total, +15 em Furtividade e seres que não possam vê-lo ficam desprevenidos contra seus ataques.	1	PDF v1.1, p. 274
90b79690-6e8c-413e-af4e-9e1b9d066908	f87384c2-4e60-56db-a5de-3d654357a796	CRIATURA DO MEDO	A degolificada é imune a dano, até que se resolva o mistério da sua origem.	1	PDF v1.1, p. 282
cd97c25e-6238-4c42-adb4-120c4c0c9464	4c29680f-753d-b300-6316-69ab128fbd3f	DEVORAR CULPA	Se fixar em um personagem dormindo, prende personagens adormecidos em alcance médio em um sonho compartilhado até ser derrotado ou até o hospedeiro morrer ou enlouquecer.	1	PDF v1.1, p. 246
\.


--
-- Data for Name: threat_action; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.threat_action (id, threat_id, name, action_type, description, test_expression, damage_expression, sort_order, attack_count, range_text, critical, damage_type, resistance_text, source_ref, mechanics_data) FROM stdin;
6b5d610d-1a93-4d19-b05c-047d4d46a72d	e2be0bb4-7c11-800b-ce51-7c9de1342c43	PANCADA	PADRÃO	\N	3O+10	2d6+6 impacto	1	2	\N	\N	\N	\N	PDF v1.1, p. 182	{"parsed_from_statblock": true}
65dfe626-794b-4ac3-a481-ce4dfc154576	e2be0bb4-7c11-800b-ce51-7c9de1342c43	AGARRÃO	REAÇÃO	Se a aberração de carne acertar um ataque de pancada, ela pode tentar agarrar o alvo (teste 3O+12). Ela pode manter até dois personagens agarrados por vez.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 182	{"parsed_from_statblock": true}
1eb37c03-a7c7-4e92-b1b9-30c25bbe0dcd	e2be0bb4-7c11-800b-ce51-7c9de1342c43	ABOCANHAR	MOVIMENTO	A aberração de sangue leva até dois personagens agarrados para dentro de sua boca central, que são abocanhados e continuam agarrados. Quando é abocanhado, e no início de cada turno da aberração em que continuar agarrado desta forma, o personagem sofre 3d6 pontos de dano de perfuração (Fortitude DT 15 reduz à metade). Qualquer personagem adjacente a aberração de sangue pode gastar uma ação padrão para fazer um teste de Atletismo (DT 20) para tentar tirar outro personagem de dentro da boca.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 182	{"parsed_from_statblock": true}
3f57de61-b036-4663-a61c-66445e1da3bd	2fd41391-37dd-20d2-871e-cb71f4ebb278	GARRAS	PADRÃO	\N	5O+40	4d10+30	1	2	\N	\N	\N	\N	PDF v1.1, p. 186	{"parsed_from_statblock": true}
f6781026-1c60-4bc3-954d-dd1d0ab91817	2fd41391-37dd-20d2-871e-cb71f4ebb278	TENTÁCULOS ESPINHENTOS	PADRÃO	\N	5O+40	2d12+30 Sangue	2	2	\N	\N	\N	\N	PDF v1.1, p. 186	{"parsed_from_statblock": true}
592b4082-f6cd-4ad1-af19-b7bb8494c536	2fd41391-37dd-20d2-871e-cb71f4ebb278	DISPARO DE ESPINHOS	PADRÃO	\N	4O+40	2d10+20 Sangue	3	3	Médio	\N	\N	\N	PDF v1.1, p. 186	{"parsed_from_statblock": true}
060b17ec-9fc8-4577-aad4-133a5ac5cf78	2fd41391-37dd-20d2-871e-cb71f4ebb278	AGARRÃO	REAÇÃO	Se a aniquilação acertar um ataque de tentáculos espinhentos, ela pode tentar agarrar o alvo (teste 5O+50). Ela pode manter até quatro personagens agarrados por vez.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 186	{"parsed_from_statblock": true}
c034b307-f88b-462f-8593-096f2248e715	2fd41391-37dd-20d2-871e-cb71f4ebb278	INSTINTO ANIQUILADOR	REAÇÃO	Sempre que um personagem em alcance curto da aniquilação se movimenta mais do que 3m, a aniquilação realiza um ataque de tentáculos espinhentos contra o personagem.	\N	\N	5	\N	\N	\N	\N	\N	PDF v1.1, p. 186	{"parsed_from_statblock": true}
11bd98b2-fbef-4fcb-ba07-1b3bb7172969	2fd41391-37dd-20d2-871e-cb71f4ebb278	APERTAR E DESTRUIR	LIVRE	No início do seu turno, a aniquilação aperta os personagens agarrados com seus tentáculos, causando 40 pontos de dano de Sangue.	\N	\N	6	\N	\N	\N	\N	\N	PDF v1.1, p. 186	{"parsed_from_statblock": true}
bfb1fb6e-8d6f-4dd5-b2f0-0a3a75082179	2fd41391-37dd-20d2-871e-cb71f4ebb278	BATER AS ASAS	MOVIMENTO	A aniquilação bate suas asas, criando um som ensurdecedor. Cada personagem em alcance longo sofre 8d6 pontos de dano Mental, é empurrado 6m para longe da aniquilação e fica atordoado por uma rodada (Fortitude DT 40 reduz o dano à metade e evita os efeitos).	\N	\N	7	\N	\N	\N	\N	\N	PDF v1.1, p. 186	{"parsed_from_statblock": true}
68b2e827-0e29-43c6-8c29-6c2f9b9411fd	2fd41391-37dd-20d2-871e-cb71f4ebb278	ESTRANGULAMENTO FINAL	MOVIMENTO	A aniquilação se desloca 15m enquanto seus inúmeros braços agarram e estrangulam per- sonagens no caminho. Cada personagem que ficar adjacente a aniquilação durante esse des- locamento fica agarrado e asfixiado (Reflexos DT 30 evita). Um personagem agarrado pode escapar gastando uma ação padrão e passando em um teste de Reflexos (DT 30).	\N	\N	8	\N	\N	\N	\N	\N	PDF v1.1, p. 186	{"parsed_from_statblock": true}
1be94fa2-5b4f-4843-aeb8-dc5d85ce8ff7	2fd41391-37dd-20d2-871e-cb71f4ebb278	TEMPESTADE DE ESPINHOS	COMPLETA	A aniquilação lança todos os seus espinhos. Todos os personagens em alcance médio sofrem 20d6+20 pontos de dano de Sangue (Reflexos DT 40 reduz à metade). A aniquilação só pode usar esta habilidade uma vez por cena e, quando a usa, perde seu disparo de espinhos até o fim da cena. ENIGMA DE MEDO O Enigma de Medo da Aniquilação é desconhecido. Quando ele for resolvido, a Aniquilação perde sua resistência a dano e sua habilidade Tempestade de Espinhos.	\N	\N	9	\N	\N	\N	\N	\N	PDF v1.1, p. 186	{"parsed_from_statblock": true}
b9aa9634-f1d4-4e8b-afb4-4c2499127f2c	0234288f-2f0c-872d-cbae-239b25da9cc7	ARREMESSAR (Flor Rosa)	MOVIMENTO	A dama de sangue ergue um personagem em alcance curto e o arremessa a um ponto a sua escolha também em alcance curto. O personagem sofre 2d6 pontos de dano de impacto e fica caído (Reflexos DT 15 evita todo o efeito). A flor rosa murcha se a dama de sangue entrar em contato com fertilizante. Isso faz a dama perder esta habilidade e sofrer –O em Luta.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 190	{"parsed_from_statblock": true}
cc10def7-3c9c-476b-b440-fd79cdf10619	0234288f-2f0c-872d-cbae-239b25da9cc7	CHUVA DE ÁCIDO (Flor Vermelha)	MOVIMENTO	A dama espirra ácido que derrete carne e corrói metal. Todos os personagens em alcance curto sofrem 4d4 pontos de dano químico (Fortitude DT 15 reduz à metade). A flor vermelha murcha se a dama de sangue entrar em contato com agrotóxico. Isso faz a dama perder esta habilidade e reduz suas resistências a dano em 5.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 190	{"parsed_from_statblock": true}
312713d6-d19f-4420-a0aa-01083e7b70fc	0234288f-2f0c-872d-cbae-239b25da9cc7	ESPINHOS (Flor Amarela)	MOVIMENTO	A dama dispara espinhos em até três alvos em alcance médio. Cada alvo sofre 2d8 pontos de dano de perfuração (Reflexos DT 15 reduz à metade). A flor amarela murcha se a dama de sangue sofrer 10 pontos de dano de fogo de um único efeito. Isso faz a dama perder esta habilidade e sofrer –O em testes de Reflexos.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 190	{"parsed_from_statblock": true}
61799609-7074-4d61-a6f2-6fc1066baa1e	0234288f-2f0c-872d-cbae-239b25da9cc7	GRITO DEVASTADOR (Flor Roxa)	MOVIMENTO	A dama emite um grito agudo que afeta a mente e causa confusão. Todos os personagens em alcance curto ficam confusos (Vontade DT 15 evita). Um personagem que falhe no teste pode repeti-lo no final do seu turno. A flor roxa murcha se a dama de sangue entrar em contato com o bulbo de bravo purpulis, uma planta roxa que cresce em algumas pe- dras. Isso faz a dama perder esta habilidade e sofrer –O em testes de Vontade.	\N	\N	5	\N	\N	\N	\N	\N	PDF v1.1, p. 190	{"parsed_from_statblock": true}
0a7e76ae-dc19-4aab-a3ae-d2cf33664358	0234288f-2f0c-872d-cbae-239b25da9cc7	MIASMA FÉTIDO (Flor Azul)	PADRÃO	A dama de sangue expele um miasma fétido que contamina o ar. Todos os personagens em alcance curto ficam enjoados por 1d4+1 rodadas (Fortitude DT 15 reduz à 1 rodada). A flor azul murcha se a dama de sangue sofrer dano de eletricidade ou Energia. Isso faz a dama perder esta habilidade e reduz seu deslocamento em 6m.	\N	\N	6	\N	\N	\N	\N	\N	PDF v1.1, p. 190	{"parsed_from_statblock": true}
34ca4ed0-77fc-4b8d-a4ba-021315d2eae5	0234288f-2f0c-872d-cbae-239b25da9cc7	PRISÃO DE TENTÁCULOS (Flor Verde)	PADRÃO	A criatura penetra o solo com seus tentáculos e escolhe um personagem em alcance curto. Esse personagem fica agarrado até que os tentáculos sejam destruídos (os tentáculos são acertados automaticamente e tem 20 PV). A flor verde murcha se for molhada em água corrente. Isso faz a dama perder esta habilidade e reduz sua Defesa em 5.	\N	\N	7	\N	\N	\N	\N	\N	PDF v1.1, p. 190	{"parsed_from_statblock": true}
81bc46a2-2189-4808-ae6d-86614829f911	0234288f-2f0c-872d-cbae-239b25da9cc7	TENTÁCULO	PADRÃO	\N	3O+10	2d6+5 impacto	1	2	\N	\N	\N	\N	PDF v1.1, p. 190	{"parsed_from_statblock": true}
30928144-dc55-4d23-b709-f24a82a70982	e4866d22-2413-8a10-dc2f-30681c33a483	MORDIDA	PADRÃO	\N	3O+15	2d10+10 perfuração	1	1	\N	\N	\N	\N	PDF v1.1, p. 209	{"parsed_from_statblock": true}
5be31ef5-6fee-4bb3-8ccf-8524cd3c12a2	d4da78e2-01d5-3a2c-cb04-bc56d7df0a5c	GARRAS DE SANGUE	PADRÃO	\N	3O+15	2d6+5 corte	2	2	\N	\N	\N	\N	PDF v1.1, p. 203	{"parsed_from_statblock": true}
7883bb17-efc0-403e-b9b5-9bfdce68e6e2	64b81aec-4e03-2fca-94e7-851dbd04b7a0	CORRENTES	PADRÃO	\N	2O+15	2d8+10 impacto	2	3	Curto	\N	\N	\N	PDF v1.1, p. 193	{"parsed_from_statblock": true}
fc3d67e6-3b00-43b2-b9a7-b6dc51b19ed5	0234288f-2f0c-872d-cbae-239b25da9cc7	VISÃO MACABRA (Flor Laranja)	MOVIMENTO	O movimento hipnotizante da flor faz com que o personagem tenha delírios de imagens macabras e perturbadas. Todos os personagens em alcance médio sofrem 1d6 pontos de dano Mental (Vontade DT 15 reduz à metade). A flor laranja murcha se a dama de sangue sofrer 10 pontos de dano de corte de um único efeito. Isso faz a dama perder esta habilidade e reduz seus PV totais em 20. ENIGMA DE MEDO A dama de sangue é uma criatura poderosa, invocada através de um ritual que envolve o sacrifício de sete pessoas para o desabrochar de sete flores. Porém, cada flor possui uma fraqueza, conforme descrito nas habilidades ao lado.	\N	\N	8	\N	\N	\N	\N	\N	PDF v1.1, p. 190	{"parsed_from_statblock": true}
69964c86-80e9-4328-9625-bd910523f23b	64b81aec-4e03-2fca-94e7-851dbd04b7a0	SOCÃO	PADRÃO	\N	4O+20	2d10+10 impacto	1	4	\N	\N	\N	\N	PDF v1.1, p. 193	{"parsed_from_statblock": true}
2261a7da-3cfb-4ad7-98a1-b48079c79153	64b81aec-4e03-2fca-94e7-851dbd04b7a0	ACORRENTAR	LIVRE	Se o enpap-X de sangue acertar um ataque de correntes em um personagem Médio ou menor, pode tentar agarrar o alvo à distância (teste 2O+17). No começo do seu turno, o Enpap-X estrangula cada personagem agarrado desta forma, causando 4d6 pontos de dano de impacto. O Enpap-X pode ter manter até dois personagens agarrados simultaneamente.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 193	{"parsed_from_statblock": true}
35a18446-0b68-42f6-8b06-b21060bce3d5	64b81aec-4e03-2fca-94e7-851dbd04b7a0	FORMA DESENCADEADA	REAÇÃO	Quando faz um acerto crítico com um socão ou com uma corrente, o Enpap-X pode derrubar o alvo ou empurrá-lo 3m na direção oposta.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 193	{"parsed_from_statblock": true}
469c8658-f80c-43ba-920e-ef695e617c0a	64b81aec-4e03-2fca-94e7-851dbd04b7a0	CRESCER	REAÇÃO	Movido pelo Sangue incontrolável, o Enpap-X desenvolve força conforme desfere seus golpes. Sempre que acertar um personagem com seu socão, o Enpap-X recebe um bônus cumulativo de +1d6 em suas próximas rolagens de dano até o fim do turno. Ou seja, se acertar o primeiro socão, no segundo recebe +1d6 de dano. Se acertar o segundo, no terceiro recebe +2d6. E se acertar o terceiro, no quarto socão recebe +3d6.	\N	\N	5	\N	\N	\N	\N	\N	PDF v1.1, p. 193	{"parsed_from_statblock": true}
daff5c8d-eca6-4aa4-9931-c4582537c76c	64b81aec-4e03-2fca-94e7-851dbd04b7a0	MARCAS DO TERROR	MOVIMENTO	O Enpap-X faz com que as marcas em seu corpo brilhem com uma luz dourada, revelando as atrocidades eternizadas em sua pele. Todos os personagem em alcance curto do Enpap-X sofrem 4d6 pontos de dano mental (Vontade DT 25 reduz à metade). Um personagem que passe no teste de resistência fica imune a esta habilidade até o final da cena.	\N	\N	6	\N	\N	\N	\N	\N	PDF v1.1, p. 193	{"parsed_from_statblock": true}
70f71058-8eab-4652-b96e-c6b17cfb2234	3587d753-20e6-0197-2b96-f948f5ca6bc9	MORDIDA	PADRÃO	\N	5O+40	4d12+30 Sangue	1	1	\N	\N	\N	\N	PDF v1.1, p. 194	{"parsed_from_statblock": true}
8ed7e2b1-7ad5-407b-9bb2-8f5b86eb03e6	3587d753-20e6-0197-2b96-f948f5ca6bc9	DISPARO DE ESPINHOS	PADRÃO	\N	4O+35	4d8+20 Sangue	2	1	Médio	\N	\N	\N	PDF v1.1, p. 194	{"parsed_from_statblock": true}
50014101-ed68-4acb-96e2-70813c7d5e23	3587d753-20e6-0197-2b96-f948f5ca6bc9	DEVORAR	LIVRE	Uma vez por cena, quando reduz os PV de um personagem a 0 com sua mordida, o kerberos pode devorá-lo, matando-o instantaneamente e recuperando PV iguais à metade dos PV totais da vítima. A vítima tem direito a um teste de Fortitude (DT 40) para evitar o efeito.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 194	{"parsed_from_statblock": true}
4e14bafd-5582-48e8-95b0-3d4c04a8f886	0f60fed6-a659-b802-3fb1-8f53d4278aaa	CHIFRES	PADRÃO	\N	5O+30	6d12+20	1	1	\N	\N	\N	\N	PDF v1.1, p. 197	{"parsed_from_statblock": true}
b350a20d-25f3-4baa-af4d-77bb30abef05	0f60fed6-a659-b802-3fb1-8f53d4278aaa	MACHADO	PADRÃO	\N	5O+32	4d12+20 corte	2	2	\N	\N	\N	\N	PDF v1.1, p. 197	{"parsed_from_statblock": true}
668b14d6-5080-4836-9a3f-70f312460a57	553a94fb-382c-69c5-eac0-dfb12b2665bb	MORDIDA	PADRÃO	\N	3O+15	4d8+8	1	1	\N	\N	\N	\N	PDF v1.1, p. 199	{"parsed_from_statblock": true}
d6439293-f55c-4106-9347-3017e178947b	553a94fb-382c-69c5-eac0-dfb12b2665bb	GARRAS	PADRÃO	\N	4O+15	4d6+6 corte	2	2	\N	\N	\N	\N	PDF v1.1, p. 199	{"parsed_from_statblock": true}
62e9bfce-ad87-49bd-b4d2-2252ffdc0043	553a94fb-382c-69c5-eac0-dfb12b2665bb	JATO DE SANGUE	PADRÃO	\N	4O+10	4d8+8 Sangue	3	1	Curto	\N	\N	\N	PDF v1.1, p. 199	{"parsed_from_statblock": true}
c6e858c4-2b40-4c61-b761-6c8bb09856cd	553a94fb-382c-69c5-eac0-dfb12b2665bb	SUGAR SANGUE	MOVIMENTO	A mulher afogada devora o corpo de um per- sonagem adjacente que tenha morrido nesta cena, recuperando 40 PV no processo. Ações da Forma de Sangue	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 199	{"parsed_from_statblock": true}
e885318e-b8ca-4192-ac41-026dde1f92fc	553a94fb-382c-69c5-eac0-dfb12b2665bb	AFOGAR EM SANGUE	PADRÃO	A mulher afogada invade os orifícios do nariz e da boca de um personagem em alcance curto, afogando-o com Sangue. O personagem fica asfixiado. No início de cada um de seus turnos, pode fazer um teste de Fortitude (DT 24). Se passar, encerra a condição e faz a mulher afogada ser expelida na forma líquida para um espaço adjacente.	\N	\N	5	\N	\N	\N	\N	\N	PDF v1.1, p. 199	{"parsed_from_statblock": true}
b7db53e9-f35b-43a4-b523-c0165b6bf30b	553a94fb-382c-69c5-eac0-dfb12b2665bb	ARRANCAR SANGUE	REAÇÃO	Toda vez que a mulher afogada é arrancada de um corpo que ela esteja asfixiando com afogar em Sangue, ela carrega consigo parte do san- gue da vítima, causando 6d6 pontos de dano de Sangue e deixando-a fraca.	\N	\N	6	\N	\N	\N	\N	\N	PDF v1.1, p. 199	{"parsed_from_statblock": true}
831023de-214e-44d9-8867-9b45d3da85b3	553a94fb-382c-69c5-eac0-dfb12b2665bb	INVADIR ÓRGÃOS	MOVIMENTO	A mulher afogada invade órgãos vitais de um personagem que ela esteja asfixiando com afogar em Sangue. O personagem sofre 6d6 pontos de dano de Sangue e fica enjoado.	\N	\N	7	\N	\N	\N	\N	\N	PDF v1.1, p. 199	{"parsed_from_statblock": true}
83d0ea9a-b1f9-4757-a15e-9de8b96674cb	dc030186-e4b0-6b26-a3eb-cdb5e2980571	GARRAS DE SANGUE	PADRÃO	\N	4O+35	2d8+20	1	2	\N	\N	\N	\N	PDF v1.1, p. 188	{"parsed_from_statblock": true}
e01807c4-6704-46e4-a1e7-32e9f9160991	dc030186-e4b0-6b26-a3eb-cdb5e2980571	FERRÃO DE SANGUE	PADRÃO	\N	4O+35	2d12+20	2	1	\N	\N	\N	\N	PDF v1.1, p. 188	{"parsed_from_statblock": true}
5635e48f-874d-4d6e-b191-10e83aac4acd	dc030186-e4b0-6b26-a3eb-cdb5e2980571	TENTÁCULO	PADRÃO	\N	4O+35	2d8+20 Sangue	3	1	\N	\N	\N	\N	PDF v1.1, p. 188	{"parsed_from_statblock": true}
8047e1f3-5d93-4068-b7de-4e61797b9634	7c0fbcb9-f9cb-a886-2517-8bd5f4bcc597	ASAS DO CONHECIMENTO	PADRÃO	\N	5O+40	4d10+40	1	2	\N	\N	\N	\N	PDF v1.1, p. 234	{"parsed_from_statblock": true}
d490c610-e42f-41b8-bb94-7cb1683b4f41	dc030186-e4b0-6b26-a3eb-cdb5e2980571	FORMA INFANTIL	MOVIMENTO	O carente se contorce de volta para o corpo da pequena criança para passar em espaços pequenos, se retraindo e expandindo quando achar necessário. Além disso, o carente não consegue abrir a primeira porta para entrar em um lugar. Uma vez que essa porta é aberta e ele deixa de estar na forma infantil, pode ignorar essa restrição.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 188	{"parsed_from_statblock": true}
d17c9247-add9-41da-b744-b49c9f396cf5	dc030186-e4b0-6b26-a3eb-cdb5e2980571	RASTEIRA DE TENTÁCULO	REAÇÃO	Uma vez por rodada, quando fica adjacente a dois ou mais seres, o carente faz um ataque de tentáculo contra um deles. Se o carente acertar o ataque, a vítima fica caída e é empurrada 6m para longe dele.	\N	\N	5	\N	\N	\N	\N	\N	PDF v1.1, p. 188	{"parsed_from_statblock": true}
e9b2cfae-5d0e-4249-a221-be91c43dce95	dc030186-e4b0-6b26-a3eb-cdb5e2980571	SUGADA MORTAL	LIVRE	Usando seu ferrão, o carente consegue sugar fluídos e apodrecer os órgãos internos. Um ser atingido pelo ferrão de sangue fica debilitado e enjoado até o fim da cena (Fortitude DT 35 evita).	\N	\N	6	\N	\N	\N	\N	\N	PDF v1.1, p. 188	{"parsed_from_statblock": true}
93685476-53f0-4cc9-adb8-85714e0eb541	dc030186-e4b0-6b26-a3eb-cdb5e2980571	VOCÊ É MINHA MAMÃE?	MOVIMENTO	O carente usa a parte que simula o corpo de uma criança para abraçar um ser adjacente, que fica paralisado até ser solto (Reflexos DT 25 evita). O carente pode manter o abraço indefinidamente, mas será forçado a soltar o alvo se sofrer dano de Energia. CARENTE	\N	\N	7	\N	\N	\N	\N	\N	PDF v1.1, p. 188	{"parsed_from_statblock": true}
00e2e78f-3256-437f-9449-14a6132b5e10	e7ff9a66-e094-d347-aeb8-11e733c4a6df	ARMA SANGRENTA	PADRÃO	\N	6O+45	2d10+50	1	2	\N	x3	\N	\N	PDF v1.1, p. 205-207	{"parsed_from_statblock": true}
eb626043-d3f3-4da0-973f-256b64e5f7df	e7ff9a66-e094-d347-aeb8-11e733c4a6df	CHIFRE DO DIABO	PADRÃO	\N	6O+45	2d8+50 Sangue	2	1	\N	x3	\N	\N	PDF v1.1, p. 205-207	{"parsed_from_statblock": true}
bd43bee9-575e-4eb3-a591-bcb0d2173b62	e7ff9a66-e094-d347-aeb8-11e733c4a6df	ARMA SANGRENTA	PADRÃO	\N	6O+45	2d10+50 Sangue	3	2	Médio	x3	\N	\N	PDF v1.1, p. 205-207	{"parsed_from_statblock": true}
57c2ed05-7dfd-4a1a-8cd2-3718175b3d36	e7ff9a66-e094-d347-aeb8-11e733c4a6df	EXPLODIR EM SANGUE	LIVRE	O Diabo é capaz de controlar o sangue de qualquer ser com o qual ele tenha contato direto. Se ele causar dano em um personagem usando sua arma sangrenta, ou se tocar diretamente em uma ferida de um personagem, ele causa 10d6 pontos de dano de Sangue. O Diabo pode usar esta habilidade duas vezes por turno.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 205-207	{"parsed_from_statblock": true}
8b8dd9bd-d8c6-4259-9ca9-bd9d46b261cd	e7ff9a66-e094-d347-aeb8-11e733c4a6df	SANGRAR	LIVRE	Se o Diabo acertar um ataque com seu chifre, pode escolher soltar o apêndice e deixá-lo preso no personagem. Um personagem com um chifre preso em si sofre vulnerabilidade a Sangue até removê-lo. Fazer isso requer uma ação padrão e causa 8d8 pontos de dano de Sangue. O chifre do Diabo sempre cresce de volta no começo do seu turno.	\N	\N	5	\N	\N	\N	\N	\N	PDF v1.1, p. 205-207	{"parsed_from_statblock": true}
39c09b08-19b3-49e8-9a03-92cb1ebbaa42	e7ff9a66-e094-d347-aeb8-11e733c4a6df	SENHOR DO SANGUE	PADRÃO	Uma vez por cena, o Diabo pode invocar e controlar uma ou mais criaturas de Sangue cujo VD total somado seja até 400. As criaturas aparecem em alcance médio do Diabo e agem a partir da próxima rodada, no turno do Diabo, seguindo a vontade dele.	\N	\N	7	\N	\N	\N	\N	\N	PDF v1.1, p. 205-207	{"parsed_from_statblock": true}
75cbe6d1-1afc-4cb0-a40b-d5414321c630	e7ff9a66-e094-d347-aeb8-11e733c4a6df	PACTO	PADRÃO	O Diabo oferece ao alvo um pacto de Sangue. Se o pacto for aceito, o Diabo irá cumprir o que foi prometido, normalmente com resolu- ções distorcidas ao pé da letra. Em troca, o alvo sofre 10d6 pontos de dano mental e, se en- louquecer como resultado, se torna um servo obcecado pelo Diabo para o resto da vida.	\N	\N	8	\N	\N	\N	\N	\N	PDF v1.1, p. 205-207	{"parsed_from_statblock": true}
b3780088-84df-4cfe-a9ee-d661a388ddef	e7ff9a66-e094-d347-aeb8-11e733c4a6df	DESEJOS DE SANGUE	COMPLETA	Todos os personagens em alcance médio do Diabo entram em uma fúria de Sangue e atacam outro personagem em alcance curto a escolha do Diabo (Vontade DT 45 evita). Um personagem afetado por esta habilidade deve usar sua ação com o maior potencial de dano, mas não pode conjurar rituais. Um personagem que passe no teste de Vontade fica imune a esta habilidade até final da cena.	\N	\N	9	\N	\N	\N	\N	\N	PDF v1.1, p. 205-207	{"parsed_from_statblock": true}
8bc6c57e-ab84-41f4-bcd7-3e9e903074c0	e247cdc1-d609-fa24-f339-7adb397a6ec7	MORDIDA	PADRÃO	\N	5O+25	4d12+10	1	1	\N	\N	\N	\N	PDF v1.1, p. 201	{"parsed_from_statblock": true}
762751ed-3ca2-486d-89cb-d82ffc21215d	e247cdc1-d609-fa24-f339-7adb397a6ec7	GARRAS	PADRÃO	\N	5O+25	4d8+10 corte	2	2	\N	\N	\N	\N	PDF v1.1, p. 201	{"parsed_from_statblock": true}
a8a9689b-7585-40ff-8799-04fd808de35d	e247cdc1-d609-fa24-f339-7adb397a6ec7	ESTRAÇALHAR	LIVRE	Se o titã acertar um ser com sua mordida, ele estraçalha o alvo, que sofre 4d12+10 pontos de dano de perfuração e fica sangrando até final da cena (Reflexos DT 30 reduz o dano à metade e evita a condição).	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 201	{"parsed_from_statblock": true}
4b5aaece-ced9-4f4f-a8e3-da781e03f5b5	d4da78e2-01d5-3a2c-cb04-bc56d7df0a5c	MORDIDA DE SANGUE	PADRÃO	\N	3O+15	2d10+5	1	1	\N	\N	\N	\N	PDF v1.1, p. 203	{"parsed_from_statblock": true}
390aa96e-9e4c-4c9b-842d-be930a0e6e88	67052271-cab5-1982-3cfc-2fff9fcf2c74	FOICE DA MORTE	PADRÃO	\N	5O+30	10d8+10 Morte	1	2	\N	\N	\N	\N	PDF v1.1, p. 219	{"parsed_from_statblock": true}
ee545cda-4f82-45b6-8dbe-7c1db4311d57	67052271-cab5-1982-3cfc-2fff9fcf2c74	REFLEXOS GUIADOS POR CORDA	REAÇÃO	Uma vez por rodada, quando um ser se aproxima da marionete o suficiente para ficar adjacente, ela pode fazer um ataque de foice da morte contra esse ser.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 219	{"parsed_from_statblock": true}
448ff065-10e3-400f-9ae7-6382b44f5136	67052271-cab5-1982-3cfc-2fff9fcf2c74	IRONIA DO DESTINO	COMPLETA	A marionete executa dois ataques com sua Foi- ce da Morte em um ser adjacente. Se acertar o segundo ataque, ela agarra o ser com sua foice e pode se deslocar 6m carregando-o consigo. Enquanto o ser estiver agarrado dessa forma, a marionete poderá transferir parte de sua dor para ele. Sempre que ela sofrer dano enquanto estiver carregando alguém, este dano é dividi- do entre ela e o ser que ela estiver agarrando.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 219	{"parsed_from_statblock": true}
ba27b5d2-a198-4dda-98c7-65cfa86115e6	e4866d22-2413-8a10-dc2f-30681c33a483	DESOVAR ARANHAS	REAÇÃO	Uma vez por cena, quando ficar machucada, a aracnasita desova diversas aranhas menores, que se espalham em sua volta gerando efeitos diversos. No início de cada turno da aracnasita após isso, ela executa um dos seguintes efeitos, nesta ordem.  No primeiro turno, as aranhas se espalham ao redor da aracnasita. Até o fim da cena, um personagem que inicie seu turno em alcance curto da criatura sofre 2d6 pontos de dano mental (Vontade DT 15 reduz à metade).  A partir do segundo turno, as aranhas atacam os personagens ao redor da aracnasita. Até o fim da cena, um personagem que inicie seu turno em alcance curto da criatura sofre 2d8 pontos de dano de Morte (Fortitude DT 15 reduz à metade).  No terceiro turno, as aranhas menores se espalham ainda mais. Os dois efeitos acima agora afetam personagens que iniciem seu turno em alcance médio da aracnasita.  A partir do quarto turno, caso um personagem morra em alance médio da aracnasita, será consumido por uma aranha, que irá se transformar em uma nova aracnasita com 70 PV e sem a habilidade Desovar Aranhas.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 209	{"parsed_from_statblock": true}
2162b55c-f775-45fe-9e10-c8e46a29c5af	e4866d22-2413-8a10-dc2f-30681c33a483	DISPARAR TEIA	MOVIMENTO	A aracnasita dispara uma teia em alcance curto. A teia ocupa uma área quadrada com 3m de lado. Per- sonagens na área ou que entrem nela, ficam agarra- dos (Reflexos DT 20 evita). A teia é tomada pelo lodo de Morte, fazendo com que qualquer personagem que inicie seu turno agarrado por ela sofra 2d8+10 pontos de dano de Morte. Um personagem pode escapar da teia causando 15 pontos de dano de corte a ela ou gastando uma ação padrão para rasgá-la (Atletismo DT 20). A teia dura até fim da cena.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 209	{"parsed_from_statblock": true}
66a7f6fd-7e1d-4a53-8d9b-109b20a2b7f7	981e0906-addf-ca9b-c5e8-82659e6c64cf	GARRA DA MORTE	PADRÃO	\N	4O+25	4d10+20 Morte	1	2	\N	\N	\N	\N	PDF v1.1, p. 211	{"parsed_from_statblock": true}
f14f329a-c6da-4de5-bbec-ab1db7a5f9a4	981e0906-addf-ca9b-c5e8-82659e6c64cf	PANCADA PODEROSA	REAÇÃO	Quando desfere um acerto crítico com sua garra da morte, o carniçal pode empurrar seu alvo 6m em qualquer direção. Se colidir com um objeto resistente, como uma parede ou um carro, a vítima sofre 4d6 pontos de dano de impacto. Se o objeto for outro ser, ambos sofrem esse dano.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 211	{"parsed_from_statblock": true}
0d5e9e50-1991-4c5d-8985-7c4067163ac6	981e0906-addf-ca9b-c5e8-82659e6c64cf	COMANDO	MOVIMENTO	O carniçal dá um comando para um ser em alcance curto, que deve obedecer da forma mais eficiente possível (Vontade DT 29 evita). Em termos de regras, isso gera um dos efeitos básicos do ritual Perturbação (página 137).	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 211	{"parsed_from_statblock": true}
672ce8e5-45c0-4faa-bd13-93987786e822	981e0906-addf-ca9b-c5e8-82659e6c64cf	HIPNOSE	PADRÃO	O carniçal domina a mente de um ser em alcance curto (Vontade DT 29 evita). A vítima fica sob controle telepático total do carniçal, e fará tudo que ele mandar, exceto tirar sua própria vida — em termos de jogo, fica sob controle do mestre. No final de cada turno do ser hipnotizado, ele pode repetir o teste de Vontade, com um bônus cumulativo de +1 por teste já realizado. Se passar, sai do comando do carniçal. O carniçal pode ter até três seres hipnotizados por vez. Caso o carniçal use essa habilidade em um alvo enlouquecendo, o ser falha automaticamente e fica permanentemente sob domínio do carniçal (até que o carniçal seja destruído). Um ser nesta condição pode até mesmo tirar a própria vida, se assim for comandado.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 211	{"parsed_from_statblock": true}
3a2998bd-c679-4d65-9cd2-e18a2aebd8ab	3e733982-0435-ca3a-40e2-20e2ac8d5195	FOICE DA MORTE	PADRÃO	\N	5O+40	5d10+20 Morte	1	2	\N	\N	\N	\N	PDF v1.1, p. 213	{"parsed_from_statblock": true}
4eabfc1e-efc7-478a-90ad-3989d94265e0	3e733982-0435-ca3a-40e2-20e2ac8d5195	TRANSPORTE PELO PÓ	MOVIMENTO	Enquanto estiver dentro da área criada por sua habilidade Cinzas das Terras Desoladas, o ceifador poderá usar uma ação de movimento para se transportar para outro espaço dentro dessa área. Quando terminar esse movimento, ele pode fazer um ataque com sua Foice da Morte como ação livre.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 213	{"parsed_from_statblock": true}
b8f37610-c899-460d-8eb6-35e70c30aaad	cf30b492-cace-69d4-8b39-8f091caf2499	GARRAS	PADRÃO	\N	2O+5	1d6+5 corte	1	2	\N	\N	\N	\N	PDF v1.1, p. 202	{"parsed_from_statblock": true}
03eb6ccc-589b-4279-b23e-e6c4e40ad7fa	981e0906-addf-ca9b-c5e8-82659e6c64cf	REANIMAR CORPOS	COMPLETA	Uma vez por cena, o Carniçal usa a Morte para fazer com que até 2d4+2 corpos em alcance médio sejam reanimados. Os reanimados agem de maneira violenta e bestial, atacando o ser mais próximo até serem destruídos. Use a ficha do Esqueleto de Lodo para esses corpos reanimados.	\N	\N	5	\N	\N	\N	\N	\N	PDF v1.1, p. 211	{"fixed_by": "008_fix_threat_data_v2", "summon_count": "2d4+2", "once_per_scene": true, "summoned_statblock": "esqueleto-de-lodo", "parsed_from_statblock": true}
d1b313fe-69a2-4656-ade1-c09f6e8212ae	3e733982-0435-ca3a-40e2-20e2ac8d5195	CONTEMPLAR A ESPIRAL	COMPLETA	O ceifador espiral usa sua foice para manifestar a verdadeira espiral da Morte. Todos os seres em alcance médio que consigam vê-lo sofrem 10d10+30 pontos de dano mental (Vontade DT 43 reduz à metade). Um ser que tenha sofrido dano desta habilidade fica imune a ela até final da cena.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 213	{"parsed_from_statblock": true}
44df391a-b7e8-44e7-a540-dfbed69460ad	3e733982-0435-ca3a-40e2-20e2ac8d5195	CINZAS DAS TERRAS DESOLADAS	COMPLETA	O ceifador espiral usa seus muitos braços para realizar um rito de invocação. Uma área de alcance longo em volta de si é tomada pelas cinzas das terras desoladas, um local acelerado pelo tempo onde tudo é transformado em pó. Cada ser dentro da área sofre 10d10+20 pontos de dano de Morte e fica enjoado (Fortitude DT 43 reduz o dano à metade e evita a condição). Um ser que termine seu turno dentro dessa área sofre 20 pontos de dano de Morte. Alguns desses raros casos descrevem lembranças de uma experiência ainda mais intensa. O que no princípio parecia ser uma visão de uma sequência de momentos da sua vida ia lentamente se distorcendo, espiralizando e se revelando uma silhueta com aspecto cada vez mais definido. E então, se tornava claro. Todos os seus mo- mentos sendo devorados por uma criatura, no fim de tudo. O rosto da Morte: o Ceifador Espiral. Todos aqueles que presenciaram o rosto se tornaram obcecados com a ideia da imortalidade, desesperados com a possibilidade de encontrar aquele ser novamente. Registros de civilizações isoladas ao redor do mundo todo foram encontrados relatando a presença de uma manifestação paranormal que se assemelhava às descrições do Ceifador Espiral,…	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 213	{"parsed_from_statblock": true}
6d00f36a-e121-4646-9529-1dac3d0a1940	0bcc85f7-b3dd-c1dd-d8b9-95c8f01a8dda	MORDIDA	PADRÃO	\N	3O+20	3d6+10 perfuração	1	2	\N	\N	\N	\N	PDF v1.1, p. 216	{"parsed_from_statblock": true}
22aa0213-b88f-48ad-a2d1-7efbaefc11f6	0bcc85f7-b3dd-c1dd-d8b9-95c8f01a8dda	VOMITAR LODO	MOVIMENTO	Uma vez por cena, na primeira rodada após ser manifestada, cada cópia do escutado despeja um jorro de Lodo em um ser em alcance curto. O alvo sofre 4d10+10 pontos de dano de Morte e fica lento até o fim da cena (Reflexos DT 25 reduz o dano à metade e evita condição).	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 216	{"parsed_from_statblock": true}
5b86bd03-e534-4e0c-a05b-510ef65e4ec2	48f329fb-339b-2f3c-ab5e-69c01707ec0e	GARRAS	PADRÃO	\N	2O+5	2d6+2 corte	1	2	\N	\N	\N	\N	PDF v1.1, p. 217	{"parsed_from_statblock": true}
aa3e2faa-1430-4cae-99b3-aba057c8515a	5e226c8d-e09f-ddc9-7963-811bd3cfa346	GARRA ENFAIXADA	PADRÃO	\N	4O+30	4d8+30 corte	1	2	\N	\N	\N	\N	PDF v1.1, p. 221	{"parsed_from_statblock": true}
8858aebc-cd91-4c64-bdc4-ba6885e9939c	5e226c8d-e09f-ddc9-7963-811bd3cfa346	VOMITAR LODO	PADRÃO	\N	5O+25	3d6+30 Morte mais 3d8 mental	2	2	Curto	\N	\N	\N	PDF v1.1, p. 221	{"parsed_from_statblock": true}
f8870a5f-adad-4bf1-92ce-f25b8fc904de	5e226c8d-e09f-ddc9-7963-811bd3cfa346	AGARRADA MUMIFICADORA	LIVRE	Se a múmia acertar um ataque de garra enfaixada ela pode agarrar o alvo (teste 4O+30). Enquanto estiver agarrada assim, a vítima sofre 4d8+30 pontos de dano de Morte no início de cada um dos seus turnos e a múmia recupera essa mesma quantidade de PV. Caso o ser seja reduzido a 0 PV dessa forma, se torna um esqueleto de lodo no começo do seu turno.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 221	{"parsed_from_statblock": true}
28de9a1e-ed05-4321-b3ad-cdf664ca046b	5e226c8d-e09f-ddc9-7963-811bd3cfa346	AMALGAMAR	PADRÃO	Enquanto está com 0 PV, a múmia pode amal- gamar um ser morto ou uma criatura de Morte adjacente. Se o fizer, ela se entrelaça com o alvo, tornando-se uma versão mais podero- sa de si mesma; ela recupera 200 PV, passa a atacar três vezes com suas garras enfaixadas e seus ataques causam +5 pontos de dano cada. Uma múmia que já esteja amalgamada com outro ser pode se amalgamar mais uma vez, combinando-se com um total de dois seres. Ao se amalgamar pela segunda vez, ela recupera mais 200 PV, passa a atacar quatro vezes com suas garras enfaixadas e aumenta o bônus de dano em +5 (para um total de +10 por ataque).	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 221	{"parsed_from_statblock": true}
a6cd829d-ff9f-4455-bf05-00053ddb093a	37785bcb-c312-1207-fa57-7c2553052220	GARRA INVERTIDA	PADRÃO	\N	5O+35	4d10+40	1	2	\N	\N	\N	\N	PDF v1.1, p. 224	{"parsed_from_statblock": true}
8d3ea718-d924-4858-8752-b5e435d1af6e	37785bcb-c312-1207-fa57-7c2553052220	MORDIDA INVERTIDA	PADRÃO	\N	5O+35	4d12+40 Morte	2	1	\N	\N	\N	\N	PDF v1.1, p. 224	{"parsed_from_statblock": true}
f804332a-a0ab-410b-8ba9-93c1f9b4245b	37785bcb-c312-1207-fa57-7c2553052220	REVERTER	LIVRE	Um ser que sofra dano das Garras Invertidas é afetado por um surto temporal capaz de apodrecer a carne. Ele fica enjoado até o final do seu próximo turno.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 224	{"parsed_from_statblock": true}
e9374fd3-fc6f-4a2c-8738-be42c99d86fe	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	SOCO ESPIRAL	PADRÃO	\N	6O+45	5d10+50 Morte	1	2	\N	\N	\N	\N	PDF v1.1, p. 230	{"parsed_from_statblock": true}
17f1b523-46a8-4be9-9d90-4e796499696f	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	AGARRÃO	LIVRE	Se o Deus da Morte acertar um ataque de Soco Espiral em um ser Médio ou menor, ela pode tentar agarrar o alvo (teste 6O+47).	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 230	{"parsed_from_statblock": true}
c06e7c84-6139-472f-97b8-a43483ffdee2	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	CONTROLAR RELÓGIO INTERNO	LIVRE	No início de cada um de seus turnos, o Deus da Morte encerra até duas condições que o estejam afetando.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 230	{"parsed_from_statblock": true}
ac43c137-9d89-4e03-8052-0fca198e3302	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	CONTROLAR MORTOS	MOVIMENTO	O Deus da Morte controla qualquer criatura de Morte em alcance longo, fazendo-as percorrer seu deslocamento e realizar um ataque.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 230	{"parsed_from_statblock": true}
da78e8de-96ca-4aaf-b0a3-8c619f3f3af3	40b5007f-2005-de03-e7f4-64783809fd47	PUNHO ESPINHENTO	PADRÃO	\N	3O+15	2d8+8 impacto mais 2d12 Morte	1	2	\N	\N	\N	\N	PDF v1.1, p. 214	{"parsed_from_statblock": true}
85f1d5a6-7532-4674-91ec-cf9454167c48	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	ESPIRAL DESCENDENTE	MOVIMENTO	O Deus da Morte acelera o tempo de um ser que esteja agarrando, mas faz com que ele sinta cada segundo passando, paralisado e sem poder agir. O ser envelhece 3d20 anos. Para cada ano envelhecido, sofre 1 ponto de dano mental.	\N	\N	5	\N	\N	\N	\N	\N	PDF v1.1, p. 230	{"parsed_from_statblock": true}
426bf28b-9f73-4cc4-b6b6-e59f5e791b04	a7e35038-1680-908a-be3a-60ad1debd522	DEDOS ALONGADOS	PADRÃO	\N	5O+40	4d10 Morte mais envelhecimento (veja Toque Acelerador, acima)	1	4	\N	\N	\N	\N	PDF v1.1, p. 226	{"parsed_from_statblock": true}
849747a1-0318-4efd-b5a0-670683caf17c	99c9e528-e4ec-2c7b-da9c-1fb4cece6b74	MORDIDA	PADRÃO	\N	4O+10	2d8+2 perfuração	1	1	\N	\N	\N	\N	PDF v1.1, p. 227	{"parsed_from_statblock": true}
ebe252fe-cd7f-45ec-beef-1c0620050ed6	7c0fbcb9-f9cb-a886-2517-8bd5f4bcc597	OLHARES DO SABER	PADRÃO	\N	4O+40	6d8+20 Conhecimento	2	2	Longo	\N	\N	\N	PDF v1.1, p. 234	{"parsed_from_statblock": true}
a6fc2484-4bc6-4a93-84ca-d8b19c998785	7c0fbcb9-f9cb-a886-2517-8bd5f4bcc597	FAIXAS DETENTORAS	LIVRE	Se o anjo acertar um ataque de Asas do Conhecimento em um ser Médio ou menor, pode tentar agarrar o alvo (teste 5O+45) usando as faixas que prendem suas asas. Um ser agarrado desta forma também fica fascinado. O anjo pode manter um ser agarrado desta forma por vez e fazer isso não impede que ele use suas Asas do Conhecimento.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 234	{"parsed_from_statblock": true}
55a42f91-bd01-4236-9d0b-8c77c19a354f	7c0fbcb9-f9cb-a886-2517-8bd5f4bcc597	CHAMAS REVELADORAS	PADRÃO	O anjo manifesta um círculo de chamas douradas em volta de si, que se expande em alcance médio. Todos os seres nesta área sofrem 10d8 pontos de dano de Conhecimento (Vontade DT 43 reduz à metade). Um ser que sofra dano dessa habilidade fica com uma auréola reveladora em cima de sua cabeça. Até o final da cena, o anjo sabe exatamente onde estão todos os seres com a auréola, o que significa que ele ignora furtividade e qualquer tipo de invisibilidade ou efeito ilusório.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 234	{"parsed_from_statblock": true}
40b9d494-81c1-4017-a3e9-9bc0e5a0141c	7c0fbcb9-f9cb-a886-2517-8bd5f4bcc597	RAIO DOURADO	COMPLETA	Uma vez por cena, o anjo dispara um raio dourado de seu olho central. Todos os seres em uma linha de 3m em alcance longo sofrem 15d8+50 pontos de dano de Conhecimento (Reflexos DT 43 reduz à metade). ENIGMA DE MEDO Seres puros de Conhecimento, os anjos podem ser enganados por seu alinhamento de Justiça Perfeita. Um anjo que falhe em julgar corretamente pode cair e ser alcançado por mortais. Quando o Enigma de Medo do anjo for resolvido, ele perde sua resistência a dano, seu deslocamento de voo e sua habilidade Julgamento.	\N	\N	5	\N	\N	\N	\N	\N	PDF v1.1, p. 234	{"parsed_from_statblock": true}
521f08dd-87f8-4f1c-8f5e-2fb3b8e4dd00	25556b0f-1ee2-f31a-5f84-21662ea3eeca	GARRAS ATORMENTADORAS	PADRÃO	\N	5O+35	4d10+10 Conhecimento	1	3	\N	\N	\N	\N	PDF v1.1, p. 237	{"parsed_from_statblock": true}
bcca0a47-3460-4204-ae45-ccd4c6235a83	25556b0f-1ee2-f31a-5f84-21662ea3eeca	ATORMENTAR	MOVIMENTO	O bicho papão envia sussurros e perturbações para um ser em alcance curto. O alvo sofre 3d8 pontos de dano mental (Vontade DT 30 reduz à metade). Caso o bicho papão esteja escondido do alvo, este dano aumenta em +3d8.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 237	{"parsed_from_statblock": true}
d77c2ec3-1f9c-4db0-b04f-3c7abe68fcd6	25556b0f-1ee2-f31a-5f84-21662ea3eeca	SALTAR E ASSUSTAR	COMPLETA	Se estiver escondido de um ser em alcance curto, o bicho papão pode sair do esconderijo e se aproximar deste ser. Enquanto faz isso, seu corpo aumenta e se retorce, assumindo uma forma assustadora. O ser do qual o bicho papão estava escondido sofre 10d8 pontos de dano mental (Vontade DT 35 reduz à metade). O bicho papão é uma criatura inteligente, que se comunica com suas vítimas através de sussurros e cantigas macabras durante o sono delas, implantando medos, paranóias e alucinações paranormais que apenas crescem com o passar dos dias. Porém, algumas cantigas infantis costumam manter a criatura entretida e distraída momentâneamente. Ela também pode ser enfurecida através do som de uma criança chorando, podendo ser facilmente enganada ou atraída por esse som. Quando um alvo da criatura já está com sua sanidade destroçada pela perturbação constante, o bicho papão se revela para sua vítima da forma mais apavorante possível, causando um desespero descomunal logo antes de devorá-la. Afinal, aqueles com mais medo devem ser mais deliciosos.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 237	{"parsed_from_statblock": true}
c1ba0d09-2408-43e0-8904-b73f040e9533	35167a4a-1da4-3662-c53c-1cc057cd8a9d	TOQUE SUTIL	PADRÃO	\N	5O+35	4d8+10 Conhecimento	1	3	\N	\N	\N	\N	PDF v1.1, p. 243	{"parsed_from_statblock": true}
04db1902-cb6f-4de5-bf2a-12553f37b852	35167a4a-1da4-3662-c53c-1cc057cd8a9d	APAGAR MEMÓRIA	LIVRE	Um ser que fique insano por conta dos ataques e efeitos do Estrangeiro tem consequências diferentes do que o habitual. A vítima tem a mente completamente controlada pelo Estrangeiro, que passa a controlar as ações do personagem. Como alternativa, o Estrangeiro pode apagar a memória da vítima e devolver um pouco de Sanidade (1d4) a ela, fazendo-a duvidar da existência do Estrangeiro e de seu encontro com esta criatura.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 243	{"parsed_from_statblock": true}
93b9eb4b-99ee-48fe-bab1-1ecb2a748072	35167a4a-1da4-3662-c53c-1cc057cd8a9d	RAJADA PSÍQUICA	PADRÃO	\N	5O+35	4d10+20 Conhecimento	2	2	Extremo	\N	\N	\N	PDF v1.1, p. 243	{"parsed_from_statblock": true}
3d1c898d-8fdd-4742-a59e-8e3181343f3c	b55d1509-2803-fc09-cd9a-66772751e758	BRAÇO LAMINADO	PADRÃO	\N	3O+10	1d12+10 corte	1	2	\N	18	\N	\N	PDF v1.1, p. 265	{"parsed_from_statblock": true}
0ecd7ff8-2743-474e-82e1-113c9a434cd8	35167a4a-1da4-3662-c53c-1cc057cd8a9d	OBLÍVIO	LIVRE	Um ser que sofra dano do Toque Sutil esquece momen- taneamente a existência do Estrangeiro (Vontade DT 30 evita). A vítima considera o Estrangeiro invisível e esquece qualquer interação que teve com ele. No final de cada um de seus turnos, o ser deve repetir o teste de Vontade. Se passar, volta a perceber a presença da criatura e encerra este efeito, mas sofre 6d6 pontos de dano mental. Uma vítima que esteja incubando uma larva de Estrangeiro (veja Incubar) não tem direito a repetir o teste de Vontade no final de seus turnos.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 243	{"parsed_from_statblock": true}
14ddb4ef-2de8-4981-b6d0-4274af79eeef	35167a4a-1da4-3662-c53c-1cc057cd8a9d	INCUBAR	COMPLETA	O Estrangeiro toca um ser adjacente e que esteja alheio a sua presença (veja Oblívio) e coloca uma larva dentro dele. Enquanto o ser está incubando uma larva, o Estrangeiro tem total acesso a sua mente, lendo pensamentos e memórias dele, mesmo a distância. A larva consome a Sanidade do hospedeiro, causando 1d6 pontos de dano mental no início de cada cena. Quando a Sanidade do hospedeiro é reduzida a 0, um novo Estrangeiro eclode de sua cabeça, matando-o instantaneamente.	\N	\N	5	\N	\N	\N	\N	\N	PDF v1.1, p. 243	{"parsed_from_statblock": true}
722b3938-e9ea-46a0-ac4f-660811e79c33	189034de-8f01-36a7-87c6-1126d93d3450	PANCADA	PADRÃO	\N	O+5	1d4+1 impacto	1	1	\N	\N	\N	\N	PDF v1.1, p. 240	{"parsed_from_statblock": true}
1d231b42-1f0c-4bc4-9dde-17a7b6a8896a	189034de-8f01-36a7-87c6-1126d93d3450	BRILHO ENLOUQUECEDOR	LIVRE	Uma vez por rodada, o existido faz suas marcas douradas brilharem. Todos os seres em alcance médio capazes de vê-lo sofrem 1d6 pontos de dano mental (Vontade DT 14 reduz à metade).	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 240	{"parsed_from_statblock": true}
db30f534-0c00-4864-aa9c-80b3623215d3	368972da-2308-bf04-7103-bca0de4932fd	PANCADA	PADRÃO	\N	2O+5	2d4+7 impacto	1	2	\N	\N	\N	\N	PDF v1.1, p. 241	{"parsed_from_statblock": true}
565ee643-af24-4074-9e48-f9e096f28707	368972da-2308-bf04-7103-bca0de4932fd	EXPANDIR AURA	PADRÃO	O lembrado expande sua aura. Seres em alcance curto sofrem 6d6 pontos de dano mental (Vontade DT 20 reduz à metade). Lembrado LEMBRADO Existem aqueles dentro da Realidade que vivem com um grande nível de exposição paranormal em suas mentes. É inevitável que essas pessoas criem uma espécie de resistência psicológica aos traumas gerados pelo Conhecimento do Outro Lado. Uma barreira mental capaz de suportar as lembranças mais enlouquecedoras. Mas o que acontece quando essa barreira se quebra, e o Conhecimento o consome por completo? Como uma enxurrada de segredos proibidos, a mente hu- mana se desintegra com as verdades impossíveis e as lembranças do que nunca deveria ser. O processo que transformaria alguém em um existido am- plificado pela contenção psicológica de uma alta exposição paranormal gera uma manifestação ainda mais intensa dentro da Realidade: o lembrado. Um ser amaldiçoado pelo desespero, que não se importa com a frivolidade da existência, o lembrado aspira apenas se tornar uma história memorável. Gritando o nome que lhe foi entregue pelo Outro Lado, os lembrados são capazes de cometer as atrocidades mais absurdas apenas para jamais serem esquecidos.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 241	{"parsed_from_statblock": true}
f8c6dd23-8535-499a-8d23-383ac3404518	af9ebb2d-0f65-c58e-27bd-dbdb8f62445c	CONJURAÇÃO VERDADEIRA	LIVRE	Uma vez por turno, a Máscara do Desespero pode conjurar um ritual de Conhecimento a sua escolha, de qualquer círculo e com tempo de execução máximo de uma ação completa. Ela pode gastar um máximo de 20 PE neste ritual e a DT para resistir a ele é 45.	\N	\N	1	\N	\N	\N	\N	\N	PDF v1.1, p. 254	{"parsed_from_statblock": true}
97546fcd-eacb-4091-b2ff-25b70a9a83cd	af9ebb2d-0f65-c58e-27bd-dbdb8f62445c	ONIPRESENÇA	MOVIMENTO	A Máscara do Desespero consegue se deslocar para qualquer local da Realidade, desde que haja algum tipo de sombra ou escuridão, independente da distância. Além disso, ela sabe exatamente tudo que está acontecendo na Realidade ao mesmo tempo. Isso faz com que nenhum personagem possa se esconder dela e ela ignora qualquer necessidade de ver ou ouvir para usar suas habilidades.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 254	{"parsed_from_statblock": true}
9df748f4-59a6-476b-b0b6-89868f1fc047	edbeef88-be85-94ce-b3af-00e5692c338e	PANCADA	PADRÃO	\N	2O+10	1d6+2 impacto	1	2	\N	\N	\N	\N	PDF v1.1, p. 238	{"parsed_from_statblock": true}
fee9afad-1434-475f-b66e-99d7833e5de7	edbeef88-be85-94ce-b3af-00e5692c338e	CORRER PELAS FRESTAS	MOVIMENTO	O espreitador pode se teletransportar para qualquer espaço em alcance longo, desde que exista uma pequena fresta em seu caminho (uma fresta é um espaço Pequeno ou menor, completamente delimitado por outro objeto ou superfície, como a fresta de porta entreaberta ou um pequeno buraco que atravessa uma parede).	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 238	{"parsed_from_statblock": true}
d8fc79c7-5ce8-462a-888c-66a15fcd0220	edbeef88-be85-94ce-b3af-00e5692c338e	ESPREITAR	COMPLETA	Uma vez por cena, se estiver adjacente a um ser que esteja dormindo, o espreitador causa 10d6 pontos de dano mental neste ser (Vontade DT 30 reduz à metade). Se a vítima ficar enlouquecendo devido a este dano, o espreitador pode criar uma cópia observada dela.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 238	{"parsed_from_statblock": true}
69ab51f3-7950-459e-a216-51f59a99dec9	edbeef88-be85-94ce-b3af-00e5692c338e	CÓPIA OBSERVADA	PADRÃO	O espreitador manifesta uma cópia de um ser que tenha deixado enlouquecendo com sua habilidade Espreitar. A cópia utiliza a mesma ficha do ser, mas causa dano de Conhecimento em vez de seu dano normal, não pode conjurar rituais ou usar habilidades paranormais e dura até o fim da cena.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 238	{"parsed_from_statblock": true}
29cb2806-871a-45ad-89ac-9d7361ff50a3	15b07f11-8cdc-d86d-eebd-b745d86cb108	RETALIAÇÃO	REAÇÃO	Toda vez que for atacado ou alvo de uma habilidade, o ocioso se teletrans- porta para ficar adjacente ao atacante e faz um ataque corpo a corpo contra ele (teste 5O+30, dano 4d10+20 de impacto não letal).	\N	\N	1	\N	\N	\N	\N	\N	PDF v1.1, p. 244	{"parsed_from_statblock": true}
be70640f-5484-41a5-adb0-439e5d2d5caa	15b07f11-8cdc-d86d-eebd-b745d86cb108	PERMANECER PRÓXIMO	LIVRE	Uma vez por rodada, o ocioso pode se teletransportar para qualquer ponto dentro do campo de visão do alvo.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 244	{"parsed_from_statblock": true}
d34e2f9a-eef1-47ac-b718-ef7fec1f629f	4c29680f-753d-b300-6316-69ab128fbd3f	PANCADA	PADRÃO	\N	O	1d4 impacto	1	1	\N	\N	\N	\N	PDF v1.1, p. 246	{"parsed_from_statblock": true}
644475f1-6168-45ab-a73a-eab4c68fcdf8	4c29680f-753d-b300-6316-69ab128fbd3f	FIXAR	COMPLETA	O parasita se aproxima de um personagem dormindo. O personagem tem direito a um teste de Percepção (com penalidade de –OO, por estar dormindo), oposto ao teste de Furti- vidade do parasita (2O+15). Se passar, desperta antes que o parasita se fixe nele, fazendo com que a criatura fuja. Se falhar, torna-se hospe- deiro do parasita (veja Devorar Culpa).	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 246	{"parsed_from_statblock": true}
1fe67180-5565-46c0-bbb0-de454a0d6c6a	4c29680f-753d-b300-6316-69ab128fbd3f	ATORMENTAR	COMPLETA	Se estiver fixado a um hospedeiro, o parasita atormenta a mente do personagem e de todos que ele estiver mantendo inconscientes. No início de cada cena do sonho, todos os personagens dentro do sonho sofrem 2d6 pontos de dano mental (Vontade DT 20 reduz à metade).	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 246	{"parsed_from_statblock": true}
00767064-5af3-447d-865b-9b61e37ba7b5	4c29680f-753d-b300-6316-69ab128fbd3f	CÓPIAS DO HOSPEDEIRO	COMPLETA	Se estiver fixado a um hospedeiro, o parasita manifesta uma cópia feita de Conhecimento desse personagem. A cópia possui as mesmas estatísticas do original, mas tem 20 PV e todo dano que causa é de Conhecimento. O parasita pode manifestar no máximo quatro cópias por vez. Se manifestar uma cópia dentro do sonho, ela usa o valor de Presença do parasita no lugar dos seus atributos e causa dano mental em vez do normal. ENIGMA DE MEDO Para derrotar o parasita de culpa, os personagens devem perceber que estão vivendo um sonho compartilhado, e identificar qual personagem dentro do sonho é o hospedeiro do parasita. Após descobrir isso, o hospedeiro deve confrontar as manifestações e derrotá-las dentro do sonho, sozinho. Um sonho compartilhado é uma sequência de cenas que ocorrem na mente dos personagens. Com exceção dos próprios personagens, tudo que existe no sonho é um construto de Conhecimento. Enquanto estiverem dentro do sonho, os agentes agem normalmente, conforme o tipo de cena que o sonho está simulando. O mestre determina como os personagens podem descobrir que estão em um sonho, e quais ameaças enfrentarão nele.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 246	{"parsed_from_statblock": true}
1e10dfe3-ef06-47e3-92c7-58d4f6a6c5b9	63b121c2-516a-f562-feac-b6886de8f29f	TOQUE DA DOR	PADRÃO	\N	4O+20	4d8+5 Conhecimento	1	3	\N	\N	\N	\N	PDF v1.1, p. 248	{"parsed_from_statblock": true}
27be9ccc-ad14-4b9f-bef1-e6f513b9cd99	2f48e0be-c76c-6a21-2b44-5774b1103744	ASSASSINAR	MOVIMENTO	O assassino analisa uma criatura em alcance cur- to. Até o fim de seu próximo turno, seu primeiro Ataque Furtivo q	\N	\N	5	\N	\N	\N	\N	\N	PDF v1.1, p. 285	{"parsed_from_statblock": true}
87f33fdd-49bb-4eb4-acd2-5acd1d85827c	63b121c2-516a-f562-feac-b6886de8f29f	RASTEJAR	LIVRE	O rastejador usa as sombras para se aproximar de seus alvos. Até o início do seu próximo turno, se estiver sob cobertura ou camuflagem parcial, o rastejador recebe +10 em Furtividade e não terá o deslocamento reduzido por se mover furtivamente.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 248	{"parsed_from_statblock": true}
a4aa27f9-f92d-41b5-83ff-96926acbb157	63b121c2-516a-f562-feac-b6886de8f29f	TENTÁCULOS DAS SOMBRAS	MOVIMENTO	O rastejador coloca suas garras no chão e as fibras que compõem seu corpo são projetadas pelas sombras a até três seres em alcance médio, que ficam agarrados por elas (Reflexos DT 28 evita). Com uma ação de movimento, o rastejador pode arrastar até três vítimas agarradas dessa maneira para outros pontos em alcance médio de si. Em seu turno, um ser pode tentar se soltar como normal. No final de cada um dos seus turnos, um ser que esteja agarrado desta forma sofre 4d6 pontos de dano mental. Rastejador Sombrio	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 248	{"parsed_from_statblock": true}
d786bdc9-89ef-404f-8468-f9848f0cd595	04f6c70d-ccd0-6736-5a7e-8b4380e81ecc	REESCREVER A REALIDADE	LIVRE	Enquanto estiver se deslocando, a silhueta pode reescrever e mudar a Realidade com seus sigilos de Conhecimento. Todos os objetos em alcance curto podem ser transformados em outros, desde que conservem o mesmo tamanho. Seres vivos e o equipamento que estiverem vestindo ou portando não são afetados por essa habilidade.	\N	\N	1	\N	\N	\N	\N	\N	PDF v1.1, p. 250	{"parsed_from_statblock": true}
d1bbcc76-0640-4e19-8c40-071c97642c75	04f6c70d-ccd0-6736-5a7e-8b4380e81ecc	TOQUE DEVASTADOR	PADRÃO	A silhueta raramente age de maneira agressiva, mas quando precisa remover algo de seu caminho ela simplesmente o toca, causando o dano de sua aura tangível. A silhueta pode tocar até dois seres e/ou objetos com esta ação.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 250	{"parsed_from_statblock": true}
a1c0556c-59c2-4942-aeea-a0f359c64646	eeb94d35-292d-e7b1-8686-0a2ea8a0ee90	TOQUE MACABRO	PADRÃO	\N	4O+10	2d6 Conhecimento	1	2	\N	\N	\N	\N	PDF v1.1, p. 251	{"parsed_from_statblock": true}
dabf8243-3bd0-41c1-a3a5-1576211e5d1c	2faad71f-e963-0d04-806c-e49455fac533	PANCADA ERRÁTICA	PADRÃO	\N	2O+5	2d12 impacto	1	1	\N	\N	\N	\N	PDF v1.1, p. 257	{"parsed_from_statblock": true}
c6d43510-fe75-4455-9005-77acdd15255d	72b4164d-66cb-3f52-c4c8-8fcb403bba7d	PANCADA ENERGÉTICA	PADRÃO	\N	4O+15	4d12 impacto	1	2	\N	\N	\N	\N	PDF v1.1, p. 259	{"parsed_from_statblock": true}
005a5f1b-7051-41d2-9a10-895f8bda2fd0	15b07f11-8cdc-d86d-eebd-b745d86cb108	ATERRORIZAR	COMPLETA	Um alvo adjacente sofre 4d10+10 de dano mental.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 244	{"parsed_from_statblock": true}
412685a5-6344-435a-bee0-303056c53d1a	72b4164d-66cb-3f52-c4c8-8fcb403bba7d	AUTODESTRUIÇÃO	MOVIMENTO	O anárquico concentra Energia no seu corpo e se auto destrói, causando 8d12 pontos de dano de Energia em todos os personagens em alcance curto (Reflexos DT 25 reduz à metade). Personagens adjacentes ao anárquico Descon- trolado sofrem – OO neste teste de resistência. O anárquico descontrolado morre após usar essa habilidade.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 259	{"parsed_from_statblock": true}
a7549394-ba6f-4148-b29c-dc6136d6a9f0	d6ecb2e4-bd05-093f-d43f-26dca3d354bb	ROMPER CONSCIÊNCIA	LIVRE	No início do turno da anomalia, ela sorteia um ser que esteja em sua linha de visão e tenta romper sua razão transformando suas ondas cerebrais. A vítima sofre 10d6 pontos de dano mental (Vontade DT 41 reduz à metade) e, se ficar insana devido a este dano, é absor- vida pela anomalia.	\N	\N	1	\N	\N	\N	\N	\N	PDF v1.1, p. 261	{"parsed_from_statblock": true}
1f16cac4-5b60-476d-9534-d32078bd8fbd	d6ecb2e4-bd05-093f-d43f-26dca3d354bb	MANIPULAR ONDAS DA EXISTÊNCIA	LIVRE	No final do turno da anomalia, ela manipula as ondas eletromagnéticas que compõem a própria existência. Ela pode ativar, desativar ou operar até seis objetos tecnológicos em alcance médio. Como alternativa, pode sobrecarregar estes objetos, gerando uma poderosa descarga que causa 2d12 pontos de dano de Energia por objeto em todos os seres na área (Reflexos DT 30 reduz à metade).	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 261	{"parsed_from_statblock": true}
250cace1-4910-48d4-8d59-28ecbab92df7	d6ecb2e4-bd05-093f-d43f-26dca3d354bb	MANIFESTAR O IMPOSSÍVEL	COMPLETA	A anomalia invoca uma ou mais criaturas de Energia cujo VD total some até 240. As criaturas aparecem em alcance curto da anomalia e agem a partir da próxima rodada, seguindo seus impulsos caóticos. v ENIGMA DE MEDO A anomalia não deveria existir. Ela é o próprio caos colapsando com a Realidade, e não existe lógica para defini-la. A única forma de combater essa criatura é mergulhar na anomalia para entendê-la no Outro Lado. Quando o Enigma de Medo da anomalia for resolvido, ela se transforma em um ser ou objeto aleatório por 2d4 rodadas. Durante esse tempo, ela perde sua imunidade a dano e condições e usa as estatísticas do ser ou objeto, com exceção de seus PV.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 261	{"parsed_from_statblock": true}
72766bd1-56e4-412d-90df-d0774320c479	b55d1509-2803-fc09-cd9a-66772751e758	PUNHO ENERGIZADO	PADRÃO	\N	3O+10	2d8+10 impacto	2	1	\N	\N	\N	\N	PDF v1.1, p. 265	{"parsed_from_statblock": true}
d4eb208a-b3ba-4330-8d9c-4af0dd436d09	b55d1509-2803-fc09-cd9a-66772751e758	INVESTIDA ENERGÉTICA	COMPLETA	O ciborgue avança até 24m (18) e faz um ataque de punho energizado com bônus de +O no teste de ataque. Se acertar, causa +2d8 de dano (para um total de 4d8+10) e derruba o alvo (Fortitude DT 20 evita a queda). Estado GAMA	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 265	{"parsed_from_statblock": true}
ce02446a-bd38-469b-b940-e7a0f2b0a7da	b55d1509-2803-fc09-cd9a-66772751e758	RAIO ENERGÉTICO	PADRÃO	\N	3O+10	1d12+5 Energia	5	1	Médio	\N	\N	\N	PDF v1.1, p. 265	{"parsed_from_statblock": true}
cb99dbbb-61e7-4c55-9041-497a99b39f96	b55d1509-2803-fc09-cd9a-66772751e758	CRIAR BARREIRA	MOVIMENTO	O ciborgue expande suas correntes de Energia e cria uma barreira paranormal. Ele recebe +5 na Defesa até o início de seu próximo turno.	\N	\N	6	\N	\N	\N	\N	\N	PDF v1.1, p. 265	{"parsed_from_statblock": true}
b149bf86-bbbf-4ada-b813-9638336ca34f	b55d1509-2803-fc09-cd9a-66772751e758	REINICIAR	MOVIMENTO	O ciborgue encerra uma condição que o esteja afetando.	\N	\N	7	\N	\N	\N	\N	\N	PDF v1.1, p. 265	{"parsed_from_statblock": true}
bb02d57b-59b5-4b1e-bed2-bd5646395184	9e5601b2-bd2e-485a-ee50-8082f3a83a92	MACHETE	PADRÃO	\N	3O+17	1d6+15 corte	1	2	\N	19	\N	\N	PDF v1.1, p. 285	{"parsed_from_statblock": true}
3f1d16a8-3d4f-425e-93ff-e86839bb0836	9e5601b2-bd2e-485a-ee50-8082f3a83a92	METRALHADORA	PADRÃO	\N	2O+17	3d12+15 balístico	2	2	Médio	19/x3	\N	\N	PDF v1.1, p. 285	{"parsed_from_statblock": true}
3cb1bcd8-3d83-48cc-b450-0ad577d6bcfd	9e5601b2-bd2e-485a-ee50-8082f3a83a92	ATAQUE EM MOVIMENTO	COMPLETA	O chefe mercenário pode percorrer seu deslocamento e atacar em qualquer ponto durante o movimento. Ele pode fazer seus dois ataques corpo a corpo ou à distância.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 285	{"parsed_from_statblock": true}
3c890b08-0aff-4263-b78b-a69a6087e3f1	b55d1509-2803-fc09-cd9a-66772751e758	DESORIENTAR	LIVRE	Um ser que sofra dano do raio energético fica alquebrado. Se já estiver alquebrado, fica ator- doado por uma rodada (Vontade DT 20 evita). ENIGMA DE MEDO O ciborgue é programado pela Energia para alterar seu estado de combate frequentemente. Cada estado possui uma fraqueza específica, determinada quando ele é criado pela Entidade. Exemplos de fraquezas incluem sofrer 15 pontos de dano de um tipo específico em um único ataque ou ser exposto a uma substância ou material específico. Uma fraqueza só pode ser resolvida se o cibor- gue estiver no estado de combate correspondente. Quando a fraqueza for resolvida, ele não poderá assumir mais esse estado de combate. Quando ficar sem nenhum estado de combate, ele se desativa: sua Defesa é reduzida para 10 e seu deslocamento para 0m.	\N	\N	8	\N	\N	\N	\N	\N	PDF v1.1, p. 265	{"parsed_from_statblock": true}
9921c3cf-a560-4613-a710-75a3dc724aa4	4686e4e2-c047-5691-fbc4-11eb224493eb	PANCADAS INFECTADAS	PADRÃO	\N	5O+30	4d12+20 Energia	1	3	\N	\N	\N	\N	PDF v1.1, p. 267	{"parsed_from_statblock": true}
a16dfc44-beed-406d-931f-d5a7df329012	4686e4e2-c047-5691-fbc4-11eb224493eb	INFECÇÃO	LIVRE	Um ser que sofra dano das pancadas fica infectado com a doença vírus do infecticídio (Fortitude DT 30 evita). Um ser que passe no teste de resistência fica imune a essa doença até final da cena.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 267	{"parsed_from_statblock": true}
f52245d3-264d-4d60-a27d-2dc06e601c91	4686e4e2-c047-5691-fbc4-11eb224493eb	CONSUMAÇÃO INSIDIOSA	REAÇÃO	Se reduzir um ser a 0 PV com suas pancadas infectadas, o infecticídio consome a vítima, recuperando 50 PV.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 267	{"parsed_from_statblock": true}
ad9c65bb-6e7f-408f-b96d-8b5808a0ae55	4686e4e2-c047-5691-fbc4-11eb224493eb	ATROPELAR	COMPLETA	O infecticídio percorre até o dobro do seu deslocamento, podendo passar pelo espaço de outros seres. Durante esse deslocamento, ele faz um ataque de pancada infectada contra cada ser nos espaços pelos quais passar. Os seus corpos então se tornam deformados, com os olhos tomando uma forma manchada com cores pulsantes e os dentes se tornando pontudos e bri- lhosos. O contágio da criatura pode ser feito através de contato direto com sangue ou saliva, como uma doença comum, mas ele também é capaz de se espa- lhar como um vírus digital, infectando dispositivos tecnológicos como celulares e computadores, e a partir deles infectando seus usuários. É possível exterminar o infecticídio por completo apenas eliminando todos aqueles que foram domina- dos pela criatura e congelando seus corpos para que o vírus perca sua capacidade de transmissão. Infecticídio	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 267	{"parsed_from_statblock": true}
02a80dfc-a468-46a4-9041-00b431b5321e	22118520-6be3-b02f-f935-50333c06403e	GARRA DESINTEGRADORA	PADRÃO	\N	5O+30	4d12+20 Energia	1	2	\N	\N	\N	\N	PDF v1.1, p. 263	{"parsed_from_statblock": true}
e36548ef-9b01-45f3-8153-e93e64e6d9ea	b55d1509-2803-fc09-cd9a-66772751e758	CANHÃO	PADRÃO	\N	3O+10	4d12+5 Energia	4	1	Longo	\N	\N	\N	PDF v1.1, p. 265	{"parsed_from_statblock": true}
4faea453-f7df-4451-87b0-1e58e793f584	600edb81-50a4-7ce3-bd94-7597458ec444	TEATRO (Amphitruo)	PADRÃO	O Anfitrião envia a imagem de um texto praticamente incompreensível para a mente do alvo, que deve decorá-lo em poucos segundos e recitá-lo perfeitamente ou sofre 10d6 pontos de dano mental (Artes DT 35 ou Vontade DT 45 evita).	\N	\N	1	\N	\N	\N	\N	\N	PDF v1.1, p. 278-279	{"parsed_from_statblock": true}
b9903b8f-531c-4082-9f27-5d19f17bbb6f	600edb81-50a4-7ce3-bd94-7597458ec444	QUEIMAR (Aeneas)	PADRÃO	O Anfitrião dispara chamas em um cone em alcance médio. Todos os seres nessa área sofrem 10d6+20 pontos de dano de Energia (Reflexos DT 45 reduz à metade).	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 278-279	{"parsed_from_statblock": true}
0e2b7293-aa97-403e-9f88-b50b55569bf2	600edb81-50a4-7ce3-bd94-7597458ec444	CORTE CAÓTICO	PADRÃO	\N	7O+45	3d12+20 Energia	3	1	\N	\N	\N	\N	PDF v1.1, p. 278-279	{"parsed_from_statblock": true}
810f6ab3-89f7-4dc1-9eac-095c1a9bea81	600edb81-50a4-7ce3-bd94-7597458ec444	ROMANCE FORÇADO (Liber)	LIVRE	Se acertar um ser com seu Golpe Caótico, o Anfitrião pode escolher outro ser que consiga ver. Os dois seres devem decidir entre si quem sofrerá o dano do ataque (isso deve ser feito antes do dano ser definido).	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 278-279	{"parsed_from_statblock": true}
d92c2017-e6e9-4bec-94ce-669a0ba4a8f5	600edb81-50a4-7ce3-bd94-7597458ec444	LANÇA E ADAGA	PADRÃO	\N	7O+45	2d12+20 Energia	5	2	\N	\N	\N	\N	PDF v1.1, p. 278-279	{"parsed_from_statblock": true}
923ab078-c89b-4e53-a01b-7e85197a4f5c	600edb81-50a4-7ce3-bd94-7597458ec444	EU SOU O CAOS (Plautus)	LIVRE	Se acertar um ataque de Lança e Adaga em um ser desprevenido ou flanqueado, O Anfitrião causa +4d12 pontos de dano de Energia.	\N	\N	6	\N	\N	\N	\N	\N	PDF v1.1, p. 278-279	{"parsed_from_statblock": true}
4eda5173-f3e3-4f9a-beb5-6eeaec5ef2e6	600edb81-50a4-7ce3-bd94-7597458ec444	CORTE DE ÁGUA	PADRÃO	\N	7O+45	5d12+20 Energia	7	1	\N	\N	\N	\N	PDF v1.1, p. 278-279	{"parsed_from_statblock": true}
2c540759-6bdd-47ed-987a-54a94e01125f	600edb81-50a4-7ce3-bd94-7597458ec444	AFOGAMENTO (Silenus)	LIVRE	Um ser que sofre dano de Corte de Água fica asfixiado (Fortitude DT 35 evita). Um ser que esteja afixiado dessa forma pode repetir o teste de Fortitude no fim de cada um de seus turnos; se passar, a condição termina.	\N	\N	8	\N	\N	\N	\N	\N	PDF v1.1, p. 278-279	{"parsed_from_statblock": true}
a0caeb87-fb2d-46b8-ba8f-8e23508e6a73	600edb81-50a4-7ce3-bd94-7597458ec444	TELETRANSPORTE	MOVIMENTO	O Anfitrião se transporta para outro ponto em alcance médio. Anfitrião Silenus Aeneas Plautus Liber Amphitruo	\N	\N	9	\N	\N	\N	\N	\N	PDF v1.1, p. 278-279	{"parsed_from_statblock": true}
b29cbb88-07fb-4a97-9c1a-863aebd16fc8	20f91d11-1834-d40f-02c1-8e8a0c81ee63	AGARRÃO	LIVRE	Se a sukkalgir acertar um ataque com sua mordida em um ser Médio ou menor, pode agarrar o alvo (teste 3O+15).	\N	\N	1	\N	\N	\N	\N	\N	PDF v1.1, p. 269	{"parsed_from_statblock": true}
f93bdc01-9159-4a99-b605-5465e55ca9ea	9d273d68-1267-1193-d4e4-d7aade51df78	GARRAS RADIOATIVAS	PADRÃO	\N	5O+40	4d20+20 Energia *As garras radioativas do Tempestuoso podem atingir alvos em alcance curto, mesmo sendo ataques corpo	1	2	\N	\N	\N	\N	PDF v1.1, p. 273	{"parsed_from_statblock": true}
d7b24797-bc48-4012-9f71-9c0fd38109fc	9d273d68-1267-1193-d4e4-d7aade51df78	RAIO DE ENERGIA RADIOATIVA	LIVRE	Quando acerta dois ataques de garras radioativas em um mesmo ser, o tempestuoso faz com que um raio de energia radioativa seja projetado deste ser em direção a outro alvo em alcance médio. Este alvo sofre 4d20+20 pontos de dano de Energia (Reflexos DT 40 reduz à metade).	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 273	{"parsed_from_statblock": true}
c7cc5526-89cf-4c29-bf5e-5c41788bbd75	9e5601b2-bd2e-485a-ee50-8082f3a83a92	ORDENS	MOVIMENTO	O chefe mercenário grita ordens para seus aliados em alcance médio. Eles recebem +O em testes de perícia e causam mais um dado de dano do mesmo tipo até o fim da cena.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 285	{"parsed_from_statblock": true}
98d1c7d1-299d-480c-addb-e0c09d4c05a3	9d273d68-1267-1193-d4e4-d7aade51df78	EXPANDIR EM RADIAÇÃO	COMPLETA	O tempestuoso concentra energia radioativa em volta de si para depois expandi-la como uma explosão de Energia. Cada ser em alcance longo sofre 10d20+20 pontos de dano de Energia (Reflexos DT 40 reduz à metade). O próprio tempestuoso perde 100 PV quando usa esta habilidade. Registros de encontros com tempestuosos foram descritos por testemunhas como sons ensurdecedores que poderiam ser confundidos com raios violentos caindo em uma tempestade enfurecida. Um tempestuoso só pode ser originado em um am- biente com a Membrana extremamente danificada e em condições muito específicas, como usinas radioa- tivas abandonadas, e seus efeitos perduram mesmo muito tempo depois, como se ele emitisse algum tipo de radiação paranormal ao seu redor, muito mais perigosa que radiação nuclear. O encontro com um tempestuoso exige um preparo imponderável, equipamentos de alta proteção e, acima de tudo, muita sorte.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 273	{"parsed_from_statblock": true}
b02aff53-9ce1-4371-8b33-64e53d4d4af6	cab21581-a023-2e27-8178-fa3898890bd4	TOQUE DESINTEGRADOR	PADRÃO	\N	4O+35	6d12+30 Energia	1	3	\N	\N	\N	\N	PDF v1.1, p. 271	{"parsed_from_statblock": true}
07473269-fa75-4cc8-af98-c395e6a3a361	cab21581-a023-2e27-8178-fa3898890bd4	VIAJAR PELA TELA	MOVIMENTO	O telopsia pode se desmaterializar e se materializar em outra tela ou visor em alcance longo. Em seguida, ele se desloca 9m.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 271	{"parsed_from_statblock": true}
b0f87648-74a8-4f9e-ae61-3f387c67dc80	cab21581-a023-2e27-8178-fa3898890bd4	TELA ZUMBIFICADORA	PADRÃO	O telopsia projeta imagens enlouquecedoras em sua tela. Todos os seres em alcance médio sofrem 6d6 pontos de dano mental ficam confusos até final da cena (Vontade DT 30 reduz o dano à metade e evita a condição). Um ser que já esteja confuso e falhe no teste de resistência fica também fascinado.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 271	{"parsed_from_statblock": true}
7991d551-b3aa-4f4e-8699-e8b846dd81a9	e4866d22-2413-8a10-dc2f-30681c33a483	ESTACAR	LIVRE	Quando causa dano com sua mordida, pode prender o alvo com Lodo de Morte. A vítima sofre +1d10 de dano de Morte e fica agarrada. Pode se soltar com uma ação padrão e Atletismo DT 20; personagens adjacentes podem usar uma ação padrão para ajudá-la.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 209	{"parsed_from_statblock": true}
1fe38a96-74e7-4904-884b-244b05371b23	c9a49ecf-895c-9dac-0185-2e23764358cd	PANCADA	PADRÃO	\N	4O+15	2d12+10 impacto	1	2	\N	\N	\N	\N	PDF v1.1, p. 274	{"parsed_from_statblock": true}
56174810-7afe-4b6f-9ff3-f4849b310516	c9a49ecf-895c-9dac-0185-2e23764358cd	AGARRÃO	LIVRE	Se o viajante acerta um ataque com sua pancada em um ser Médio ou menor, pode tentar agarrar o alvo (teste 4O+15).	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 274	{"parsed_from_statblock": true}
10db2c37-1a36-4922-b55e-d70440978b0b	f87384c2-4e60-56db-a5de-3d654357a796	PANCADA	PADRÃO	\N	5O+35	8d8+20 impacto	1	2	\N	\N	\N	\N	PDF v1.1, p. 282	{"parsed_from_statblock": true}
2524330e-f8fb-41bc-b388-0f1a6cec5e9c	f87384c2-4e60-56db-a5de-3d654357a796	AGARRAR E ESTRANGULAR	LIVRE	Se a degolificada acertar um ataque de pancada em um personagem Médio ou menor, ela pode tentar agarrar o alvo (teste 5O+35). Enquanto estiver agarrado desta forma, o personagem também fica asfixiado. A degolificada pode manter até duas criaturas agarradas por vez.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 282	{"parsed_from_statblock": true}
2f7972ff-0819-4a2b-bc08-a74ded31fd12	f87384c2-4e60-56db-a5de-3d654357a796	GRITO RASGADO	LIVRE	A degolificada rompe a vedação de sua boca e emite um grito ensurdecedor. Cada personagem em alcance médio sofre 4d10+10 pontos de dano mental e um efeito determinado aleatoriamente rolando 1d4 na tabela a seguir (Vontade DT 35 reduz o dano à metade e evita o efeito). Cada um desses efeitos é considerado uma lesão (ver página 174). A degolificada só pode usar esta habilidade uma vez por cena. 1 Surdo dos dois ouvidos permanentemente 2 Surdo de um ouvido permanentemente 3 Surdo de dois ouvidos até o final da cena 4 Surdo de um ouvido até o final da cena	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 282	{"parsed_from_statblock": true}
8dcdb213-c8fb-4dd8-ad11-011316cc70da	f87384c2-4e60-56db-a5de-3d654357a796	DESFIGURAMENTO CAPILAR	MOVIMENTO	A degolificada usa seus longos cabelos para penetrar os orifícios faciais e seus olhos vazios para perturbar a alma de suas vítimas. Cada personagem agarrado por ela sofre 10d6+20 pontos de dano de perfuração (Fortitude DT 35 reduz à metade) e 6d10 pontos de dano mental (Vontade DT 35 reduz à metade).	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 282	{"parsed_from_statblock": true}
e33fc80d-595b-4d89-b9af-a6148f04db37	cad9d205-0e8c-9d91-0142-7243852739f9	FACA	PADRÃO	\N	2O+5	1d4+2 perfuração	1	1	\N	\N	\N	\N	PDF v1.1, p. 284	{"parsed_from_statblock": true}
149f96d5-2f65-44a7-bf58-fd0895283307	cad9d205-0e8c-9d91-0142-7243852739f9	ATAQUE FURTIVO	LIVRE	Uma vez por rodada, o bandido causa +1d6 pontos de dano com ataques corpo a co	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 284	{"parsed_from_statblock": true}
2d8ae4fa-ad8e-4fa7-b4df-6882c7f29648	bf633d83-4d78-4b53-2e47-316dfd0e1768	BASTÃO	PADRÃO	\N	2O+5	1d8+7 impacto	1	1	\N	\N	\N	\N	PDF v1.1, p. 284	{"parsed_from_statblock": true}
871654dd-de30-4875-a5ac-73546f5df162	bf633d83-4d78-4b53-2e47-316dfd0e1768	REVÓLVER	PADRÃO	\N	O+5	2d6+5 balístico	2	1	Curto	19/x3	\N	\N	PDF v1.1, p. 284	{"parsed_from_statblock": true}
3d3f08da-d75f-4466-88e2-43461331c92f	bf633d83-4d78-4b53-2e47-316dfd0e1768	ATAQUE FURTIVO	LIVRE	Uma vez por rodada, o capanga causa +2d6 pontos de dano com ataques corpo a corpo, ou à	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 284	{"parsed_from_statblock": true}
46c98141-c137-4304-acb1-afe98b132023	6854df88-14b7-ca24-c1f7-31288fffdd87	MACHETE	PADRÃO	\N	2O+10	1d6+9 corte	1	1	\N	19	\N	\N	PDF v1.1, p. 284	{"parsed_from_statblock": true}
83102330-dca2-4d4f-a2ba-188098cc3489	6854df88-14b7-ca24-c1f7-31288fffdd87	FUZIL DE ASSALTO	PADRÃO	\N	2O+10	2d8+9 balístico	2	1	Médio	19/x3	\N	\N	PDF v1.1, p. 284	{"parsed_from_statblock": true}
55aa1887-ce2d-49e2-b5f6-e2da43bf40da	6854df88-14b7-ca24-c1f7-31288fffdd87	ATAQUE EM MOVIMENTO	COMPLETA	O soldado de aluguel pode percorrer seu deslocamento e atacar em qualquer ponto durante o movimento.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 284	{"parsed_from_statblock": true}
64b0678c-90b4-451f-9e91-1bc167c99222	2f48e0be-c76c-6a21-2b44-5774b1103744	FACA	PADRÃO	\N	4O+17	1d4+11 corte	1	2	\N	19	\N	\N	PDF v1.1, p. 285	{"parsed_from_statblock": true}
625e5901-7a9b-4408-afba-4657fcd515f5	2f48e0be-c76c-6a21-2b44-5774b1103744	PISTOLA	PADRÃO	\N	4O+15	1d12+14 balístico	2	2	Curto	16/x4	\N	\N	PDF v1.1, p. 285	{"parsed_from_statblock": true}
18fe385a-2332-44b2-820f-14b5ab1e121f	2f48e0be-c76c-6a21-2b44-5774b1103744	ATAQUE FURTIVO	LIVRE	Uma vez por rodada, o assassino causa +4d6 pontos de dano com ataques corpo a corpo, ou à distância em alcance curto, contra alvos desprevenidos ou que esteja flanqueando.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 285	{"parsed_from_statblock": true}
ffeaaa48-a0d8-4688-bdb4-f3d082da6f64	2f48e0be-c76c-6a21-2b44-5774b1103744	MÃO NA BOCA	LIVRE	Quando faz um ataque corpo a corpo furtivo contra uma criatura desprevenida, o assassino pode fazer um teste de agarrar (teste 2O+15). Se agarrar a criatura, ela não poderá falar enquanto estiver agarrada.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 285	{"parsed_from_statblock": true}
730eb5d2-015b-4f06-ae3c-5c0df196dd08	5c2807af-f19e-54f2-27a2-22abbb0018eb	FACA	PADRÃO	\N	2O+10	1d4+1 corte	1	1	\N	19	\N	\N	PDF v1.1, p. 286	{"parsed_from_statblock": true}
e6d8b280-a2dd-4b51-8f9b-7bec4d8c4438	5c2807af-f19e-54f2-27a2-22abbb0018eb	REVÓLVER	PADRÃO	\N	2O+5	2d6 balístico	2	1	Curto	19/x3	\N	\N	PDF v1.1, p. 286	{"parsed_from_statblock": true}
5456ec0d-123c-40b7-b67d-87e021dc2727	53e7cc77-166b-4062-9521-4ebe729f086c	BASTÃO	PADRÃO	\N	2O+5	1d8+7 impacto	1	1	\N	\N	\N	\N	PDF v1.1, p. 287	{"parsed_from_statblock": true}
bdd59c74-0319-4836-bcb0-3887d2a7aab9	e6407482-d3e0-838d-0683-fa7173f8015c	BASTÃO	PADRÃO	\N	3O+10	1d8+13 impacto	1	2	\N	\N	\N	\N	PDF v1.1, p. 287	{"parsed_from_statblock": true}
a5fed10f-3610-4bf6-b908-94ad09140af4	e6407482-d3e0-838d-0683-fa7173f8015c	FUZIL DE ASSALTO	PADRÃO	\N	3O+10	2d8+13 balístico	2	1	Médio	17/x3	\N	\N	PDF v1.1, p. 287	{"parsed_from_statblock": true}
e3a5475f-a230-4900-a834-b8ad788ca85c	ddd48960-8422-2949-b599-893b178948ff	FACA	PADRÃO	\N	O+5	1d4+1 corte	1	1	\N	19	\N	\N	PDF v1.1, p. 286	{"parsed_from_statblock": true}
d04d072a-70ea-4f62-b313-a971c5fe8937	e6407482-d3e0-838d-0683-fa7173f8015c	LANÇA-GRANADAS	PADRÃO	Uma vez por cena, o policial de elite dispara uma granada explosiva em alcance médio. Cada ser a 6m do ponto de impacto sofre 8d6 pontos de dano de impacto (Reflexos DT 19 reduz à metade).	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 287	{"parsed_from_statblock": true}
54b72603-31f7-4569-83ef-8c09be1cd844	e6407482-d3e0-838d-0683-fa7173f8015c	EMPURRAR E ATIRAR	COMPLETA	O policial de elite empurra um personagem adjacente para 3m longe de si (Fortitude DT 19 evita) e em seguida atira com seu fuzil de assalto a curta distância. Se tiver conseguido empurrar o personagem	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 287	{"parsed_from_statblock": true}
2d78dcb2-8f85-418c-ac10-97ebee06d7df	a04aeb3a-4937-0509-3603-feaa1790ef36	BASTÃO	PADRÃO	\N	3O+15	1d8+8 impacto	1	2	\N	\N	\N	\N	PDF v1.1, p. 287	{"parsed_from_statblock": true}
9100f483-c0bc-4355-bd07-0832d4b0cb5c	189034de-8f01-36a7-87c6-1126d93d3450	FORTALECIMENTO PARANORMAL	MOVIMENTO	Até o fim da cena recebe +1 dado em testes baseados em Agilidade, Força e Vigor e suas pancadas causam +2d4 de dano de Conhecimento. Só pode usar após causar dano mental a um personagem com Brilho Enlouquecedor na cena.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 240	{"parsed_from_statblock": true}
682bff8f-6ac6-492a-88fd-af34c8dddfbc	72b4164d-66cb-3f52-c4c8-8fcb403bba7d	ACELERAÇÃO	LIVRE	Sempre que um personagem sofre dano da Pancada Energética, entra em estado de aceleração. No próximo turno, se realizar uma ação de movimento e uma ação padrão, ou uma ação completa, sofre 4d12 de dano de Energia.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 259	{"parsed_from_statblock": true}
30aaacc8-f049-40cc-90ca-6330cb04a8ed	22118520-6be3-b02f-f935-50333c06403e	COMPORTAMENTO ERRÁTICO	LIVRE	No começo do turno executa três comportamentos aleatórios. Role 1d6 três vezes e resolva os resultados na ordem. Se não puder executar um resultado, perde aquela ação e aumenta suas resistências a dano em 10 até o próximo turno para cada ação perdida.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, pp. 262-263	{"rolls": 3, "random_table": "1d6"}
2f8681a9-3d5b-4f66-a7b8-721e86d34789	53e7cc77-166b-4062-9521-4ebe729f086c	PISTOLA	PADRÃO	\N	2O+5	1d12+5 balístico	2	1	Curto	18	\N	\N	PDF v1.1, p. 287	{"parsed_from_statblock": true}
12645f7a-bbc6-4c77-a443-39b541dbdc69	e2708871-e31f-4e67-dbba-e5962e66a3a5	FACA	PADRÃO	\N	O	1d4+1 corte	1	1	\N	19	\N	\N	PDF v1.1, p. 286	{"fixed_by": "008_fix_threat_data_v1", "parsed_from_statblock": false}
52064f3f-01b3-457b-8666-054a90628251	ddd48960-8422-2949-b599-893b178948ff	REVÓLVER	PADRÃO	\N	O	2d6 balístico	2	1	Curto	19/x3	\N	\N	PDF v1.1, p. 286	{"fixed_by": "008_fix_threat_data_v1", "parsed_from_statblock": false}
5e3e3ffe-fe1e-4c5f-a670-8e412924898c	3587d753-20e6-0197-2b96-f948f5ca6bc9	DERRUBAR E DEVORAR	COMPLETA	Usa a manobra Derrubar em um personagem a até 3m (teste 5O+45). Se vencer, desfere três ataques de Mordida contra o alvo; esses ataques causam 4d12+40 de dano.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 194	{"parsed_from_statblock": true}
1bd9d53b-f873-4128-9486-5be483bdc342	0f60fed6-a659-b802-3fb1-8f53d4278aaa	CRAVAR CHIFRES	LIVRE	Se acertar uma Investida com os chifres, o alvo fica agarrado. Enquanto o mantém dessa forma, não pode atacar com os chifres; no fim de cada turno da vítima, ela sofre 4d12+20 de dano de Sangue.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 197	{"parsed_from_statblock": true}
85a12ab5-aade-4739-84bc-41b745b0fb5a	48f329fb-339b-2f3c-ab5e-69c01707ec0e	ESPIRAL DE LODO	COMPLETA	Transforma-se em uma poça de Lodo e percorre até 9m em linha reta. Seres no caminho sofrem 2d10 de dano de Morte (Reflexos DT 14 reduz à metade); então se reforma no fim do trajeto.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 217	{"parsed_from_statblock": true}
7a134cc2-cb68-4d77-be58-08ac2c03377b	37785bcb-c312-1207-fa57-7c2553052220	RASTREAR E ABATER	LIVRE	Causa +6d6 de dano contra seres desprevenidos.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 224	{"parsed_from_statblock": true}
67a33197-cadb-41a0-ab4c-55447b48f4ef	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	ESPIRAL DESTRUTIVA	PADRÃO	Cria uma espiral de Morte com 12m de raio em alcance longo. Todos na área sofrem 10d10+50 de dano de Morte (Fortitude DT 45 reduz à metade).	\N	\N	6	\N	\N	\N	\N	\N	PDF v1.1, p. 230	{"parsed_from_statblock": true}
30adcd16-b1ed-4c67-8c13-35da4b26a7bf	a7e35038-1680-908a-be3a-60ad1debd522	CORRENTES DE LODO	MOVIMENTO	Projeta vinhas de Lodo por toda a área em alcance médio. Seres na área sofrem 20d6 de dano de Morte (Fortitude DT 40 reduz à metade). Quem ficar machucado pelo dano recebe vulnerabilidade a Morte até o fim da cena; quem for reduzido a 0 PV ou menos se torna um Enraizado.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 226	{"parsed_from_statblock": true}
9adcfeb4-53b7-435f-9244-dec6f2cbd175	99c9e528-e4ec-2c7b-da9c-1fb4cece6b74	SUCÇÃO	LIVRE	Se acertar com Mordida, prende os dentes no rosto da vítima. Fortitude DT 17 permite se soltar; em falha fica inconsciente e, no início do próximo turno do Succ, é reduzida a 0 PV e fica morrendo. Enquanto prende alguém, o Succ só pode realizar reações e seu deslocamento fica 3m. Se sofrer 10 ou mais de dano na rodada, solta a vítima.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 227	{"parsed_from_statblock": true}
af772733-f0ad-4f98-977b-6d5e1d85e8b1	63b121c2-516a-f562-feac-b6886de8f29f	DESESPERO	LIVRE	Sempre que um ser sofre dano do Toque da Dor, sofre a mesma quantidade de dano mental (Vontade DT 25 reduz o dano mental à metade).	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 248	{"parsed_from_statblock": true}
5ec86875-14e2-41bd-a4a3-b41ee0acaa91	af9ebb2d-0f65-c58e-27bd-dbdb8f62445c	REESCREVER REALIDADE	PADRÃO	Altera propriedades de seres e objetos em alcance médio. Contra objetos de até 1 tonelada pode mudar composição, posição e estado; itens vestidos ou empunhados permitem Reflexos DT 45. Contra um ser pode causar 10d6 de Conhecimento, 10d6 de dano mental e uma condição, exceto morrendo e enlouquecendo; Vontade DT 45 reduz os danos e evita a condição.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 254	{"parsed_from_statblock": true}
69588f61-7d17-4815-95b9-c946f4e29abb	eeb94d35-292d-e7b1-8686-0a2ea8a0ee90	PLANTAR PARANOIA	COMPLETA	Cada personagem em alcance médio fica abalado (Vontade DT 15 evita). Quem já estiver abalado fica apavorado. Se o Vulto estiver escondido, o teste de Vontade sofre -1 dado.	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 251	{"parsed_from_statblock": true}
424ed005-f18b-47a7-b970-7fafa24bb9a5	7f48783f-86b6-c93c-962d-fbf5c9ccdb5b	IMPLANTAR CONFUSÃO	LIVRE	Uma vez por rodada tenta agarrar um personagem que acabou de sofrer dano de Toque Plasmático (teste 4O+10). Se conseguir, o alvo sofre 2d8 de dano mental (Vontade DT 15 reduz à metade) e fica vulnerável a Energia até o fim da cena.	\N	\N	1	\N	\N	\N	\N	\N	PDF v1.1, p. 268	{"parsed_from_statblock": true}
d3db2d20-4666-45fc-a5c2-a0f1c3f2e895	20f91d11-1834-d40f-02c1-8e8a0c81ee63	GRITO DE DESESPERO	COMPLETA	Cada ser em alcance médio sofre 3d12 de dano mental (Vontade DT 20 reduz à metade; cobertura fornece +5 no teste).	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 269	{"parsed_from_statblock": true}
8d7cbd23-08f0-4905-8e24-44382ff679c2	cab21581-a023-2e27-8178-fa3898890bd4	PRENDER NA TELA	COMPLETA	Desintegra um ser em alcance curto e o materializa em sua tela (Fortitude DT 30 evita). Enquanto preso, fica paralisado e sofre 2d12 de dano mental no início de seus turnos. Quando o Telopsia sofre 50 ou mais de dano em um turno, o alvo pode repetir Fortitude para escapar.	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 271	{"parsed_from_statblock": true}
e7d55bd6-bf53-49a1-b3f4-b13aa0835f77	c9a49ecf-895c-9dac-0185-2e23764358cd	DEVORAR MEMÓRIA	COMPLETA	Contra um ser que esteja agarrando, causa 4d12 de dano mental e apaga completamente a memória de uma pessoa (Vontade DT 29 reduz o dano à metade e evita o efeito). Para cada vítima deixada perturbada assim, a Pancada recebe +1d12 de dano até o fim da cena.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 274	{"parsed_from_statblock": true}
0ba25357-04c0-4c0f-bafc-ff4e92a2c3be	e7ff9a66-e094-d347-aeb8-11e733c4a6df	TRANSPORTAR PELO SANGUE	MOVIMENTO	O Diabo pode se movimentar através do Sangue, inclusive daquele que esteja saindo de dentro de um personagem. Com uma ação de movimento, pode se deslocar para qualquer espaço que tenha grande quantidade de sangue exposta ou que esteja adjacente a um personagem machucado ou morrendo.	\N	\N	6	\N	\N	\N	\N	\N	PDF v1.1, pp. 205-207	{"fixed_by": "008_fix_threat_data_v2", "parsed_from_statblock": true}
044ea7ab-9706-4963-8ae6-5bae6757d16c	a04aeb3a-4937-0509-3603-feaa1790ef36	ESPINGARDA	PADRÃO	\N	2O+17	4d6+12 balístico	2	2	Curto	x3	\N	\N	PDF v1.1, p. 287	{"parsed_from_statblock": true}
c50fcf3d-51fa-4853-846c-9d3072a3ef40	a04aeb3a-4937-0509-3603-feaa1790ef36	TEIMOSO	REAÇÃO	Uma vez por cena, o chefe de polícia pode ignorar um efeito que exija teste de resistência ou reduzir um dano recém sofrido a metade.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 287	{"parsed_from_statblock": true}
182057b8-3268-43ee-8cd1-832e9d2b877e	d1122566-9223-4957-1667-52b39dfa85b7	MORDIDA	PADRÃO	\N	2O+5	1d6+2 corte	1	1	\N	\N	\N	\N	PDF v1.1, p. 288	{"parsed_from_statblock": true}
3d0bfe03-c30f-4766-9f06-5279831a9613	d1122566-9223-4957-1667-52b39dfa85b7	DERRUBAR	LIVRE	Se o cão	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 288	{"parsed_from_statblock": true}
b74a83ae-e4c3-4968-803a-e03cbce8836c	a2655898-407a-8e76-c06b-1f88c15aba65	MORDIDA	PADRÃO	\N	2O+5	1d8+4 corte	1	1	\N	\N	\N	\N	PDF v1.1, p. 289	{"parsed_from_statblock": true}
009e1dd9-db58-4464-aa58-a5fe0e5606a1	a2655898-407a-8e76-c06b-1f88c15aba65	MORDIDA FINAL	REAÇÃO	Quando é reduzido a 0 PV, o javaporco	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 289	{"parsed_from_statblock": true}
03570bc5-4a59-4d23-b24a-7f79225d3f25	e13d6f64-cbd7-8f33-a624-429f6f1ea8f8	MORDIDA	PADRÃO	\N	3O+10	1d8+5	1	1	\N	\N	\N	\N	PDF v1.1, p. 289	{"parsed_from_statblock": true}
6794185a-9306-4d12-872f-b2c2062173cd	e13d6f64-cbd7-8f33-a624-429f6f1ea8f8	GARRAS	PADRÃO	\N	3O+10	1d6+5 corte	2	2	\N	19	\N	\N	PDF v1.1, p. 289	{"parsed_from_statblock": true}
132177ab-77df-423e-b75c-057217613507	e13d6f64-cbd7-8f33-a624-429f6f1ea8f8	AGARRÃO	LIVRE	Se a onça acertar um ataque de mordida em um ser Mé- dio ou menor, ela pode tentar agarrar o alvo (teste 3O+7).	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 289	{"parsed_from_statblock": true}
8743dd18-7c74-4a99-b51b-84de75d88541	e13d6f64-cbd7-8f33-a624-429f6f1ea8f8	BOTE	COMPLETA	A onça faz uma investida e ataca com sua mordida e suas garras. O	\N	\N	4	\N	\N	\N	\N	\N	PDF v1.1, p. 289	{"parsed_from_statblock": true}
03ea6b04-9e6e-4155-8e46-8c41e67ebcaa	68da4a77-b1ae-6eef-aa7d-2d68a617bc8a	MORDIDA	PADRÃO	\N	3O+10	1d6+8 corte	1	1	\N	\N	\N	\N	PDF v1.1, p. 289	{"parsed_from_statblock": true}
5d1acb32-8f95-467f-8c6d-9e86904bdd93	68da4a77-b1ae-6eef-aa7d-2d68a617bc8a	AGARRÃO	LIVRE	Se a sucuri acertar um ataque de mordida em um ser Médio ou menor, ela pode tentar agarrar o alvo (teste 4O+12).	\N	\N	2	\N	\N	\N	\N	\N	PDF v1.1, p. 289	{"parsed_from_statblock": true}
1490918a-3dd5-4c10-bbc3-76dafacabf48	68da4a77-b1ae-6eef-aa7d-2d68a617bc8a	CONSTRIÇÃO	LIVRE	No início de cada um dos seus turnos, a sucuri causa 2d6+8 pontos de dano de impacto em qualquer ser que esteja agarrando.	\N	\N	3	\N	\N	\N	\N	\N	PDF v1.1, p. 289	{"parsed_from_statblock": true}
\.


--
-- Data for Name: threat_defense_trait; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.threat_defense_trait (id, threat_id, trait_type, name, value_text, sort_order, source_ref) FROM stdin;
8ad7d426-2a64-407b-82bb-3bb617c1ea0a	e2be0bb4-7c11-800b-ce51-7c9de1342c43	RESISTANCE	Balístico, impacto, perfuração 5, Sangue 10	\N	1	PDF v1.1, p. 182
4342e286-b67d-4cf9-8484-aa3b994f36e4	e2be0bb4-7c11-800b-ce51-7c9de1342c43	VULNERABILITY	Morte	\N	2	PDF v1.1, p. 182
1a44f87c-886c-4bbf-8958-cd0f0eecb888	2fd41391-37dd-20d2-871e-cb71f4ebb278	RESISTANCE	Dano 50	\N	1	PDF v1.1, p. 186
f8e2af11-a389-4d08-b4d5-4b06075cd0a1	2fd41391-37dd-20d2-871e-cb71f4ebb278	VULNERABILITY	Morte	\N	2	PDF v1.1, p. 186
b06e33ce-b082-4b57-ae3f-4d3525cbf29c	0234288f-2f0c-872d-cbae-239b25da9cc7	RESISTANCE	Balístico, impacto e perfuração 10, Sangue 20	\N	1	PDF v1.1, p. 190
5f3c6724-605c-4f32-8373-b05f7bc73787	0234288f-2f0c-872d-cbae-239b25da9cc7	VULNERABILITY	Morte	\N	2	PDF v1.1, p. 190
5aad9f3a-318a-4eb0-9aac-fc179d24665b	64b81aec-4e03-2fca-94e7-851dbd04b7a0	RESISTANCE	Balístico, impacto e perfuração 10, Sangue 20	\N	1	PDF v1.1, p. 193
d0e6698e-66b3-4333-8588-f19fa7d94b88	64b81aec-4e03-2fca-94e7-851dbd04b7a0	VULNERABILITY	Morte	\N	2	PDF v1.1, p. 193
594bfc8e-546e-4606-82ce-4532d17470f8	3587d753-20e6-0197-2b96-f948f5ca6bc9	RESISTANCE	Balístico, impacto, perfuração e Sangue 20	\N	1	PDF v1.1, p. 194
ede662bc-5786-4f53-a3ec-5074050ba516	3587d753-20e6-0197-2b96-f948f5ca6bc9	VULNERABILITY	Morte	\N	2	PDF v1.1, p. 194
31373587-08e4-4210-bfb6-ce044b24c5d0	0f60fed6-a659-b802-3fb1-8f53d4278aaa	RESISTANCE	Balístico, impacto, perfuração e Sangue 20	\N	1	PDF v1.1, p. 197
3294be15-7331-42bb-8a95-2a11229b0f88	0f60fed6-a659-b802-3fb1-8f53d4278aaa	VULNERABILITY	Morte	\N	2	PDF v1.1, p. 197
9fbeddae-1a6e-4293-af90-29731d129b84	553a94fb-382c-69c5-eac0-dfb12b2665bb	RESISTANCE	Balístico, Energia, impacto e perfuração 10, Sangue 20	\N	1	PDF v1.1, p. 199
1282d808-a4b3-487b-8a56-abeff03e4380	553a94fb-382c-69c5-eac0-dfb12b2665bb	VULNERABILITY	Morte	\N	2	PDF v1.1, p. 199
e56c590b-5599-477d-91eb-008b022ad963	dc030186-e4b0-6b26-a3eb-cdb5e2980571	RESISTANCE	Balístico, impacto, perfuração e Sangue 20	\N	1	PDF v1.1, p. 188
8c4ee81d-3b6b-48c8-af8f-f5eaeecd2d48	dc030186-e4b0-6b26-a3eb-cdb5e2980571	VULNERABILITY	Morte	\N	2	PDF v1.1, p. 188
31b04608-8f7c-44f2-a2f6-ba1e2b0a40c4	e7ff9a66-e094-d347-aeb8-11e733c4a6df	RESISTANCE	Balístico, impacto e perfuração 20	\N	1	PDF v1.1, p. 205-207
b31e6c08-24f5-4602-8f02-e3990da79580	e7ff9a66-e094-d347-aeb8-11e733c4a6df	IMMUNITY	Condições de atordoamento e paralisia, dano, dano e efeitos de Sangue	\N	2	PDF v1.1, p. 205-207
cb03be8e-6aea-49f4-8c0f-b4d445ea2f96	e7ff9a66-e094-d347-aeb8-11e733c4a6df	VULNERABILITY	Morte	\N	3	PDF v1.1, p. 205-207
eb319784-ab24-4532-b127-3116da791f3d	e247cdc1-d609-fa24-f339-7adb397a6ec7	RESISTANCE	Balístico, impacto, perfuração e Sangue 20	\N	1	PDF v1.1, p. 201
28cbdf54-e664-4d62-be21-2382881a9789	e247cdc1-d609-fa24-f339-7adb397a6ec7	VULNERABILITY	Morte	\N	2	PDF v1.1, p. 201
872b7138-1c1f-4196-a839-62a530e9fa18	cf30b492-cace-69d4-8b39-8f091caf2499	RESISTANCE	Balístico, impacto e perfuração 5, Sangue 10	\N	1	PDF v1.1, p. 202
1d560ab5-eb0d-4520-93aa-fa74b6601368	cf30b492-cace-69d4-8b39-8f091caf2499	VULNERABILITY	Morte	\N	2	PDF v1.1, p. 202
7ea5faac-9999-4624-bdba-65482d2c4666	d4da78e2-01d5-3a2c-cb04-bc56d7df0a5c	RESISTANCE	Balístico, impacto e perfuração 5, Sangue 10	\N	1	PDF v1.1, p. 203
8a774979-6d56-410c-9697-6d659dfef834	d4da78e2-01d5-3a2c-cb04-bc56d7df0a5c	VULNERABILITY	Morte	\N	2	PDF v1.1, p. 203
2f0d4cba-5567-434a-85dc-481fd1b50ff3	67052271-cab5-1982-3cfc-2fff9fcf2c74	RESISTANCE	Corte, impacto, perfuração e Morte 20	\N	1	PDF v1.1, p. 219
360ec47a-2591-4473-98a4-c570c9bd3fd9	67052271-cab5-1982-3cfc-2fff9fcf2c74	VULNERABILITY	Energia	\N	2	PDF v1.1, p. 219
59ee3085-8897-430c-8239-ccad139c6075	e4866d22-2413-8a10-dc2f-30681c33a483	IMMUNITY	Dano	\N	1	PDF v1.1, p. 209
faa9d833-d236-418e-b0e0-2115f29632ae	e4866d22-2413-8a10-dc2f-30681c33a483	VULNERABILITY	Energia	\N	2	PDF v1.1, p. 209
d4727aec-4cca-4911-b337-91e487da5ccf	981e0906-addf-ca9b-c5e8-82659e6c64cf	RESISTANCE	Corte, impacto e perfuração 10, Morte 20	\N	1	PDF v1.1, p. 211
0656f509-0f3f-419a-8ccd-39014beeae3d	981e0906-addf-ca9b-c5e8-82659e6c64cf	IMMUNITY	Dano balístico	\N	2	PDF v1.1, p. 211
b6066cb3-8798-4c05-84bb-6425dba591f1	981e0906-addf-ca9b-c5e8-82659e6c64cf	VULNERABILITY	Energia	\N	3	PDF v1.1, p. 211
d99adf00-2e8c-401f-b97b-5a34148f1758	3e733982-0435-ca3a-40e2-20e2ac8d5195	RESISTANCE	Dano 50	\N	1	PDF v1.1, p. 213
5a12a4ca-80b7-42a5-832a-035562d10a07	3e733982-0435-ca3a-40e2-20e2ac8d5195	IMMUNITY	Condições de paralisia e lento, efeitos e dano de Morte	\N	2	PDF v1.1, p. 213
f3d98166-9fd2-4bfb-b876-2df04eae1b08	3e733982-0435-ca3a-40e2-20e2ac8d5195	VULNERABILITY	Energia	\N	3	PDF v1.1, p. 213
92e2a7fe-9731-4876-9319-cf6936ed2a1d	40b5007f-2005-de03-e7f4-64783809fd47	RESISTANCE	Corte, impacto e perfuração 10, Morte 20	\N	1	PDF v1.1, p. 214
9d556f45-f6bd-4507-9c7c-3b305a1ec455	40b5007f-2005-de03-e7f4-64783809fd47	VULNERABILITY	Energia	\N	2	PDF v1.1, p. 214
3afc6afa-2bd2-465a-b550-7d23ffabf50b	0bcc85f7-b3dd-c1dd-d8b9-95c8f01a8dda	IMMUNITY	Dano	\N	1	PDF v1.1, p. 216
66e9b3ff-cc2f-4882-9a90-1c7dd9b44956	48f329fb-339b-2f3c-ab5e-69c01707ec0e	RESISTANCE	Corte, impacto e perfuração 5, Morte 10	\N	1	PDF v1.1, p. 217
fd3aa844-b4de-49f2-8cbf-5237b5bbca66	48f329fb-339b-2f3c-ab5e-69c01707ec0e	VULNERABILITY	Energia	\N	2	PDF v1.1, p. 217
4262ed5c-0c2e-4506-bcfd-213c632e34cb	5e226c8d-e09f-ddc9-7963-811bd3cfa346	RESISTANCE	Corte, impacto e perfuração 10, Morte 20	\N	1	PDF v1.1, p. 221
2c0a9310-c21d-4cab-a84b-6c8ea00cb98a	5e226c8d-e09f-ddc9-7963-811bd3cfa346	VULNERABILITY	Energia, fogo	\N	2	PDF v1.1, p. 221
f0cfa7c4-3c03-46fd-a23a-fd303fc9d3bb	37785bcb-c312-1207-fa57-7c2553052220	RESISTANCE	Corte, impacto, perfuração e Morte 20	\N	1	PDF v1.1, p. 224
5b4958fd-4ddc-43dd-96dd-b6e081a9423b	37785bcb-c312-1207-fa57-7c2553052220	VULNERABILITY	Energia	\N	2	PDF v1.1, p. 224
96dec438-0f84-40fb-adb7-d3cf7d0f0b93	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	RESISTANCE	Corte, impacto e perfuração 20	\N	1	PDF v1.1, p. 230
8697cdbe-34fd-4610-b90a-5a4829172f9a	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	IMMUNITY	Condições de atordoamento e paralisia, dano e efeitos de Morte	\N	2	PDF v1.1, p. 230
064b0806-1eb4-49a3-a38e-6f07b68df5ff	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	VULNERABILITY	Energia	\N	3	PDF v1.1, p. 230
9a50b4f4-e482-4795-b2f0-b4d4de5a5f62	a7e35038-1680-908a-be3a-60ad1debd522	RESISTANCE	Corte, impacto e perfuração 20	\N	1	PDF v1.1, p. 226
b768d6d2-8771-4f05-b340-d4801170a77a	a7e35038-1680-908a-be3a-60ad1debd522	IMMUNITY	Condições lento e de paralisia, e dano e efeitos de Morte	\N	2	PDF v1.1, p. 226
189aeec8-1b8a-4ecb-9cfc-7787e4538321	a7e35038-1680-908a-be3a-60ad1debd522	VULNERABILITY	Energia	\N	3	PDF v1.1, p. 226
957f8873-152b-403b-92d1-65d0cffad463	99c9e528-e4ec-2c7b-da9c-1fb4cece6b74	RESISTANCE	Corte, impacto e perfuração 5, Morte 10	\N	1	PDF v1.1, p. 227
4375f6e9-e61e-4a43-8f08-84fc1a4675e4	99c9e528-e4ec-2c7b-da9c-1fb4cece6b74	VULNERABILITY	Energia	\N	2	PDF v1.1, p. 227
70d89d0a-71f2-4b68-ae3f-16eeca4b4c9f	7c0fbcb9-f9cb-a886-2517-8bd5f4bcc597	RESISTANCE	Dano 50	\N	1	PDF v1.1, p. 234
18eebc26-e489-4641-b527-043baa18f014	7c0fbcb9-f9cb-a886-2517-8bd5f4bcc597	IMMUNITY	Condições de paralisia, dano e efeitos de Conhecimento	\N	2	PDF v1.1, p. 234
602fc5c8-4a36-41db-8a6b-dfa1dba93e24	7c0fbcb9-f9cb-a886-2517-8bd5f4bcc597	VULNERABILITY	Sangue	\N	3	PDF v1.1, p. 234
89c606cc-4e28-4f5f-8411-4b9ddfeffb65	25556b0f-1ee2-f31a-5f84-21662ea3eeca	RESISTANCE	Balístico, corte, impacto e Conhecimento 20	\N	1	PDF v1.1, p. 237
8ee3aead-89ea-4471-8a1d-40003ac190b0	25556b0f-1ee2-f31a-5f84-21662ea3eeca	VULNERABILITY	Sangue	\N	2	PDF v1.1, p. 237
78067c08-0aed-4cbb-a18c-b52222264f47	35167a4a-1da4-3662-c53c-1cc057cd8a9d	IMMUNITY	Dano	\N	1	PDF v1.1, p. 243
451c0d0a-ecf9-4748-b57e-fd3548205f5c	35167a4a-1da4-3662-c53c-1cc057cd8a9d	VULNERABILITY	Sangue	\N	2	PDF v1.1, p. 243
fb6729cd-75f1-4a3f-896e-05a96e4dce31	189034de-8f01-36a7-87c6-1126d93d3450	RESISTANCE	Balístico, corte e impacto 5, Conhecimento 10	\N	1	PDF v1.1, p. 240
020de4b2-1a69-4512-8bc0-21d6cddcb207	189034de-8f01-36a7-87c6-1126d93d3450	VULNERABILITY	Sangue	\N	2	PDF v1.1, p. 240
d460d5ec-77de-47c9-b893-3f9866a8239f	368972da-2308-bf04-7103-bca0de4932fd	RESISTANCE	Balístico, corte e impacto 10, Conhecimento 20	\N	1	PDF v1.1, p. 241
45a86936-a394-4d97-8963-e9d96152984a	368972da-2308-bf04-7103-bca0de4932fd	VULNERABILITY	Sangue	\N	2	PDF v1.1, p. 241
7f1db605-b3a6-483a-8203-5a1ac6e7cc41	af9ebb2d-0f65-c58e-27bd-dbdb8f62445c	IMMUNITY	Condições, dano	\N	1	PDF v1.1, p. 254
e9250d88-dbf6-4eea-a1ce-271ed9522741	af9ebb2d-0f65-c58e-27bd-dbdb8f62445c	VULNERABILITY	Sangue	\N	2	PDF v1.1, p. 254
50bcaab5-423f-43d1-a271-e613b4df41c5	edbeef88-be85-94ce-b3af-00e5692c338e	IMMUNITY	Dano	\N	1	PDF v1.1, p. 238
a708aaab-a47c-450b-9581-f12a696354f4	edbeef88-be85-94ce-b3af-00e5692c338e	VULNERABILITY	Sangue	\N	2	PDF v1.1, p. 238
15396062-eb14-4e1a-9218-3f3957896077	15b07f11-8cdc-d86d-eebd-b745d86cb108	RESISTANCE	Balístico, corte, impacto e Conhecimento 20	\N	1	PDF v1.1, p. 244
0575f6c4-f98e-4ebe-b551-a25916b6e612	15b07f11-8cdc-d86d-eebd-b745d86cb108	VULNERABILITY	Sangue	\N	2	PDF v1.1, p. 244
326ea298-518f-44bc-a275-e2545c91312f	4c29680f-753d-b300-6316-69ab128fbd3f	IMMUNITY	Dano (exceto causado pelo hospedeiro)	\N	1	PDF v1.1, p. 246
e701f258-b2c9-452e-b3ff-13e07ff05ebf	63b121c2-516a-f562-feac-b6886de8f29f	RESISTANCE	Balístico, corte e impacto 10, Conhecimento 20	\N	1	PDF v1.1, p. 248
144681d7-66a7-45c1-b3f9-b3a4aab3df5c	63b121c2-516a-f562-feac-b6886de8f29f	VULNERABILITY	Sangue	\N	2	PDF v1.1, p. 248
d1418c5e-2223-4961-86b6-c2dbc1816b31	04f6c70d-ccd0-6736-5a7e-8b4380e81ecc	RESISTANCE	Dano 30	\N	1	PDF v1.1, p. 250
19e45e8c-031c-4f83-b34e-59ca6fd89db8	04f6c70d-ccd0-6736-5a7e-8b4380e81ecc	IMMUNITY	Condições de paralisia, efeitos e dano de Conhecimento, manobras de combate	\N	2	PDF v1.1, p. 250
a271e57d-a7c2-49a0-963e-790c8fecccc6	04f6c70d-ccd0-6736-5a7e-8b4380e81ecc	VULNERABILITY	Sangue	\N	3	PDF v1.1, p. 250
e4f747a6-1fff-458a-ba7e-81e98ec35704	eeb94d35-292d-e7b1-8686-0a2ea8a0ee90	RESISTANCE	Balístico, corte e perfuração 5, Conhecimento 10	\N	1	PDF v1.1, p. 251
6a779250-a921-4231-a06a-3dba8ed2bb08	eeb94d35-292d-e7b1-8686-0a2ea8a0ee90	VULNERABILITY	Sangue	\N	2	PDF v1.1, p. 251
1f7643a9-e78b-4937-8a17-4b1fb660461e	2faad71f-e963-0d04-806c-e49455fac533	RESISTANCE	Energia 5	\N	1	PDF v1.1, p. 257
f6b63b1b-0281-48d7-9a6a-91dcbbd5fcba	2faad71f-e963-0d04-806c-e49455fac533	VULNERABILITY	Conhecimento	\N	2	PDF v1.1, p. 257
f5b38040-203a-4588-8011-a50e896adf67	72b4164d-66cb-3f52-c4c8-8fcb403bba7d	RESISTANCE	Balístico, corte e perfuração 10, Energia 20	\N	1	PDF v1.1, p. 259
7a764511-5b4a-4ac2-95d0-c8f89962abef	72b4164d-66cb-3f52-c4c8-8fcb403bba7d	VULNERABILITY	Conhecimento	\N	2	PDF v1.1, p. 259
d9f8c120-afc2-4699-a96a-8028b9064d5d	d6ecb2e4-bd05-093f-d43f-26dca3d354bb	IMMUNITY	Dano e todas as condições	\N	1	PDF v1.1, p. 261
0a60f140-5af0-4d68-8c6d-1d6bca10dff1	d6ecb2e4-bd05-093f-d43f-26dca3d354bb	VULNERABILITY	Conhecimento	\N	2	PDF v1.1, p. 261
9cd057e3-7f7d-4e89-ad70-8a9bd50c2dad	22118520-6be3-b02f-f935-50333c06403e	RESISTANCE	Balístico, corte e perfuração 10, Energia 20	\N	1	PDF v1.1, p. 263
eb1e38a7-e8ac-4b6f-979e-4395e7cbf67d	22118520-6be3-b02f-f935-50333c06403e	VULNERABILITY	Conhecimento	\N	2	PDF v1.1, p. 263
91bc9d9e-2888-4920-b827-75db0b288286	b55d1509-2803-fc09-cd9a-66772751e758	RESISTANCE	Balístico, corte e perfuração 10, Energia 20	\N	1	PDF v1.1, p. 265
13b4519b-e864-4d76-b0a6-e143bd4fa5fd	b55d1509-2803-fc09-cd9a-66772751e758	IMMUNITY	Condições de paralisia	\N	2	PDF v1.1, p. 265
55b4d291-4a04-4b33-8671-e4f3b49f87a0	b55d1509-2803-fc09-cd9a-66772751e758	VULNERABILITY	Conhecimento	\N	3	PDF v1.1, p. 265
c0784809-a47f-4d8b-8ef7-cfb8bc6e17a8	4686e4e2-c047-5691-fbc4-11eb224493eb	RESISTANCE	Balístico, corte, perfuração e Energia 20	\N	1	PDF v1.1, p. 267
54390791-fe08-46d0-b84b-d06f4615739f	4686e4e2-c047-5691-fbc4-11eb224493eb	VULNERABILITY	Conhecimento	\N	2	PDF v1.1, p. 267
09607e68-6097-4dde-9ee3-698259307fbf	600edb81-50a4-7ce3-bd94-7597458ec444	IMMUNITY	Condições de paralisia, dano, dano e efeitos de Energia	\N	1	PDF v1.1, p. 278-279
929cf5b9-0b1d-4723-9098-1300a95e8feb	600edb81-50a4-7ce3-bd94-7597458ec444	VULNERABILITY	Conhecimento	\N	2	PDF v1.1, p. 278-279
d3383354-06f7-4f4e-9fdc-74d1d5abb620	7f48783f-86b6-c93c-962d-fbf5c9ccdb5b	RESISTANCE	Balístico, corte e perfuração 5, Energia 10	\N	1	PDF v1.1, p. 268
b2fd360b-0e81-47c0-a086-b313934bd40e	7f48783f-86b6-c93c-962d-fbf5c9ccdb5b	VULNERABILITY	Conhecimento	\N	2	PDF v1.1, p. 268
c135292a-da3b-4da1-ba29-5932a57a0871	20f91d11-1834-d40f-02c1-8e8a0c81ee63	RESISTANCE	Impacto e Energia 10	\N	1	PDF v1.1, p. 269
c2ff1fde-0e35-4dcb-b7f6-f56481f542f9	20f91d11-1834-d40f-02c1-8e8a0c81ee63	IMMUNITY	Dano balístico, de corte e de perfuração	\N	2	PDF v1.1, p. 269
9baf5a16-bda7-4d49-aaf2-a6d5d5a6c03b	20f91d11-1834-d40f-02c1-8e8a0c81ee63	VULNERABILITY	Conhecimento	\N	3	PDF v1.1, p. 269
23646a9e-fbdf-4b52-b98d-a959af33f1e0	9d273d68-1267-1193-d4e4-d7aade51df78	RESISTANCE	Balístico, corte, perfuração e Energia 20	\N	1	PDF v1.1, p. 273
d7eb0434-da06-4632-9e98-d392bfb5494d	9d273d68-1267-1193-d4e4-d7aade51df78	IMMUNITY	Condições de paralisia	\N	2	PDF v1.1, p. 273
d6c628d1-8054-4c2d-b74a-eda0f9450ebc	9d273d68-1267-1193-d4e4-d7aade51df78	VULNERABILITY	Conhecimento	\N	3	PDF v1.1, p. 273
f9e28fd2-4de6-4f9a-8daa-33e9e77086b5	cab21581-a023-2e27-8178-fa3898890bd4	RESISTANCE	Balístico, corte, perfuração e Energia 20	\N	1	PDF v1.1, p. 271
8357bd4d-6fee-4ce8-bb54-f80ce1de8d09	cab21581-a023-2e27-8178-fa3898890bd4	IMMUNITY	Condições de paralisia	\N	2	PDF v1.1, p. 271
ef9f003d-e88d-4383-bf92-5a71979efcd9	cab21581-a023-2e27-8178-fa3898890bd4	VULNERABILITY	Conhecimento	\N	3	PDF v1.1, p. 271
7a9db322-d2c0-4d7d-8110-478a89b516e3	c9a49ecf-895c-9dac-0185-2e23764358cd	RESISTANCE	Balístico, corte e perfuração 10, Energia 20	\N	1	PDF v1.1, p. 274
ecbc2dd1-3f0a-40d8-9872-bfa60a886c05	c9a49ecf-895c-9dac-0185-2e23764358cd	VULNERABILITY	Conhecimento	\N	2	PDF v1.1, p. 274
8341e4b5-8fab-4ed9-9109-a1bff6ce161f	f87384c2-4e60-56db-a5de-3d654357a796	IMMUNITY	Dano	\N	1	PDF v1.1, p. 282
89144672-ac05-4f12-9bc5-972c00879113	9e5601b2-bd2e-485a-ee50-8082f3a83a92	RESISTANCE	Balístico, corte, impacto e perfuração 5	\N	1	PDF v1.1, p. 285
da5455af-3cab-4672-aaa7-2221e16294f3	e6407482-d3e0-838d-0683-fa7173f8015c	RESISTANCE	Balístico, corte, impacto e perfuração 5	\N	1	PDF v1.1, p. 287
\.


--
-- Data for Name: threat_descriptor; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.threat_descriptor (id, threat_id, descriptor, sort_order, source_ref) FROM stdin;
3a2f5770-df6e-4122-a1d5-9ab7f7598bc2	e2be0bb4-7c11-800b-ce51-7c9de1342c43	Criatura	1	PDF v1.1, p. 182
045a8976-8dd6-449e-93a5-1495a2638baa	e2be0bb4-7c11-800b-ce51-7c9de1342c43	Sangue	2	PDF v1.1, p. 182
68cc29da-3f78-4a14-994d-63b64c3195a7	2fd41391-37dd-20d2-871e-cb71f4ebb278	Criatura	1	PDF v1.1, p. 186
25b86986-aa84-4737-94e4-8f3f98fa9f76	2fd41391-37dd-20d2-871e-cb71f4ebb278	Sangue	2	PDF v1.1, p. 186
2f9ba17d-3d51-46f4-868f-7f8ed09d1592	0234288f-2f0c-872d-cbae-239b25da9cc7	Criatura	1	PDF v1.1, p. 190
c227708a-90d4-4325-a946-d79c95f521be	0234288f-2f0c-872d-cbae-239b25da9cc7	Sangue	2	PDF v1.1, p. 190
3240b882-e02e-4d1d-9a0b-4526fd6b47e2	0234288f-2f0c-872d-cbae-239b25da9cc7	Morte	3	PDF v1.1, p. 190
8ca34736-2615-4454-a505-149a9166de62	64b81aec-4e03-2fca-94e7-851dbd04b7a0	Criatura	1	PDF v1.1, p. 193
7bc30872-be3d-47b8-99a1-f6f3a2c2c99c	64b81aec-4e03-2fca-94e7-851dbd04b7a0	Sangue	2	PDF v1.1, p. 193
12ed4fa2-0a07-42c2-8be7-372153e51864	64b81aec-4e03-2fca-94e7-851dbd04b7a0	Conhecimento	3	PDF v1.1, p. 193
eb7c3014-3d30-4dfa-b23f-54539f52616c	3587d753-20e6-0197-2b96-f948f5ca6bc9	Criatura	1	PDF v1.1, p. 194
a7275383-2c4d-40f5-b1b9-c8b43959ef27	3587d753-20e6-0197-2b96-f948f5ca6bc9	Sangue	2	PDF v1.1, p. 194
9d3c661b-4cd1-484c-ba20-1b5fb3c8af31	0f60fed6-a659-b802-3fb1-8f53d4278aaa	Criatura	1	PDF v1.1, p. 197
06de3376-4db3-4733-aa60-2ff4b45685bc	0f60fed6-a659-b802-3fb1-8f53d4278aaa	Sangue	2	PDF v1.1, p. 197
499d4ced-979f-4cd4-a5aa-39cbe21f8a2e	553a94fb-382c-69c5-eac0-dfb12b2665bb	Criatura	1	PDF v1.1, p. 199
790959d1-5130-4811-b55a-0950704fe989	553a94fb-382c-69c5-eac0-dfb12b2665bb	Sangue	2	PDF v1.1, p. 199
e17595c3-6120-486e-b21b-ce9e29ee2e64	553a94fb-382c-69c5-eac0-dfb12b2665bb	Energia	3	PDF v1.1, p. 199
97de69a9-8537-4dae-9943-2e701fdbfb3d	dc030186-e4b0-6b26-a3eb-cdb5e2980571	Criatura	1	PDF v1.1, p. 188
3538ad5e-9a44-4901-8e22-14ecd6923048	dc030186-e4b0-6b26-a3eb-cdb5e2980571	Sangue	2	PDF v1.1, p. 188
2192bffd-878e-4195-9937-8b00ef729d70	dc030186-e4b0-6b26-a3eb-cdb5e2980571	Morte	3	PDF v1.1, p. 188
4ec4c39f-2339-4edd-9c07-34b68c9885b4	e7ff9a66-e094-d347-aeb8-11e733c4a6df	Criatura	1	PDF v1.1, p. 205-207
228de0a5-a877-437e-8813-b5d083629c81	e7ff9a66-e094-d347-aeb8-11e733c4a6df	Sangue	2	PDF v1.1, p. 205-207
baaf9805-18d9-4001-94f0-6090299e5c60	e7ff9a66-e094-d347-aeb8-11e733c4a6df	Conhecimento	3	PDF v1.1, p. 205-207
5e10364c-7cc6-43a2-ad30-86ca4f647ff7	e247cdc1-d609-fa24-f339-7adb397a6ec7	Criatura	1	PDF v1.1, p. 201
c81c73cf-a463-4139-ad7d-bd0571f9dc52	e247cdc1-d609-fa24-f339-7adb397a6ec7	Sangue	2	PDF v1.1, p. 201
9b6a9901-ddaa-46f5-b516-9e4d19cbdc46	cf30b492-cace-69d4-8b39-8f091caf2499	Criatura	1	PDF v1.1, p. 202
e7d6d66c-034f-4933-897d-121d7c98c66e	cf30b492-cace-69d4-8b39-8f091caf2499	Sangue	2	PDF v1.1, p. 202
36f6adab-3903-445e-8fc4-3a2f1ed6ee04	d4da78e2-01d5-3a2c-cb04-bc56d7df0a5c	Criatura	1	PDF v1.1, p. 203
b9442d25-d057-4b9d-93c2-5e1726f518fa	d4da78e2-01d5-3a2c-cb04-bc56d7df0a5c	Sangue	2	PDF v1.1, p. 203
93c33fca-aa78-412a-8580-66ad3a592c76	67052271-cab5-1982-3cfc-2fff9fcf2c74	Criatura	1	PDF v1.1, p. 219
4f45e28f-df2a-4b54-9149-2f3048278d8f	67052271-cab5-1982-3cfc-2fff9fcf2c74	Morte	2	PDF v1.1, p. 219
69704308-9f47-4527-a624-6a28f80fc5ca	e4866d22-2413-8a10-dc2f-30681c33a483	Criatura	1	PDF v1.1, p. 209
2fe8ba5c-0368-4860-a08d-ad1e31b73cb1	e4866d22-2413-8a10-dc2f-30681c33a483	Morte	2	PDF v1.1, p. 209
942b95c0-1e53-422e-ae34-ff43e376e6a5	981e0906-addf-ca9b-c5e8-82659e6c64cf	Criatura	1	PDF v1.1, p. 211
ed2299c8-ba92-49e9-bb26-776ccff899dc	981e0906-addf-ca9b-c5e8-82659e6c64cf	Morte	2	PDF v1.1, p. 211
869b9dd4-17c9-43f8-b0ab-98b4e8096c54	981e0906-addf-ca9b-c5e8-82659e6c64cf	Conhecimento	3	PDF v1.1, p. 211
8f73a948-e5de-4c62-a141-43f45a6cc0a1	3e733982-0435-ca3a-40e2-20e2ac8d5195	Criatura	1	PDF v1.1, p. 213
2f173b06-a28c-4220-b87f-e0f67f78b507	3e733982-0435-ca3a-40e2-20e2ac8d5195	Morte	2	PDF v1.1, p. 213
4b5bd1ff-0887-4db1-91e4-1eb974f22620	40b5007f-2005-de03-e7f4-64783809fd47	Criatura	1	PDF v1.1, p. 214
3e0e8c69-22bb-415a-9731-d2619330d2a1	40b5007f-2005-de03-e7f4-64783809fd47	Morte	2	PDF v1.1, p. 214
7e255ee8-b7da-4ca8-9e24-f9446760981d	0bcc85f7-b3dd-c1dd-d8b9-95c8f01a8dda	Criatura	1	PDF v1.1, p. 216
91629e47-e3fb-4253-aba5-49092bd2ea9a	0bcc85f7-b3dd-c1dd-d8b9-95c8f01a8dda	Morte	2	PDF v1.1, p. 216
ddf3d940-5539-4537-91eb-56be501663f0	0bcc85f7-b3dd-c1dd-d8b9-95c8f01a8dda	Energia	3	PDF v1.1, p. 216
0837d3d1-d369-4dc0-888a-6837d413c59d	48f329fb-339b-2f3c-ab5e-69c01707ec0e	Criatura	1	PDF v1.1, p. 217
e51c51bc-be7f-4fae-bd98-5e9e0101d875	48f329fb-339b-2f3c-ab5e-69c01707ec0e	Morte	2	PDF v1.1, p. 217
67f4ca81-b1ad-4f81-92c8-99e58e61fbd0	5e226c8d-e09f-ddc9-7963-811bd3cfa346	Criatura	1	PDF v1.1, p. 221
5a2f73f3-6fb4-4b36-9c19-7a39f001e7b7	5e226c8d-e09f-ddc9-7963-811bd3cfa346	Morte	2	PDF v1.1, p. 221
78096203-42f1-4aa4-a7e6-24138c6c9c7e	37785bcb-c312-1207-fa57-7c2553052220	Criatura	1	PDF v1.1, p. 224
162341cf-6171-44e0-9eb6-9411301a74b4	37785bcb-c312-1207-fa57-7c2553052220	Morte	2	PDF v1.1, p. 224
2530e766-46a2-41a2-9535-051d1c12a8b3	37785bcb-c312-1207-fa57-7c2553052220	Sangue	3	PDF v1.1, p. 224
28ee774d-ab73-471e-8a7c-fed69d8bfdd6	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	Relíquia	1	PDF v1.1, p. 230
0f975022-9c2d-4533-8303-ca13253df5e0	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	Morte	2	PDF v1.1, p. 230
9255befb-190b-472f-ad16-94893bc75233	0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	Conhecimento	3	PDF v1.1, p. 230
d7d839a4-655b-405c-b082-71b4218e90b9	a7e35038-1680-908a-be3a-60ad1debd522	Criatura	1	PDF v1.1, p. 226
e295b559-8cd3-40af-9b3e-41a41c97a477	a7e35038-1680-908a-be3a-60ad1debd522	Morte	2	PDF v1.1, p. 226
00408d1d-4aba-472e-81a4-5c8783d1c954	99c9e528-e4ec-2c7b-da9c-1fb4cece6b74	Criatura	1	PDF v1.1, p. 227
e4344f4e-8e68-44a9-9081-80ff0cb1b5d2	99c9e528-e4ec-2c7b-da9c-1fb4cece6b74	Morte	2	PDF v1.1, p. 227
44e0bc30-8bc0-4ea7-8af8-7a24d812aeb5	99c9e528-e4ec-2c7b-da9c-1fb4cece6b74	Energia	3	PDF v1.1, p. 227
7db4ae11-e1ad-415c-a708-8452d958e7c6	7c0fbcb9-f9cb-a886-2517-8bd5f4bcc597	Criatura	1	PDF v1.1, p. 234
bdad1058-c98a-497d-a57b-9c1fdf2a8e0c	7c0fbcb9-f9cb-a886-2517-8bd5f4bcc597	Conhecimento	2	PDF v1.1, p. 234
ae0de84b-6aa5-4780-845a-1530d6859e7a	25556b0f-1ee2-f31a-5f84-21662ea3eeca	Criatura	1	PDF v1.1, p. 237
6a341250-3044-48e9-8d86-1bf257338136	25556b0f-1ee2-f31a-5f84-21662ea3eeca	Conhecimento	2	PDF v1.1, p. 237
01f3c1e8-261a-4f0c-8b09-826b59e2ffc1	35167a4a-1da4-3662-c53c-1cc057cd8a9d	Criatura	1	PDF v1.1, p. 243
afd5bf30-bd95-43a8-a7f7-def237ce966b	35167a4a-1da4-3662-c53c-1cc057cd8a9d	Conhecimento	2	PDF v1.1, p. 243
b9a5a887-edbc-44c0-b85d-e40a447b7d42	35167a4a-1da4-3662-c53c-1cc057cd8a9d	Energia	3	PDF v1.1, p. 243
d0482ac1-2d40-4dd7-b939-fbed6e73ccf1	189034de-8f01-36a7-87c6-1126d93d3450	Criatura	1	PDF v1.1, p. 240
93f39bd9-af00-4308-a4b8-78b2051e7644	189034de-8f01-36a7-87c6-1126d93d3450	Conhecimento	2	PDF v1.1, p. 240
662b0b24-7b75-4ae6-860f-af469349f2c6	368972da-2308-bf04-7103-bca0de4932fd	Criatura	1	PDF v1.1, p. 241
6a4a3231-e910-43d6-be8a-cccaee604daf	368972da-2308-bf04-7103-bca0de4932fd	Conhecimento	2	PDF v1.1, p. 241
ed0fc2f9-ef25-4518-93f8-960593be3658	af9ebb2d-0f65-c58e-27bd-dbdb8f62445c	Relíquia	1	PDF v1.1, p. 254
96df12e9-5cfd-4082-9ff6-489d337f781a	af9ebb2d-0f65-c58e-27bd-dbdb8f62445c	Conhecimento	2	PDF v1.1, p. 254
ecfbf066-9315-4434-bdf3-4280ea3e32ce	edbeef88-be85-94ce-b3af-00e5692c338e	Criatura	1	PDF v1.1, p. 238
03bf1385-7a51-4444-a787-170bc522dc19	edbeef88-be85-94ce-b3af-00e5692c338e	Conhecimento	2	PDF v1.1, p. 238
6f623a09-1948-4576-a7ec-e3f96f9294b3	15b07f11-8cdc-d86d-eebd-b745d86cb108	Criatura	1	PDF v1.1, p. 244
261c4d24-afc4-47e3-bf27-eab139f71289	15b07f11-8cdc-d86d-eebd-b745d86cb108	Conhecimento	2	PDF v1.1, p. 244
2f814d50-1b16-46cb-8e18-30795bc0dfd2	4c29680f-753d-b300-6316-69ab128fbd3f	Criatura	1	PDF v1.1, p. 246
fe43cc87-426e-4857-bb7b-e6f6b2353310	4c29680f-753d-b300-6316-69ab128fbd3f	Conhecimento	2	PDF v1.1, p. 246
214f8c36-f5a7-4c33-b1e4-fbd3d0e45984	4c29680f-753d-b300-6316-69ab128fbd3f	Sangue	3	PDF v1.1, p. 246
6982c0f5-7bfb-4e65-9281-9b200bdfdbfd	4c29680f-753d-b300-6316-69ab128fbd3f	Morte	4	PDF v1.1, p. 246
d930943b-8b20-47c7-ba57-63a0ba90fa1d	63b121c2-516a-f562-feac-b6886de8f29f	Criatura	1	PDF v1.1, p. 248
3b409eea-173d-43d9-8599-6f70c0f81fa7	63b121c2-516a-f562-feac-b6886de8f29f	Conhecimento	2	PDF v1.1, p. 248
fcb02b32-44e2-46ee-b9ef-f05202913338	63b121c2-516a-f562-feac-b6886de8f29f	Sangue	3	PDF v1.1, p. 248
e4db21ca-5505-4002-b597-78c0b5edbf0d	04f6c70d-ccd0-6736-5a7e-8b4380e81ecc	Criatura	1	PDF v1.1, p. 250
a4ef84e0-c115-4805-8685-96a68b6cc389	04f6c70d-ccd0-6736-5a7e-8b4380e81ecc	Conhecimento	2	PDF v1.1, p. 250
21513123-3d5d-40dd-8525-62d4ed62ac8c	eeb94d35-292d-e7b1-8686-0a2ea8a0ee90	Criatura	1	PDF v1.1, p. 251
245fc313-8a16-4e63-9ec9-a1746e1882c0	eeb94d35-292d-e7b1-8686-0a2ea8a0ee90	Conhecimento	2	PDF v1.1, p. 251
1c0839cf-4e6f-4608-b0bd-811ea06156ab	2faad71f-e963-0d04-806c-e49455fac533	Criatura	1	PDF v1.1, p. 257
438abf7a-22da-4c7f-864b-0f07698aad5b	2faad71f-e963-0d04-806c-e49455fac533	Energia	2	PDF v1.1, p. 257
496a1fb6-d531-40eb-93fb-73a0248daef1	72b4164d-66cb-3f52-c4c8-8fcb403bba7d	Criatura	1	PDF v1.1, p. 259
09cd7139-62f1-42d0-8446-b8bbe6687489	72b4164d-66cb-3f52-c4c8-8fcb403bba7d	Energia	2	PDF v1.1, p. 259
5732101c-2506-4c93-a915-fad419be2852	d6ecb2e4-bd05-093f-d43f-26dca3d354bb	Criatura	1	PDF v1.1, p. 261
8e9b7c0c-8d4f-46fd-8d45-2bb9ee42875e	d6ecb2e4-bd05-093f-d43f-26dca3d354bb	Energia	2	PDF v1.1, p. 261
1e10958d-82eb-49f3-9876-96f2f689246c	22118520-6be3-b02f-f935-50333c06403e	Criatura	1	PDF v1.1, p. 263
6fc15e02-5ca2-4624-9176-53572f46e35e	22118520-6be3-b02f-f935-50333c06403e	Energia	2	PDF v1.1, p. 263
eaec06b3-83ee-4d58-8c2a-336f678d688c	b55d1509-2803-fc09-cd9a-66772751e758	Criatura	1	PDF v1.1, p. 265
1d0049ea-79ae-4c61-9ede-252dd8d461fa	b55d1509-2803-fc09-cd9a-66772751e758	Energia	2	PDF v1.1, p. 265
00f89f2d-cd4c-4f92-8673-a719f9f6333f	b55d1509-2803-fc09-cd9a-66772751e758	Sangue	3	PDF v1.1, p. 265
42c40f42-3f46-4b22-9b0b-91064f722e06	4686e4e2-c047-5691-fbc4-11eb224493eb	Criatura	1	PDF v1.1, p. 267
45e3c62c-e77b-4f2a-a335-1a1ee10adfe5	4686e4e2-c047-5691-fbc4-11eb224493eb	Energia	2	PDF v1.1, p. 267
ddcebbf9-31fb-4d60-896c-7dd35eddbfb4	4686e4e2-c047-5691-fbc4-11eb224493eb	Sangue	3	PDF v1.1, p. 267
de2e4829-d0cf-48b6-95b2-aa0977a73977	600edb81-50a4-7ce3-bd94-7597458ec444	Criatura	1	PDF v1.1, p. 278-279
88b10804-631b-4bf8-b1d9-eed0f1b9150d	600edb81-50a4-7ce3-bd94-7597458ec444	Energia	2	PDF v1.1, p. 278-279
7eae4674-3de4-40a3-b4bb-b4c8aef51510	600edb81-50a4-7ce3-bd94-7597458ec444	Conhecimento	3	PDF v1.1, p. 278-279
72ad0149-ad84-490c-8e40-51d004abb6f1	7f48783f-86b6-c93c-962d-fbf5c9ccdb5b	Criatura	1	PDF v1.1, p. 268
6e675ca5-8c55-45a2-a182-b2bd6ade48ce	7f48783f-86b6-c93c-962d-fbf5c9ccdb5b	Energia	2	PDF v1.1, p. 268
8dce7824-ba86-4879-a40b-77b9bbcb9c42	20f91d11-1834-d40f-02c1-8e8a0c81ee63	Criatura	1	PDF v1.1, p. 269
169db140-6229-4e44-9ef2-3e0159403de7	20f91d11-1834-d40f-02c1-8e8a0c81ee63	Energia	2	PDF v1.1, p. 269
485f864f-ef3f-4429-bd1f-894082f55fb7	20f91d11-1834-d40f-02c1-8e8a0c81ee63	Conhecimento	3	PDF v1.1, p. 269
84565779-80b5-454b-b22c-72d8723715ce	9d273d68-1267-1193-d4e4-d7aade51df78	Criatura	1	PDF v1.1, p. 273
b6a3c98c-01e1-4fd7-b075-8f9a94a5d605	9d273d68-1267-1193-d4e4-d7aade51df78	Energia	2	PDF v1.1, p. 273
9cd38d61-34f8-487c-b2d9-a0467e859af9	cab21581-a023-2e27-8178-fa3898890bd4	Criatura	1	PDF v1.1, p. 271
9e1cedce-9b53-4e3e-abf4-aa659d2c333e	cab21581-a023-2e27-8178-fa3898890bd4	Energia	2	PDF v1.1, p. 271
9b0c6060-d5c0-4ea5-acec-19920baa8f06	cab21581-a023-2e27-8178-fa3898890bd4	Morte	3	PDF v1.1, p. 271
abb37303-c91e-478f-a737-1dc4b95660a3	c9a49ecf-895c-9dac-0185-2e23764358cd	Criatura	1	PDF v1.1, p. 274
3573c659-4311-4376-9937-46d9fbb384a5	c9a49ecf-895c-9dac-0185-2e23764358cd	Energia	2	PDF v1.1, p. 274
0bcb0da5-de3f-45f6-aae5-711fcdb4e78a	c9a49ecf-895c-9dac-0185-2e23764358cd	Conhecimento	3	PDF v1.1, p. 274
06337cba-259d-4963-925f-00be512d265d	f87384c2-4e60-56db-a5de-3d654357a796	Criatura	1	PDF v1.1, p. 282
4ab2ad96-6bbc-4c2d-9b2d-ae8106c64912	f87384c2-4e60-56db-a5de-3d654357a796	Energia	2	PDF v1.1, p. 282
09df8a22-f9e1-42e0-b3e8-c04792fca6c4	f87384c2-4e60-56db-a5de-3d654357a796	Conhecimento	3	PDF v1.1, p. 282
41012183-1daf-4434-bcb6-36f644c9ebcb	f87384c2-4e60-56db-a5de-3d654357a796	Sangue	4	PDF v1.1, p. 282
b7645e55-af29-46bf-ad26-22216bd317f5	f87384c2-4e60-56db-a5de-3d654357a796	Morte	5	PDF v1.1, p. 282
d24d6013-dac5-4a88-9262-67a368b56e61	f87384c2-4e60-56db-a5de-3d654357a796	Criatura do Medo	6	PDF v1.1, p. 282
bca2931b-056a-44f2-ab20-c44e4174b44b	cad9d205-0e8c-9d91-0142-7243852739f9	Pessoa	1	PDF v1.1, p. 284
34909dc5-dcf8-4d70-b13d-9d49fd630e92	bf633d83-4d78-4b53-2e47-316dfd0e1768	Pessoa	1	PDF v1.1, p. 284
ae104670-fc33-41cf-8a49-b4f4e34a54bb	6854df88-14b7-ca24-c1f7-31288fffdd87	Pessoa	1	PDF v1.1, p. 284
c0e3f666-f049-43b7-9dac-5ac29c489d2c	2f48e0be-c76c-6a21-2b44-5774b1103744	Pessoa	1	PDF v1.1, p. 285
00b349d4-d5a2-4a58-957c-3a3bb95364f2	9e5601b2-bd2e-485a-ee50-8082f3a83a92	Pessoa	1	PDF v1.1, p. 285
6e65251b-7a1b-49a4-ac1e-1fbb8a529920	e2708871-e31f-4e67-dbba-e5962e66a3a5	Pessoa	1	PDF v1.1, p. 286
31d18445-bcb0-4bac-9434-78abf284e9e8	ddd48960-8422-2949-b599-893b178948ff	Pessoa	1	PDF v1.1, p. 286
63c8181c-4dd0-4af6-bf46-bd1fd9849228	5c2807af-f19e-54f2-27a2-22abbb0018eb	Pessoa	1	PDF v1.1, p. 286
d64377de-5f01-4b07-bbbf-beee9037a700	53e7cc77-166b-4062-9521-4ebe729f086c	Pessoa	1	PDF v1.1, p. 287
e6c8e383-97d0-43d2-8b6d-6cc28e7e7d87	e6407482-d3e0-838d-0683-fa7173f8015c	Pessoa	1	PDF v1.1, p. 287
d274f7ea-4fb4-4d03-b576-9abe1a1a7926	a04aeb3a-4937-0509-3603-feaa1790ef36	Pessoa	1	PDF v1.1, p. 287
ad8d4d09-2986-4598-811c-919d283c1f4c	d1122566-9223-4957-1667-52b39dfa85b7	Animal	1	PDF v1.1, p. 288
9011e645-b29c-4b9e-9a8e-4ac098335226	42c8eb5b-7fda-8518-d251-45abb6239074	Animal	1	PDF v1.1, p. 288
362982b8-b203-41f1-99f7-b3de9033fbec	42c8eb5b-7fda-8518-d251-45abb6239074	Enxame	2	PDF v1.1, p. 288
fb738d28-69b8-4931-a164-bc2b19912b9f	f5de5b9f-880b-44d7-f64a-63819147f4aa	Animal	1	PDF v1.1, p. 288
816b480d-8d4a-49e1-ab5e-46277a6480c1	f5de5b9f-880b-44d7-f64a-63819147f4aa	Enxame	2	PDF v1.1, p. 288
96058dd1-a2d6-44bd-b699-1b5bc3d2b540	c1fe7c0a-1581-4610-0326-6176fca42f03	Animal	1	PDF v1.1, p. 288
d2abcac7-efdd-4f92-88cb-958f518659e1	a2655898-407a-8e76-c06b-1f88c15aba65	Animal	1	PDF v1.1, p. 289
a622c28d-40ce-4973-b730-980b02d117ac	e13d6f64-cbd7-8f33-a624-429f6f1ea8f8	Animal	1	PDF v1.1, p. 289
ad3c8783-514d-4860-b447-4c5373f5a9e4	68da4a77-b1ae-6eef-aa7d-2d68a617bc8a	Animal	1	PDF v1.1, p. 289
\.


--
-- Data for Name: threat_element; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.threat_element (threat_id, element_id, is_primary, sort_order, source_ref) FROM stdin;
e2be0bb4-7c11-800b-ce51-7c9de1342c43	9290710c-ae4d-486c-8d69-2afb4db4c030	t	1	PDF v1.1, p. 182
2fd41391-37dd-20d2-871e-cb71f4ebb278	9290710c-ae4d-486c-8d69-2afb4db4c030	t	1	PDF v1.1, p. 186
0234288f-2f0c-872d-cbae-239b25da9cc7	9290710c-ae4d-486c-8d69-2afb4db4c030	t	1	PDF v1.1, p. 190
0234288f-2f0c-872d-cbae-239b25da9cc7	bca15d0f-87ca-4375-aaef-b639c7295552	f	2	PDF v1.1, p. 190
64b81aec-4e03-2fca-94e7-851dbd04b7a0	9290710c-ae4d-486c-8d69-2afb4db4c030	t	1	PDF v1.1, p. 193
64b81aec-4e03-2fca-94e7-851dbd04b7a0	d855bb6c-9321-48db-8e24-05e58697a31d	f	2	PDF v1.1, p. 193
3587d753-20e6-0197-2b96-f948f5ca6bc9	9290710c-ae4d-486c-8d69-2afb4db4c030	t	1	PDF v1.1, p. 194
0f60fed6-a659-b802-3fb1-8f53d4278aaa	9290710c-ae4d-486c-8d69-2afb4db4c030	t	1	PDF v1.1, p. 197
553a94fb-382c-69c5-eac0-dfb12b2665bb	9290710c-ae4d-486c-8d69-2afb4db4c030	t	1	PDF v1.1, p. 199
553a94fb-382c-69c5-eac0-dfb12b2665bb	52779391-a501-4a9e-b780-684349da1c1c	f	2	PDF v1.1, p. 199
dc030186-e4b0-6b26-a3eb-cdb5e2980571	9290710c-ae4d-486c-8d69-2afb4db4c030	t	1	PDF v1.1, p. 188
dc030186-e4b0-6b26-a3eb-cdb5e2980571	bca15d0f-87ca-4375-aaef-b639c7295552	f	2	PDF v1.1, p. 188
e7ff9a66-e094-d347-aeb8-11e733c4a6df	9290710c-ae4d-486c-8d69-2afb4db4c030	t	1	PDF v1.1, p. 205-207
e7ff9a66-e094-d347-aeb8-11e733c4a6df	d855bb6c-9321-48db-8e24-05e58697a31d	f	2	PDF v1.1, p. 205-207
e247cdc1-d609-fa24-f339-7adb397a6ec7	9290710c-ae4d-486c-8d69-2afb4db4c030	t	1	PDF v1.1, p. 201
cf30b492-cace-69d4-8b39-8f091caf2499	9290710c-ae4d-486c-8d69-2afb4db4c030	t	1	PDF v1.1, p. 202
d4da78e2-01d5-3a2c-cb04-bc56d7df0a5c	9290710c-ae4d-486c-8d69-2afb4db4c030	t	1	PDF v1.1, p. 203
67052271-cab5-1982-3cfc-2fff9fcf2c74	bca15d0f-87ca-4375-aaef-b639c7295552	t	1	PDF v1.1, p. 219
e4866d22-2413-8a10-dc2f-30681c33a483	bca15d0f-87ca-4375-aaef-b639c7295552	t	1	PDF v1.1, p. 209
981e0906-addf-ca9b-c5e8-82659e6c64cf	bca15d0f-87ca-4375-aaef-b639c7295552	t	1	PDF v1.1, p. 211
981e0906-addf-ca9b-c5e8-82659e6c64cf	d855bb6c-9321-48db-8e24-05e58697a31d	f	2	PDF v1.1, p. 211
3e733982-0435-ca3a-40e2-20e2ac8d5195	bca15d0f-87ca-4375-aaef-b639c7295552	t	1	PDF v1.1, p. 213
40b5007f-2005-de03-e7f4-64783809fd47	bca15d0f-87ca-4375-aaef-b639c7295552	t	1	PDF v1.1, p. 214
0bcc85f7-b3dd-c1dd-d8b9-95c8f01a8dda	bca15d0f-87ca-4375-aaef-b639c7295552	t	1	PDF v1.1, p. 216
0bcc85f7-b3dd-c1dd-d8b9-95c8f01a8dda	52779391-a501-4a9e-b780-684349da1c1c	f	2	PDF v1.1, p. 216
48f329fb-339b-2f3c-ab5e-69c01707ec0e	bca15d0f-87ca-4375-aaef-b639c7295552	t	1	PDF v1.1, p. 217
5e226c8d-e09f-ddc9-7963-811bd3cfa346	bca15d0f-87ca-4375-aaef-b639c7295552	t	1	PDF v1.1, p. 221
37785bcb-c312-1207-fa57-7c2553052220	bca15d0f-87ca-4375-aaef-b639c7295552	t	1	PDF v1.1, p. 224
37785bcb-c312-1207-fa57-7c2553052220	9290710c-ae4d-486c-8d69-2afb4db4c030	f	2	PDF v1.1, p. 224
0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	bca15d0f-87ca-4375-aaef-b639c7295552	t	1	PDF v1.1, p. 230
0d4fee24-d3eb-2adf-5e9f-42c9b8e93818	d855bb6c-9321-48db-8e24-05e58697a31d	f	2	PDF v1.1, p. 230
a7e35038-1680-908a-be3a-60ad1debd522	bca15d0f-87ca-4375-aaef-b639c7295552	t	1	PDF v1.1, p. 226
99c9e528-e4ec-2c7b-da9c-1fb4cece6b74	bca15d0f-87ca-4375-aaef-b639c7295552	t	1	PDF v1.1, p. 227
99c9e528-e4ec-2c7b-da9c-1fb4cece6b74	52779391-a501-4a9e-b780-684349da1c1c	f	2	PDF v1.1, p. 227
7c0fbcb9-f9cb-a886-2517-8bd5f4bcc597	d855bb6c-9321-48db-8e24-05e58697a31d	t	1	PDF v1.1, p. 234
25556b0f-1ee2-f31a-5f84-21662ea3eeca	d855bb6c-9321-48db-8e24-05e58697a31d	t	1	PDF v1.1, p. 237
35167a4a-1da4-3662-c53c-1cc057cd8a9d	d855bb6c-9321-48db-8e24-05e58697a31d	t	1	PDF v1.1, p. 243
35167a4a-1da4-3662-c53c-1cc057cd8a9d	52779391-a501-4a9e-b780-684349da1c1c	f	2	PDF v1.1, p. 243
189034de-8f01-36a7-87c6-1126d93d3450	d855bb6c-9321-48db-8e24-05e58697a31d	t	1	PDF v1.1, p. 240
368972da-2308-bf04-7103-bca0de4932fd	d855bb6c-9321-48db-8e24-05e58697a31d	t	1	PDF v1.1, p. 241
af9ebb2d-0f65-c58e-27bd-dbdb8f62445c	d855bb6c-9321-48db-8e24-05e58697a31d	t	1	PDF v1.1, p. 254
edbeef88-be85-94ce-b3af-00e5692c338e	d855bb6c-9321-48db-8e24-05e58697a31d	t	1	PDF v1.1, p. 238
15b07f11-8cdc-d86d-eebd-b745d86cb108	d855bb6c-9321-48db-8e24-05e58697a31d	t	1	PDF v1.1, p. 244
4c29680f-753d-b300-6316-69ab128fbd3f	d855bb6c-9321-48db-8e24-05e58697a31d	t	1	PDF v1.1, p. 246
4c29680f-753d-b300-6316-69ab128fbd3f	9290710c-ae4d-486c-8d69-2afb4db4c030	f	2	PDF v1.1, p. 246
4c29680f-753d-b300-6316-69ab128fbd3f	bca15d0f-87ca-4375-aaef-b639c7295552	f	3	PDF v1.1, p. 246
63b121c2-516a-f562-feac-b6886de8f29f	d855bb6c-9321-48db-8e24-05e58697a31d	t	1	PDF v1.1, p. 248
63b121c2-516a-f562-feac-b6886de8f29f	9290710c-ae4d-486c-8d69-2afb4db4c030	f	2	PDF v1.1, p. 248
04f6c70d-ccd0-6736-5a7e-8b4380e81ecc	d855bb6c-9321-48db-8e24-05e58697a31d	t	1	PDF v1.1, p. 250
eeb94d35-292d-e7b1-8686-0a2ea8a0ee90	d855bb6c-9321-48db-8e24-05e58697a31d	t	1	PDF v1.1, p. 251
2faad71f-e963-0d04-806c-e49455fac533	52779391-a501-4a9e-b780-684349da1c1c	t	1	PDF v1.1, p. 257
72b4164d-66cb-3f52-c4c8-8fcb403bba7d	52779391-a501-4a9e-b780-684349da1c1c	t	1	PDF v1.1, p. 259
d6ecb2e4-bd05-093f-d43f-26dca3d354bb	52779391-a501-4a9e-b780-684349da1c1c	t	1	PDF v1.1, p. 261
22118520-6be3-b02f-f935-50333c06403e	52779391-a501-4a9e-b780-684349da1c1c	t	1	PDF v1.1, p. 263
b55d1509-2803-fc09-cd9a-66772751e758	52779391-a501-4a9e-b780-684349da1c1c	t	1	PDF v1.1, p. 265
b55d1509-2803-fc09-cd9a-66772751e758	9290710c-ae4d-486c-8d69-2afb4db4c030	f	2	PDF v1.1, p. 265
4686e4e2-c047-5691-fbc4-11eb224493eb	52779391-a501-4a9e-b780-684349da1c1c	t	1	PDF v1.1, p. 267
4686e4e2-c047-5691-fbc4-11eb224493eb	9290710c-ae4d-486c-8d69-2afb4db4c030	f	2	PDF v1.1, p. 267
600edb81-50a4-7ce3-bd94-7597458ec444	52779391-a501-4a9e-b780-684349da1c1c	t	1	PDF v1.1, p. 278-279
600edb81-50a4-7ce3-bd94-7597458ec444	d855bb6c-9321-48db-8e24-05e58697a31d	f	2	PDF v1.1, p. 278-279
7f48783f-86b6-c93c-962d-fbf5c9ccdb5b	52779391-a501-4a9e-b780-684349da1c1c	t	1	PDF v1.1, p. 268
20f91d11-1834-d40f-02c1-8e8a0c81ee63	52779391-a501-4a9e-b780-684349da1c1c	t	1	PDF v1.1, p. 269
20f91d11-1834-d40f-02c1-8e8a0c81ee63	d855bb6c-9321-48db-8e24-05e58697a31d	f	2	PDF v1.1, p. 269
9d273d68-1267-1193-d4e4-d7aade51df78	52779391-a501-4a9e-b780-684349da1c1c	t	1	PDF v1.1, p. 273
cab21581-a023-2e27-8178-fa3898890bd4	52779391-a501-4a9e-b780-684349da1c1c	t	1	PDF v1.1, p. 271
cab21581-a023-2e27-8178-fa3898890bd4	bca15d0f-87ca-4375-aaef-b639c7295552	f	2	PDF v1.1, p. 271
c9a49ecf-895c-9dac-0185-2e23764358cd	52779391-a501-4a9e-b780-684349da1c1c	t	1	PDF v1.1, p. 274
c9a49ecf-895c-9dac-0185-2e23764358cd	d855bb6c-9321-48db-8e24-05e58697a31d	f	2	PDF v1.1, p. 274
f87384c2-4e60-56db-a5de-3d654357a796	52779391-a501-4a9e-b780-684349da1c1c	t	1	PDF v1.1, p. 282
f87384c2-4e60-56db-a5de-3d654357a796	d855bb6c-9321-48db-8e24-05e58697a31d	f	2	PDF v1.1, p. 282
f87384c2-4e60-56db-a5de-3d654357a796	9290710c-ae4d-486c-8d69-2afb4db4c030	f	3	PDF v1.1, p. 282
f87384c2-4e60-56db-a5de-3d654357a796	bca15d0f-87ca-4375-aaef-b639c7295552	f	4	PDF v1.1, p. 282
\.


--
-- Data for Name: threat_skill; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.threat_skill (id, threat_id, skill_id, skill_name, test_expression, sort_order, source_ref) FROM stdin;
85e78081-ae9b-4aa3-8611-32f7e399f629	2fd41391-37dd-20d2-871e-cb71f4ebb278	6c2d9b01-f885-4d52-90e6-53d307409f12	Atletismo	O	1	PDF v1.1, p. 186
f8adfbc3-51cd-415f-a972-e47398be26f8	3587d753-20e6-0197-2b96-f948f5ca6bc9	6c2d9b01-f885-4d52-90e6-53d307409f12	Atletismo	O	1	PDF v1.1, p. 194
8fd53e5e-2480-42f1-a4c0-55fdc8dd6276	0f60fed6-a659-b802-3fb1-8f53d4278aaa	6c2d9b01-f885-4d52-90e6-53d307409f12	Atletismo	O	1	PDF v1.1, p. 197
fc9b37b7-2d1e-44e9-98ac-7ba7f233c64e	dc030186-e4b0-6b26-a3eb-cdb5e2980571	6c2d9b01-f885-4d52-90e6-53d307409f12	Atletismo	O	1	PDF v1.1, p. 188
5b6000b2-5e05-4d8f-8bd3-6234145e4e0a	dc030186-e4b0-6b26-a3eb-cdb5e2980571	83b28425-380e-4b8c-b244-c8c9cfe3e0d7	Enganação	O	2	PDF v1.1, p. 188
4d4874a4-bc2d-4728-b260-a943ffa33f37	d4da78e2-01d5-3a2c-cb04-bc56d7df0a5c	c3841196-d89d-4c41-a890-93bee7644b03	Furtividade	2O+13	1	PDF v1.1, p. 203
4c650da9-e78a-44ac-a2e1-6d9e29df5f31	e4866d22-2413-8a10-dc2f-30681c33a483	c3841196-d89d-4c41-a890-93bee7644b03	Furtividade	3O+8	1	PDF v1.1, p. 209
873dbba1-8667-4e62-bc1d-17f8467c2dcb	981e0906-addf-ca9b-c5e8-82659e6c64cf	6c2d9b01-f885-4d52-90e6-53d307409f12	Atletismo	O	1	PDF v1.1, p. 211
f4a671f5-908e-4f93-95ce-453ed56f3968	40b5007f-2005-de03-e7f4-64783809fd47	6c2d9b01-f885-4d52-90e6-53d307409f12	Atletismo	O	1	PDF v1.1, p. 214
2673f2f2-bbab-45a1-bdb9-fd65374bc184	37785bcb-c312-1207-fa57-7c2553052220	c3841196-d89d-4c41-a890-93bee7644b03	Furtividade	O	1	PDF v1.1, p. 224
b87242c7-8f70-40b2-b4e6-f83514e509b1	37785bcb-c312-1207-fa57-7c2553052220	902d9e87-64b2-4da8-b4ea-165283027f1a	Sobrevivência	5O+23	2	PDF v1.1, p. 224
036b8b02-d190-493f-aaea-dc29d15c399c	25556b0f-1ee2-f31a-5f84-21662ea3eeca	6c2d9b01-f885-4d52-90e6-53d307409f12	Atletismo	O	1	PDF v1.1, p. 237
b3d25a7c-1f86-4c77-b11e-f1add88a77c7	25556b0f-1ee2-f31a-5f84-21662ea3eeca	c3841196-d89d-4c41-a890-93bee7644b03	Furtividade	4O+15	2	PDF v1.1, p. 237
c04984d3-d275-4980-8d62-1e3e5a514d9a	35167a4a-1da4-3662-c53c-1cc057cd8a9d	1a2ed4bd-bed4-446b-b743-d18d60c130e5	Ocultismo	O	1	PDF v1.1, p. 243
50a63ac6-b074-4d97-b2f0-1053115e62c6	35167a4a-1da4-3662-c53c-1cc057cd8a9d	c3841196-d89d-4c41-a890-93bee7644b03	Furtividade	O	2	PDF v1.1, p. 243
8cb256e2-e80e-40b6-a607-21cf7a4f7805	189034de-8f01-36a7-87c6-1126d93d3450	0859d45c-5039-4d4a-8ca9-b0935107e533	Ciências	O	1	PDF v1.1, p. 240
8c4e2546-d473-421e-b02a-84529506ff93	189034de-8f01-36a7-87c6-1126d93d3450	1a2ed4bd-bed4-446b-b743-d18d60c130e5	Ocultismo	O	2	PDF v1.1, p. 240
f5513d2d-e59e-4230-8ad5-9e3b8091f951	368972da-2308-bf04-7103-bca0de4932fd	0859d45c-5039-4d4a-8ca9-b0935107e533	Ciências	4O+10	1	PDF v1.1, p. 241
0b9ec34d-a9a6-458b-b37e-bbb4c3780233	368972da-2308-bf04-7103-bca0de4932fd	1a2ed4bd-bed4-446b-b743-d18d60c130e5	Ocultismo	O	2	PDF v1.1, p. 241
8ec6bfd5-3f91-4e72-83c2-118db246803a	af9ebb2d-0f65-c58e-27bd-dbdb8f62445c	1a2ed4bd-bed4-446b-b743-d18d60c130e5	Ocultismo	O	1	PDF v1.1, p. 254
5ce5d2bc-e12e-4325-8fe5-8105c42e90ee	af9ebb2d-0f65-c58e-27bd-dbdb8f62445c	5c7ac341-4006-499e-a262-3cf85498a442	Religião	O	2	PDF v1.1, p. 254
7941ca52-6817-458d-88c5-ffd7152e5315	edbeef88-be85-94ce-b3af-00e5692c338e	c3841196-d89d-4c41-a890-93bee7644b03	Furtividade	4O+20	1	PDF v1.1, p. 238
3ea9d0e7-b1ce-4ffd-a85d-230ceb22b831	63b121c2-516a-f562-feac-b6886de8f29f	c3841196-d89d-4c41-a890-93bee7644b03	Furtividade	O	1	PDF v1.1, p. 248
606ab48b-66df-44ea-93cb-fffbb37ff452	63b121c2-516a-f562-feac-b6886de8f29f	1a2ed4bd-bed4-446b-b743-d18d60c130e5	Ocultismo	O	2	PDF v1.1, p. 248
99c4d97f-0b16-4114-82a6-3f2ca37855b3	eeb94d35-292d-e7b1-8686-0a2ea8a0ee90	c3841196-d89d-4c41-a890-93bee7644b03	Furtividade	4O+10	1	PDF v1.1, p. 251
774d2446-3615-4f05-b1de-30bfaa3e8df8	cab21581-a023-2e27-8178-fa3898890bd4	c3841196-d89d-4c41-a890-93bee7644b03	Furtividade	4O+20	1	PDF v1.1, p. 271
0d19a422-6c0c-441b-9469-56ca83024714	cad9d205-0e8c-9d91-0142-7243852739f9	487a4440-5a08-4a97-badf-cc59a6af8d78	Crime	2O+5	1	PDF v1.1, p. 284
99a80509-45a9-47cd-bb50-e435d610ec82	cad9d205-0e8c-9d91-0142-7243852739f9	c3841196-d89d-4c41-a890-93bee7644b03	Furtividade	2O+5	2	PDF v1.1, p. 284
24f3cdd3-6479-4916-9b49-3da285551972	bf633d83-4d78-4b53-2e47-316dfd0e1768	3fd8bc69-1f47-4b7c-b6c3-48e260b37148	Intimidação	O+5	1	PDF v1.1, p. 284
408505b0-0d73-4403-aa64-16f08083dc85	2f48e0be-c76c-6a21-2b44-5774b1103744	487a4440-5a08-4a97-badf-cc59a6af8d78	Crime	4O+10	1	PDF v1.1, p. 285
cba7f7c8-c3f8-4e56-a499-b4010489ca8c	2f48e0be-c76c-6a21-2b44-5774b1103744	83b28425-380e-4b8c-b244-c8c9cfe3e0d7	Enganação	3O+10	2	PDF v1.1, p. 285
e67d2ee3-6cf8-4c11-abd7-e0ac77bb063f	2f48e0be-c76c-6a21-2b44-5774b1103744	c3841196-d89d-4c41-a890-93bee7644b03	Furtividade	4O+10	3	PDF v1.1, p. 285
5b7304d9-2853-4f5a-9439-c37fa0625b22	9e5601b2-bd2e-485a-ee50-8082f3a83a92	3fd8bc69-1f47-4b7c-b6c3-48e260b37148	Intimidação	2O+10	1	PDF v1.1, p. 285
f0b4d9a5-6164-466e-8b9d-090c6e1fed0e	9e5601b2-bd2e-485a-ee50-8082f3a83a92	028f7ff4-efab-4bd3-8922-a9f431b9da2c	Tática	2O+10	2	PDF v1.1, p. 285
e1d181c3-3c9f-4aa1-8f07-93ec54e59580	e2708871-e31f-4e67-dbba-e5962e66a3a5	83b28425-380e-4b8c-b244-c8c9cfe3e0d7	Enganação	2O+5	1	PDF v1.1, p. 286
33f11057-b269-4333-878c-1f9971c9e885	e2708871-e31f-4e67-dbba-e5962e66a3a5	1a2ed4bd-bed4-446b-b743-d18d60c130e5	Ocultismo	O	2	PDF v1.1, p. 286
6675e01f-db59-4431-934b-89e9160a9a99	d1122566-9223-4957-1667-52b39dfa85b7	902d9e87-64b2-4da8-b4ea-165283027f1a	Sobrevivência	O+10	1	PDF v1.1, p. 288
6e4c33c0-bf61-4611-8b2b-15b83bc36b2d	e13d6f64-cbd7-8f33-a624-429f6f1ea8f8	c3841196-d89d-4c41-a890-93bee7644b03	Furtividade	3O+13	1	PDF v1.1, p. 289
a37926eb-4769-480b-b322-561afcb4cf8d	68da4a77-b1ae-6eef-aa7d-2d68a617bc8a	c3841196-d89d-4c41-a890-93bee7644b03	Furtividade	2O+8	1	PDF v1.1, p. 289
\.


--
-- Data for Name: weapon; Type: TABLE DATA; Schema: ordem; Owner: postgres
--

COPY ordem.weapon (item_id, proficiency_id, weapon_kind, grip, damage, critical, range_text, damage_type, agile, automatic, ammunition_item_id, source_ref) FROM stdin;
58650147-9f8e-4b18-ac8e-b0cf7c70efbf	f25cbb1a-7664-4622-9c94-d691c23113ea	FIREARM	ONE_HAND	1d6=>2d4/2d6/2d8/2d10/2d12/2d20	x3	curto	\N	f	f	\N	PDF v1.1, p. 150
2a03f265-77cf-4198-8ec1-313bc60c57b2	f25cbb1a-7664-4622-9c94-d691c23113ea	MELEE	ONE_HAND	1d4/1d6	x2	\N	impacto	f	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
f006cf61-cf4c-44ad-b6bd-3b5572943831	f25cbb1a-7664-4622-9c94-d691c23113ea	THROWN	LIGHT	1d4	19	Curto	corte	t	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
9841f810-b40e-48f0-a30f-edb09e0b9e3f	f25cbb1a-7664-4622-9c94-d691c23113ea	MELEE	LIGHT	1d6	x2	\N	impacto	f	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
f5f41815-1280-44a7-ba89-2653cb568ae1	f25cbb1a-7664-4622-9c94-d691c23113ea	MELEE	LIGHT	1d4	x3	\N	perfuracao	t	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
1b6b7bec-ea6f-49df-83d2-1d01aba0ca89	f25cbb1a-7664-4622-9c94-d691c23113ea	MELEE	ONE_HAND	1d6/1d8	x2	\N	impacto	f	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
65a4f42a-1d7f-4b1c-afff-58780de65f74	f25cbb1a-7664-4622-9c94-d691c23113ea	MELEE	ONE_HAND	1d6	19	\N	corte	f	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
7ef0a39b-c538-4e5e-8057-41a5a43a65eb	f25cbb1a-7664-4622-9c94-d691c23113ea	THROWN	ONE_HAND	1d6	x2	Curto	perfuracao	f	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
ad09228f-4b31-45ad-a2c6-cd24a96e4b43	f25cbb1a-7664-4622-9c94-d691c23113ea	MELEE	TWO_HAND	1d6/1d6	x2	\N	impacto	t	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
cffdb0d5-3f0b-4cec-af72-095d3b1065a5	f25cbb1a-7664-4622-9c94-d691c23113ea	PROJECTILE	TWO_HAND	1d6	x3	Médio	perfuracao	f	f	31b0f633-04b1-488d-ad4f-b71aa4ce66ec	PDF v1.1, Tabela 3.3 pp. 56-57
85d54c02-ed53-4c01-9e7f-d64a0ea964a4	f25cbb1a-7664-4622-9c94-d691c23113ea	PROJECTILE	TWO_HAND	1d8	19	Médio	perfuracao	f	f	31b0f633-04b1-488d-ad4f-b71aa4ce66ec	PDF v1.1, Tabela 3.3 pp. 56-57
ab571040-908c-4c06-a6f7-2ffca307360f	f25cbb1a-7664-4622-9c94-d691c23113ea	FIREARM	LIGHT	1d12	18	Curto	balistico	f	f	53b4555b-e446-4335-adc9-a445ba083659	PDF v1.1, Tabela 3.3 pp. 56-57
5c1716e3-e12f-4d76-b1b0-b6ca9412baa9	f25cbb1a-7664-4622-9c94-d691c23113ea	FIREARM	LIGHT	2d6	19/x3	Curto	balistico	f	f	53b4555b-e446-4335-adc9-a445ba083659	PDF v1.1, Tabela 3.3 pp. 56-57
7419f5db-0b38-4729-817f-6dd8eeb28102	f25cbb1a-7664-4622-9c94-d691c23113ea	FIREARM	TWO_HAND	2d8	19/x3	Médio	balistico	f	f	cc792318-e26e-4841-93e5-4b6707f802de	PDF v1.1, Tabela 3.3 pp. 56-57
5d927ec1-33aa-41c8-b50e-e8100e4add4d	9d007a18-9511-4b40-a3df-39ff14822640	THROWN	LIGHT	1d6	x3	Curto	corte	f	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
d9761921-ea0b-4cc8-a08f-c23f5803740a	9d007a18-9511-4b40-a3df-39ff14822640	MELEE	LIGHT	1d8	x2	\N	impacto	t	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
00229d7c-8ac4-4931-afdb-eae0739002cd	9d007a18-9511-4b40-a3df-39ff14822640	MELEE	ONE_HAND	1d8	x2	\N	impacto	f	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
013cf605-2a17-497d-9256-cd12983b6d1c	9d007a18-9511-4b40-a3df-39ff14822640	MELEE	ONE_HAND	1d8/1d10	19	\N	corte	f	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
84e059f1-fd54-45bb-b3eb-904b8b0856ee	9d007a18-9511-4b40-a3df-39ff14822640	MELEE	ONE_HAND	1d6	18	\N	corte	t	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
08f23594-8c5e-46c8-8302-bd5981b27548	9d007a18-9511-4b40-a3df-39ff14822640	MELEE	ONE_HAND	1d8	x3	\N	corte	f	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
54853ae4-d9bc-4f7c-a5d7-a3cc9e8b2436	9d007a18-9511-4b40-a3df-39ff14822640	MELEE	ONE_HAND	2d4	x2	\N	impacto	f	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
a236ba82-e0f8-4698-ad57-f68342bd16cf	9d007a18-9511-4b40-a3df-39ff14822640	MELEE	TWO_HAND	1d12	x3	\N	corte	f	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
420a81d7-3b32-4494-b689-31265aab1fb7	9d007a18-9511-4b40-a3df-39ff14822640	MELEE	TWO_HAND	2d4	x4	\N	corte	f	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
7e947a37-1106-4cd6-b978-db8e238f7d40	9d007a18-9511-4b40-a3df-39ff14822640	MELEE	TWO_HAND	1d10	19	\N	corte	t	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
9ff75b0d-fea4-412e-9905-3cb05b05e6f7	9d007a18-9511-4b40-a3df-39ff14822640	MELEE	TWO_HAND	3d4	x2	\N	impacto	f	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
38b796fe-e581-47db-b7e4-e2704979b5aa	9d007a18-9511-4b40-a3df-39ff14822640	MELEE	TWO_HAND	2d6	19	\N	corte	f	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
8aa191b4-b7a8-4899-84d5-744f5db6c64f	9d007a18-9511-4b40-a3df-39ff14822640	MELEE	TWO_HAND	3d6	x2	\N	corte	f	f	\N	PDF v1.1, Tabela 3.3 pp. 56-57
939eb1ab-25ce-4edb-92ed-38eb9d9c4e53	9d007a18-9511-4b40-a3df-39ff14822640	PROJECTILE	TWO_HAND	1d10	x3	Médio	perfuracao	f	f	31b0f633-04b1-488d-ad4f-b71aa4ce66ec	PDF v1.1, Tabela 3.3 pp. 56-57
d28c7613-c52d-4b47-8779-34e8239831ff	9d007a18-9511-4b40-a3df-39ff14822640	PROJECTILE	TWO_HAND	1d12	19	Médio	perfuracao	f	f	31b0f633-04b1-488d-ad4f-b71aa4ce66ec	PDF v1.1, Tabela 3.3 pp. 56-57
48772a13-c938-4e39-87d5-99913fbaa6e6	9d007a18-9511-4b40-a3df-39ff14822640	FIREARM	ONE_HAND	2d6	19/x3	Curto	balistico	f	t	53b4555b-e446-4335-adc9-a445ba083659	PDF v1.1, Tabela 3.3 pp. 56-57
ca60c4f8-85e1-416b-853f-93843bc016b5	9d007a18-9511-4b40-a3df-39ff14822640	FIREARM	TWO_HAND	4d6	x3	Curto	balistico	f	f	395bf90d-d51c-44a3-a37d-8e895dd73104	PDF v1.1, Tabela 3.3 pp. 56-57
385a729f-b5e6-48c8-b545-1b13ac41d7f3	9d007a18-9511-4b40-a3df-39ff14822640	FIREARM	TWO_HAND	2d10	19/x3	Médio	balistico	f	t	cc792318-e26e-4841-93e5-4b6707f802de	PDF v1.1, Tabela 3.3 pp. 56-57
0ddc72d6-5f59-4511-bbdf-dc14c9157718	9d007a18-9511-4b40-a3df-39ff14822640	FIREARM	TWO_HAND	2d10	19/x3	Longo	balistico	f	f	cc792318-e26e-4841-93e5-4b6707f802de	PDF v1.1, Tabela 3.3 pp. 56-57
29cc2007-98fc-4a83-850e-640887fa7de1	a20e8ed2-ef0e-47e6-8dea-6ddc3c8f1569	FIREARM	TWO_HAND	10d8	x2	Médio	impacto	f	f	79671d81-d320-4c86-aa57-f15a74f64164	PDF v1.1, Tabela 3.3 pp. 56-57
c840c186-9ef5-4273-aa2f-a1678d4deac3	a20e8ed2-ef0e-47e6-8dea-6ddc3c8f1569	FIREARM	TWO_HAND	6d6	x2	Curto	fogo	f	f	f4635410-9f0b-4784-a02f-cb7810059f9b	PDF v1.1, Tabela 3.3 pp. 56-57
8b6c90e5-bb56-464a-b37c-50d9c0bbf8e8	a20e8ed2-ef0e-47e6-8dea-6ddc3c8f1569	FIREARM	TWO_HAND	2d12	19/x3	Médio	balistico	f	t	cc792318-e26e-4841-93e5-4b6707f802de	PDF v1.1, Tabela 3.3 pp. 56-57
\.


--
-- PostgreSQL database dump complete
--

\unrestrict PxeIX84gvEAUa63TdrlrAeZvy74bMwun0l11E5wX4lJ2KCDP89S80zXiA6RF7WB

