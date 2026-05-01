/*******************************************************************************
PROJET : Analyse de la Dynamique Agricole en Guinée (2010-2024)
AUTEUR : Amadou Tidiane Barry
OBJECTIF : Nettoyage, Pivotage et Analyse de performance des données FAO
*******************************************************************************/

-- 1. NETTOYAGE ET STRUCTURATION (Pivotage des indicateurs)
-- Cette étape transforme les lignes 'Production', 'Superficie' et 'Rendement' 
-- en colonnes pour faciliter l'analyse sous Tableau.
CREATE TABLE production_clean AS
SELECT
    "Année" AS annee,
    "Produit" AS culture,
    MAX(CASE WHEN "Élément" = 'Production' THEN "Valeur" END) AS production,
    MAX(CASE WHEN "Élément" = 'Superficie récoltée' THEN "Valeur" END) AS superficie,
    MAX(CASE WHEN "Élément" = 'Rendement' THEN "Valeur" END) AS rendement
FROM production
GROUP BY "Année", "Produit";

-- 2. AUDIT DE QUALITÉ ET VÉRIFICATION
-- Identification des valeurs manquantes pour garantir la fiabilité des KPI.
SELECT *
FROM production_clean
WHERE production IS NULL
   OR superficie IS NULL
   OR rendement IS NULL;

-- 3. ANALYSE DE LA PERFORMANCE (Rendement par culture)
-- Comparaison du rendement calculé vs officiel pour valider la précision des données.
SELECT 
    culture,
    AVG(production * 1.0 / superficie) AS rendement_calcule,
    AVG(rendement) AS rendement_officiel
FROM production_clean
GROUP BY culture;

-- 4. ANALYSE STRATÉGIQUE (Insights Clés)
-- Contribution des cultures à la production totale (Top cultures)
SELECT 
    culture,
    SUM(production) AS total_production
FROM production_clean
GROUP BY culture
ORDER BY total_production DESC;

-- Évolution temporelle de la production globale (Validation du +142%)
SELECT 
    annee,
    SUM(production) AS production_totale
FROM production_clean
GROUP BY annee
ORDER BY annee;
