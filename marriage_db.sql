DROP TABLE details_paiement_pres CASCADE CONSTRAINTS PURGE;
DROP TABLE details_paiement_trait CASCADE CONSTRAINTS PURGE;
DROP TABLE Installe_dans CASCADE CONSTRAINTS PURGE;
DROP TABLE Fait_Appel CASCADE CONSTRAINTS PURGE;
DROP TABLE Concerne CASCADE CONSTRAINTS PURGE;
DROP TABLE Choisit CASCADE CONSTRAINTS PURGE;
DROP TABLE EtapeProgramme CASCADE CONSTRAINTS PURGE;
DROP TABLE CONTRAT_PRESTATAIRE CASCADE CONSTRAINTS PURGE;
DROP TABLE CONTRAT_TRAITEUR CASCADE CONSTRAINTS PURGE;
DROP TABLE MENU CASCADE CONSTRAINTS PURGE;
DROP TABLE Personne CASCADE CONSTRAINTS PURGE;
DROP TABLE Mariage CASCADE CONSTRAINTS PURGE;
DROP TABLE TableReception CASCADE CONSTRAINTS PURGE;
DROP TABLE Prestataire CASCADE CONSTRAINTS PURGE;
DROP TABLE Traiteur CASCADE CONSTRAINTS PURGE;
DROP TABLE MODE_FACTURATION CASCADE CONSTRAINTS PURGE;
DROP TABLE REGIME_ALIMENTAIRE CASCADE CONSTRAINTS PURGE;
DROP TABLE Salle CASCADE CONSTRAINTS PURGE;

-- ---------------------------------------------------------------------
-- 2) CRÉATION DES TABLES
-- ---------------------------------------------------------------------
CREATE TABLE Salle (
    ID_SALLE        INT,
    Nom_Salle       VARCHAR(100) NOT NULL,
    Capacite_Salle  INT NOT NULL CHECK (Capacite_Salle > 0),
    Prix_Loc_Salle  DECIMAL(10,2) NOT NULL CHECK (Prix_Loc_Salle >= 0),
    AdresseSalle    VARCHAR(200),
    PRIMARY KEY (ID_SALLE)
);

CREATE TABLE Traiteur (
    ID_TRAITEUR     VARCHAR(50),
    Nom_Trai        VARCHAR(50) NOT NULL,
    Telephone_Trai  VARCHAR(50),
    Email_Trai      VARCHAR(50),
    Adresse_Trai    VARCHAR(50),
    PRIMARY KEY (ID_TRAITEUR),
    UNIQUE (Email_Trai)
);

CREATE TABLE MODE_FACTURATION (
    CODE_FACTURATION INT,
    libelle          VARCHAR(50) NOT NULL,
    PRIMARY KEY (CODE_FACTURATION)
);

CREATE TABLE Prestataire (
    ID_PRESTATAIRE  INT,
    Nom_Pres        VARCHAR(50) NOT NULL,
    Prenom_Pres     VARCHAR(50),
    Telephone_Pres  VARCHAR(50),
    Email_Pres      VARCHAR(50),
    Tarif_Pres      DECIMAL(10,2) NOT NULL CHECK (Tarif_Pres >= 0),
    PRIMARY KEY (ID_PRESTATAIRE),
    UNIQUE (Email_Pres)
);

CREATE TABLE REGIME_ALIMENTAIRE (
    ID_REGIME       VARCHAR(50),
    Libelle_Regime  VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID_REGIME),
    UNIQUE (Libelle_Regime)
);

CREATE TABLE TableReception (
    ID_TABLE       INT,
    NumTable       INT NOT NULL,
    CapaciteTable  INT NOT NULL CHECK (CapaciteTable > 0),
    ID_SALLE       INT NOT NULL,
    PRIMARY KEY (ID_TABLE),
    UNIQUE (ID_SALLE, NumTable),
    FOREIGN KEY (ID_SALLE) REFERENCES Salle(ID_SALLE)
);

CREATE TABLE Mariage (
    ID_MARIAGE   INT,
    Date_Mar     DATE NOT NULL,
    Budget_Mar   DECIMAL(10,2) NOT NULL CHECK (Budget_Mar > 0),
    Nb_Invites   INT NOT NULL CHECK (Nb_Invites > 0),
    Theme_Mar    VARCHAR(100) NOT NULL,
    ID_SALLE     INT NOT NULL,
    PRIMARY KEY (ID_MARIAGE),
    FOREIGN KEY (ID_SALLE) REFERENCES Salle(ID_SALLE)
);

CREATE TABLE MENU (
    ID_MENU       VARCHAR(50),
    Type_Menu     VARCHAR(50) NOT NULL
                  CHECK (Type_Menu IN ('Standard','Vegetarien','Halal','Vegan')),
    Prix_Menu     DECIMAL(10,2) NOT NULL CHECK (Prix_Menu >= 0),
    Intitule_Menu VARCHAR(50),
    ID_REGIME     VARCHAR(50) NOT NULL,
    ID_TRAITEUR   VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID_MENU),
    FOREIGN KEY (ID_REGIME)   REFERENCES REGIME_ALIMENTAIRE(ID_REGIME),
    FOREIGN KEY (ID_TRAITEUR) REFERENCES Traiteur(ID_TRAITEUR)
);

CREATE TABLE Personne (
    ID_PERSONNE     VARCHAR(50),
    Nom_Personne    VARCHAR(50) NOT NULL,
    Prenom_Pers     VARCHAR(50) NOT NULL,
    Telephone_Pers  VARCHAR(50),
    EmailPers       VARCHAR(50),
    RolePers        VARCHAR(50) CHECK (RolePers IN ('Marié','Témoin','Invité')),
    ID_REGIME       VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID_PERSONNE),
    UNIQUE (EmailPers),
    FOREIGN KEY (ID_REGIME) REFERENCES REGIME_ALIMENTAIRE(ID_REGIME)
);

-- TIME n'existe pas en Oracle : heures stockées en 'HH24:MI'
-- TEXT n'existe pas en Oracle : remplacé par CLOB
CREATE TABLE EtapeProgramme (
    ID_ETAPE          INT,
    Heure_Debut_Etape VARCHAR(5) NOT NULL,
    Heure_Fin_Etape   VARCHAR(5) NOT NULL,
    Description_Etape CLOB,
    ID_MARIAGE        INT NOT NULL,
    PRIMARY KEY (ID_ETAPE),
    FOREIGN KEY (ID_MARIAGE) REFERENCES Mariage(ID_MARIAGE)
);

CREATE TABLE CONTRAT_PRESTATAIRE (
    ID_CONTRAT      INT,
    Date_Contrat    DATE NOT NULL,
    Montant_Contrat DECIMAL(10,2) NOT NULL CHECK (Montant_Contrat >= 0),
    Statut_Contrat  VARCHAR(50) NOT NULL
                    CHECK (Statut_Contrat IN ('Signé','En attente','Annulé')),
    Montant_avance  INT DEFAULT 0 CHECK (Montant_avance >= 0),
    ID_PRESTATAIRE  INT NOT NULL,
    ID_MARIAGE      INT NOT NULL,
    PRIMARY KEY (ID_CONTRAT),
    CHECK (Montant_avance <= Montant_Contrat),
    FOREIGN KEY (ID_PRESTATAIRE) REFERENCES Prestataire(ID_PRESTATAIRE),
    FOREIGN KEY (ID_MARIAGE)     REFERENCES Mariage(ID_MARIAGE)
);

CREATE TABLE CONTRAT_TRAITEUR (
    ID_CONTRAT      INT,
    Date_Contrat    DATE NOT NULL,
    Montant_Contrat DECIMAL(10,2) NOT NULL CHECK (Montant_Contrat >= 0),
    Statut_Contrat  VARCHAR(50) NOT NULL
                    CHECK (Statut_Contrat IN ('Signé','En attente','Annulé')),
    Montant_avance  INT DEFAULT 0 CHECK (Montant_avance >= 0),
    ID_TRAITEUR     VARCHAR(50) NOT NULL,
    ID_MARIAGE      INT NOT NULL,
    PRIMARY KEY (ID_CONTRAT),
    CHECK (Montant_avance <= Montant_Contrat),
    FOREIGN KEY (ID_TRAITEUR) REFERENCES Traiteur(ID_TRAITEUR),
    FOREIGN KEY (ID_MARIAGE)  REFERENCES Mariage(ID_MARIAGE)
);

CREATE TABLE Choisit (
    ID_MARIAGE INT,
    ID_MENU    VARCHAR(50),
    PRIMARY KEY (ID_MARIAGE, ID_MENU),
    FOREIGN KEY (ID_MARIAGE) REFERENCES Mariage(ID_MARIAGE),
    FOREIGN KEY (ID_MENU)    REFERENCES MENU(ID_MENU)
);

CREATE TABLE Concerne (
    ID_MARIAGE        INT,
    ID_PERSONNE       VARCHAR(50),
    Statut_invitation VARCHAR(50) NOT NULL
                      CHECK (Statut_invitation IN ('Confirmé','En attente','Annulé')),
    PRIMARY KEY (ID_MARIAGE, ID_PERSONNE),
    FOREIGN KEY (ID_MARIAGE)  REFERENCES Mariage(ID_MARIAGE),
    FOREIGN KEY (ID_PERSONNE) REFERENCES Personne(ID_PERSONNE)
);

-- Association ternaire : une personne est placée à une table pour un mariage donné.
-- La clé étrangère composite garantit que la personne est bien invitée à ce mariage.
CREATE TABLE Installe_dans (
    ID_MARIAGE  INT,
    ID_PERSONNE VARCHAR(50),
    ID_TABLE    INT NOT NULL,
    PRIMARY KEY (ID_MARIAGE, ID_PERSONNE),
    FOREIGN KEY (ID_MARIAGE, ID_PERSONNE) REFERENCES Concerne(ID_MARIAGE, ID_PERSONNE),
    FOREIGN KEY (ID_TABLE) REFERENCES TableReception(ID_TABLE)
);

CREATE TABLE Fait_Appel (
    ID_MARIAGE     INT,
    ID_PRESTATAIRE INT,
    Role_Pres      VARCHAR(50),
    Date_interv    DATE,
    PRIMARY KEY (ID_MARIAGE, ID_PRESTATAIRE),
    FOREIGN KEY (ID_MARIAGE)     REFERENCES Mariage(ID_MARIAGE),
    FOREIGN KEY (ID_PRESTATAIRE) REFERENCES Prestataire(ID_PRESTATAIRE)
);

-- Clé primaire incluant la date : un contrat peut être réglé en plusieurs
-- versements, y compris avec le même mode de facturation.
-- DOUBLE n'existe pas en Oracle : remplacé par DECIMAL(10,2)
CREATE TABLE details_paiement_trait (
    ID_CONTRAT       INT,
    CODE_FACTURATION INT,
    Montant_Paye     DECIMAL(10,2) NOT NULL CHECK (Montant_Paye > 0),
    Date_Paiement    DATE,
    PRIMARY KEY (ID_CONTRAT, CODE_FACTURATION, Date_Paiement),
    FOREIGN KEY (ID_CONTRAT)       REFERENCES CONTRAT_TRAITEUR(ID_CONTRAT),
    FOREIGN KEY (CODE_FACTURATION) REFERENCES MODE_FACTURATION(CODE_FACTURATION)
);

CREATE TABLE details_paiement_pres (
    ID_CONTRAT       INT,
    CODE_FACTURATION INT,
    Montant_Paye     DECIMAL(10,2) NOT NULL CHECK (Montant_Paye > 0),
    Date_Paiement    DATE,
    PRIMARY KEY (ID_CONTRAT, CODE_FACTURATION, Date_Paiement),
    FOREIGN KEY (ID_CONTRAT)       REFERENCES CONTRAT_PRESTATAIRE(ID_CONTRAT),
    FOREIGN KEY (CODE_FACTURATION) REFERENCES MODE_FACTURATION(CODE_FACTURATION)
);

-- ---------------------------------------------------------------------
-- 3) INSERTION DES DONNÉES (fictives)
-- ---------------------------------------------------------------------

-- Salles (la salle 6 n'accueille aucun mariage : utile pour la requête 5)
INSERT INTO Salle VALUES (1, 'Le Grand Palais',      300, 5000.00, 'Sousse');
INSERT INTO Salle VALUES (2, 'Château des Jasmin',   200, 3500.00, 'Hammamet');
INSERT INTO Salle VALUES (3, 'Villa Méditerranée',   500, 9000.00, 'Tunis');
INSERT INTO Salle VALUES (4, 'Domaine des Roses',    150, 2800.00, 'Sfax');
INSERT INTO Salle VALUES (5, 'Manoir du Lac',        250, 4200.00, 'Bizerte');
INSERT INTO Salle VALUES (6, 'Jardin des Oliviers',  180, 3000.00, 'Nabeul');

-- Régimes alimentaires
INSERT INTO REGIME_ALIMENTAIRE VALUES ('1', 'Sans gluten');
INSERT INTO REGIME_ALIMENTAIRE VALUES ('2', 'Végétarien');
INSERT INTO REGIME_ALIMENTAIRE VALUES ('3', 'Vegan');
INSERT INTO REGIME_ALIMENTAIRE VALUES ('4', 'Halal');
INSERT INTO REGIME_ALIMENTAIRE VALUES ('5', 'Sans lactose');
INSERT INTO REGIME_ALIMENTAIRE VALUES ('6', 'Allergie fruits de mer');

-- Modes de facturation
INSERT INTO MODE_FACTURATION VALUES (1, 'Virement bancaire');
INSERT INTO MODE_FACTURATION VALUES (2, 'Chèque');
INSERT INTO MODE_FACTURATION VALUES (3, 'Espèces');
INSERT INTO MODE_FACTURATION VALUES (4, 'Carte bancaire');

-- Traiteurs (le traiteur 5 n'a aucun menu : utile pour la requête 4)
INSERT INTO Traiteur VALUES ('1', 'Saveurs de Tunisie', '73111222', 'contact@saveurs.tn', 'Sousse');
INSERT INTO Traiteur VALUES ('2', 'Le Festin Royal',    '73222333', 'info@festin.tn',      'Tunis');
INSERT INTO Traiteur VALUES ('3', 'Délices du Sud',     '73333444', 'contact@delices.tn',  'Sfax');
INSERT INTO Traiteur VALUES ('4', 'Gourmet Express',    '73444555', 'hello@gourmet.tn',    'Hammamet');
INSERT INTO Traiteur VALUES ('5', 'Table d''Or',        '73555666', 'contact@tabledor.tn', 'Nabeul');

-- Prestataires (le 6 n'intervient nulle part ; le 7 a le même tarif que le 2)
INSERT INTO Prestataire VALUES (1, 'Martin',   'Sophie',  '55100200', 'sophie@photo.tn',   800.00);
INSERT INTO Prestataire VALUES (2, 'Dupont',   'Julien',  '55200300', 'julien@dj.tn',      600.00);
INSERT INTO Prestataire VALUES (3, 'Bernard',  'Claire',  '55300400', 'claire@fleurs.tn',  450.00);
INSERT INTO Prestataire VALUES (4, 'Lemoine',  'Antoine', '55400500', 'antoine@video.tn',  750.00);
INSERT INTO Prestataire VALUES (5, 'Rousseau', 'Marie',   '55500600', 'marie@deco.tn',     500.00);
INSERT INTO Prestataire VALUES (6, 'Fontaine', 'Thomas',  '55600700', 'thomas@anim.tn',    400.00);
INSERT INTO Prestataire VALUES (7, 'Gharbi',   'Omar',    '55700800', 'omar@dj2.tn',       600.00);

-- Tables de réception (rattachées à une salle)
INSERT INTO TableReception VALUES (1, 1, 10, 1);
INSERT INTO TableReception VALUES (2, 2, 10, 1);
INSERT INTO TableReception VALUES (3, 3,  8, 1);
INSERT INTO TableReception VALUES (4, 1, 10, 2);
INSERT INTO TableReception VALUES (5, 2,  8, 2);
INSERT INTO TableReception VALUES (6, 1, 12, 3);
INSERT INTO TableReception VALUES (7, 2, 12, 3);
INSERT INTO TableReception VALUES (8, 1,  8, 4);
INSERT INTO TableReception VALUES (9, 1,  6, 5);

-- Mariages (102 et 106 ont lieu le même jour : utile pour la requête 6)
INSERT INTO Mariage VALUES (101, TO_DATE('2025-06-14','YYYY-MM-DD'), 25000.00, 150, 'Romantique Champêtre', 1);
INSERT INTO Mariage VALUES (102, TO_DATE('2025-09-20','YYYY-MM-DD'), 18000.00, 100, 'Oriental Moderne',     2);
INSERT INTO Mariage VALUES (103, TO_DATE('2025-11-08','YYYY-MM-DD'), 30000.00, 200, 'Élégance Moderne',     3);
INSERT INTO Mariage VALUES (104, TO_DATE('2026-03-22','YYYY-MM-DD'), 15000.00,  80, 'Bohème Naturel',       4);
INSERT INTO Mariage VALUES (105, TO_DATE('2026-07-05','YYYY-MM-DD'), 22000.00, 180, 'Gatsby Années 20',     5);
INSERT INTO Mariage VALUES (106, TO_DATE('2025-09-20','YYYY-MM-DD'), 12000.00,  90, 'Traditionnel Tunisien',4);

-- Personnes (mariés, témoins et quelques invités)
INSERT INTO Personne VALUES ('1',  'Ben Ali',   'Sami',    '11111111', 'sami@mail.com',    'Marié',  '1');
INSERT INTO Personne VALUES ('2',  'Gharbi',    'Ines',    '22222222', 'ines@mail.com',    'Marié',  '2');
INSERT INTO Personne VALUES ('3',  'Trabelsi',  'Youssef', '22333555', 'youssef@mail.com', 'Témoin', '2');
INSERT INTO Personne VALUES ('4',  'Mansouri',  'Fatma',   '22444666', 'fatma@mail.com',   'Témoin', '1');
INSERT INTO Personne VALUES ('5',  'Bouali',    'Khaled',  '22555777', 'khaled@mail.com',  'Invité', '4');
INSERT INTO Personne VALUES ('6',  'Khelifi',   'Amira',   '22666888', 'amira@mail.com',   'Invité', '3');
INSERT INTO Personne VALUES ('7',  'Saidi',     'Rami',    '22777999', 'rami@mail.com',    'Invité', '2');
INSERT INTO Personne VALUES ('8',  'Hamdi',     'Emna',    '22333444', 'emna@mail.com',    'Invité', '5');
INSERT INTO Personne VALUES ('9',  'Hammami',   'Leila',   '22888000', 'leila@mail.com',   'Invité', '6');
INSERT INTO Personne VALUES ('10', 'Chaabane',  'Nizar',   '22999111', 'nizar@mail.com',   'Marié',  '4');
INSERT INTO Personne VALUES ('11', 'Ayari',     'Sonia',   '23111222', 'sonia@mail.com',   'Marié',  '1');
INSERT INTO Personne VALUES ('12', 'Jebali',    'Mohamed', '23222333', 'mohamed@mail.com', 'Invité', '2');
INSERT INTO Personne VALUES ('13', 'Zouari',    'Karim',   '23333444', 'karim@mail.com',   'Marié',  '3');
INSERT INTO Personne VALUES ('14', 'Kefi',      'Rim',     '23444555', 'rim@mail.com',     'Marié',  '1');
INSERT INTO Personne VALUES ('15', 'Dridi',     'Walid',   '23555666', 'walid@mail.com',   'Marié',  '5');
INSERT INTO Personne VALUES ('16', 'Meddeb',    'Salma',   '23666777', 'salma@mail.com',   'Marié',  '1');
INSERT INTO Personne VALUES ('17', 'Karray',    'Aymen',   '23777888', 'aymen@mail.com',   'Marié',  '1');
INSERT INTO Personne VALUES ('18', 'Belhadj',   'Yasmine', '23888999', 'yasmine@mail.com', 'Marié',  '2');

-- Menus
INSERT INTO MENU VALUES ('1', 'Standard',   120.00, 'Menu Prestige 5 services', '1', '1');
INSERT INTO MENU VALUES ('2', 'Vegetarien',  90.00, 'Menu Végétarien Délicat',  '2', '1');
INSERT INTO MENU VALUES ('3', 'Halal',       95.00, 'Menu Halal Festif',        '4', '2');
INSERT INTO MENU VALUES ('4', 'Standard',    85.00, 'Menu Classique',           '1', '2');
INSERT INTO MENU VALUES ('5', 'Vegan',       80.00, 'Menu Vegan Nature',        '3', '3');
INSERT INTO MENU VALUES ('6', 'Standard',    75.00, 'Menu Méditerranéen',       '1', '4');

-- Menus choisis par mariage
INSERT INTO Choisit VALUES (101, '1');
INSERT INTO Choisit VALUES (101, '2');
INSERT INTO Choisit VALUES (102, '3');
INSERT INTO Choisit VALUES (102, '4');
INSERT INTO Choisit VALUES (103, '6');
INSERT INTO Choisit VALUES (104, '5');
INSERT INTO Choisit VALUES (105, '4');
INSERT INTO Choisit VALUES (106, '6');

-- Invitations (Concerne)
INSERT INTO Concerne VALUES (101, '1',  'Confirmé');
INSERT INTO Concerne VALUES (101, '2',  'Confirmé');
INSERT INTO Concerne VALUES (101, '3',  'Confirmé');
INSERT INTO Concerne VALUES (101, '4',  'En attente');
INSERT INTO Concerne VALUES (101, '5',  'Annulé');
INSERT INTO Concerne VALUES (102, '10', 'Confirmé');
INSERT INTO Concerne VALUES (102, '11', 'Confirmé');
INSERT INTO Concerne VALUES (102, '6',  'Confirmé');
INSERT INTO Concerne VALUES (102, '7',  'En attente');
INSERT INTO Concerne VALUES (102, '12', 'Confirmé');
INSERT INTO Concerne VALUES (103, '13', 'Confirmé');
INSERT INTO Concerne VALUES (103, '14', 'Confirmé');
INSERT INTO Concerne VALUES (103, '8',  'Confirmé');
INSERT INTO Concerne VALUES (103, '9',  'Confirmé');
INSERT INTO Concerne VALUES (104, '15', 'Confirmé');
INSERT INTO Concerne VALUES (104, '16', 'Confirmé');
INSERT INTO Concerne VALUES (105, '17', 'Confirmé');
INSERT INTO Concerne VALUES (105, '18', 'Confirmé');
INSERT INTO Concerne VALUES (106, '9',  'En attente');

-- 55 invités supplémentaires pour le mariage 101 (génération automatique),
-- afin que la requête 9 (> 50 invités confirmés) retourne un résultat :
-- 52 confirmés + 2 en attente + 1 annulé (+ 3 confirmés ci-dessus = 55 confirmés)
BEGIN
    FOR i IN 1..55 LOOP
        INSERT INTO Personne VALUES (
            'G' || i,
            'Invite' || i,
            'Prenom' || i,
            '24' || LPAD(i, 6, '0'),
            'invite' || i || '@mail.com',
            'Invité',
            TO_CHAR(MOD(i, 6) + 1)
        );
        INSERT INTO Concerne VALUES (
            101,
            'G' || i,
            CASE WHEN i <= 52 THEN 'Confirmé'
                 WHEN i <= 54 THEN 'En attente'
                 ELSE 'Annulé' END
        );
    END LOOP;
    COMMIT;
END;
/

-- Plan de table (les tables appartiennent à la salle du mariage)
INSERT INTO Installe_dans VALUES (101, '1',  1);
INSERT INTO Installe_dans VALUES (101, '2',  1);
INSERT INTO Installe_dans VALUES (101, '3',  2);
INSERT INTO Installe_dans VALUES (101, '4',  2);
INSERT INTO Installe_dans VALUES (102, '10', 4);
INSERT INTO Installe_dans VALUES (102, '11', 4);
INSERT INTO Installe_dans VALUES (102, '6',  5);
INSERT INTO Installe_dans VALUES (102, '12', 5);
INSERT INTO Installe_dans VALUES (103, '13', 6);
INSERT INTO Installe_dans VALUES (103, '14', 6);
INSERT INTO Installe_dans VALUES (103, '8',  7);
INSERT INTO Installe_dans VALUES (103, '9',  7);
INSERT INTO Installe_dans VALUES (104, '15', 8);
INSERT INTO Installe_dans VALUES (104, '16', 8);
INSERT INTO Installe_dans VALUES (105, '17', 9);
INSERT INTO Installe_dans VALUES (105, '18', 9);

-- Interventions des prestataires
INSERT INTO Fait_Appel VALUES (101, 1, 'Photographe', TO_DATE('2025-06-14','YYYY-MM-DD'));
INSERT INTO Fait_Appel VALUES (101, 2, 'DJ',          TO_DATE('2025-06-14','YYYY-MM-DD'));
INSERT INTO Fait_Appel VALUES (101, 3, 'Fleuriste',   TO_DATE('2025-06-14','YYYY-MM-DD'));
INSERT INTO Fait_Appel VALUES (101, 4, 'Vidéaste',    TO_DATE('2025-06-14','YYYY-MM-DD'));
INSERT INTO Fait_Appel VALUES (102, 2, 'DJ',          TO_DATE('2025-09-20','YYYY-MM-DD'));
INSERT INTO Fait_Appel VALUES (102, 5, 'Décorateur',  TO_DATE('2025-09-20','YYYY-MM-DD'));
INSERT INTO Fait_Appel VALUES (103, 1, 'Photographe', TO_DATE('2025-11-08','YYYY-MM-DD'));
INSERT INTO Fait_Appel VALUES (103, 3, 'Fleuriste',   TO_DATE('2025-11-08','YYYY-MM-DD'));
INSERT INTO Fait_Appel VALUES (106, 7, 'DJ',          TO_DATE('2025-09-20','YYYY-MM-DD'));

-- Contrats prestataires
INSERT INTO CONTRAT_PRESTATAIRE VALUES (201, TO_DATE('2024-05-10','YYYY-MM-DD'), 800.00, 'Signé',      300, 1, 101);
INSERT INTO CONTRAT_PRESTATAIRE VALUES (202, TO_DATE('2024-05-12','YYYY-MM-DD'), 600.00, 'Signé',      200, 2, 101);
INSERT INTO CONTRAT_PRESTATAIRE VALUES (203, TO_DATE('2024-05-15','YYYY-MM-DD'), 450.00, 'Signé',      150, 3, 101);
INSERT INTO CONTRAT_PRESTATAIRE VALUES (204, TO_DATE('2024-05-20','YYYY-MM-DD'), 750.00, 'Signé',      250, 4, 101);
INSERT INTO CONTRAT_PRESTATAIRE VALUES (205, TO_DATE('2024-06-15','YYYY-MM-DD'), 600.00, 'Signé',      200, 2, 102);
INSERT INTO CONTRAT_PRESTATAIRE VALUES (206, TO_DATE('2024-06-20','YYYY-MM-DD'), 500.00, 'En attente',   0, 5, 102);
INSERT INTO CONTRAT_PRESTATAIRE VALUES (207, TO_DATE('2024-07-20','YYYY-MM-DD'), 800.00, 'Signé',      300, 1, 103);
INSERT INTO CONTRAT_PRESTATAIRE VALUES (208, TO_DATE('2024-07-22','YYYY-MM-DD'), 450.00, 'Signé',      150, 3, 103);

-- Contrats traiteurs (304 et 305 sans aucun paiement : utile pour la requête 14)
INSERT INTO CONTRAT_TRAITEUR VALUES (301, TO_DATE('2024-08-01','YYYY-MM-DD'),  9500.00, 'Signé',      3000, '1', 101);
INSERT INTO CONTRAT_TRAITEUR VALUES (302, TO_DATE('2024-09-10','YYYY-MM-DD'),  7000.00, 'Signé',      2000, '2', 102);
INSERT INTO CONTRAT_TRAITEUR VALUES (303, TO_DATE('2024-10-05','YYYY-MM-DD'), 14000.00, 'Signé',      5000, '4', 103);
INSERT INTO CONTRAT_TRAITEUR VALUES (304, TO_DATE('2024-10-20','YYYY-MM-DD'),  6000.00, 'En attente',   0,  '3', 104);
INSERT INTO CONTRAT_TRAITEUR VALUES (305, TO_DATE('2024-11-01','YYYY-MM-DD'),  8000.00, 'En attente',   0,  '2', 105);

-- Paiements des contrats traiteurs
INSERT INTO details_paiement_trait VALUES (301, 1, 3000.00, TO_DATE('2024-08-01','YYYY-MM-DD'));
INSERT INTO details_paiement_trait VALUES (301, 1, 3500.00, TO_DATE('2025-03-10','YYYY-MM-DD'));
INSERT INTO details_paiement_trait VALUES (301, 2, 3000.00, TO_DATE('2025-06-01','YYYY-MM-DD'));
INSERT INTO details_paiement_trait VALUES (302, 1, 2000.00, TO_DATE('2024-09-10','YYYY-MM-DD'));
INSERT INTO details_paiement_trait VALUES (302, 4, 2500.00, TO_DATE('2025-07-15','YYYY-MM-DD'));
INSERT INTO details_paiement_trait VALUES (303, 1, 5000.00, TO_DATE('2024-10-05','YYYY-MM-DD'));

-- Paiements des contrats prestataires
INSERT INTO details_paiement_pres VALUES (201, 1, 300.00, TO_DATE('2024-05-10','YYYY-MM-DD'));
INSERT INTO details_paiement_pres VALUES (201, 3, 500.00, TO_DATE('2025-05-30','YYYY-MM-DD'));
INSERT INTO details_paiement_pres VALUES (202, 1, 200.00, TO_DATE('2024-05-12','YYYY-MM-DD'));
INSERT INTO details_paiement_pres VALUES (202, 3, 400.00, TO_DATE('2025-06-10','YYYY-MM-DD'));
INSERT INTO details_paiement_pres VALUES (203, 2, 150.00, TO_DATE('2024-05-15','YYYY-MM-DD'));
INSERT INTO details_paiement_pres VALUES (205, 1, 200.00, TO_DATE('2024-06-15','YYYY-MM-DD'));
INSERT INTO details_paiement_pres VALUES (207, 1, 300.00, TO_DATE('2024-07-20','YYYY-MM-DD'));

-- Programme des mariages
INSERT INTO EtapeProgramme VALUES (1, '16:00', '17:00', 'Accueil des invités',        101);
INSERT INTO EtapeProgramme VALUES (2, '17:00', '18:30', 'Cérémonie',                  101);
INSERT INTO EtapeProgramme VALUES (3, '19:00', '23:00', 'Dîner et soirée dansante',   101);
INSERT INTO EtapeProgramme VALUES (4, '18:00', '19:00', 'Cérémonie',                  102);
INSERT INTO EtapeProgramme VALUES (5, '19:30', '23:30', 'Dîner et animation DJ',      102);
INSERT INTO EtapeProgramme VALUES (6, '17:00', '18:00', 'Séance photo des mariés',    103);
INSERT INTO EtapeProgramme VALUES (7, '19:00', '00:00', 'Dîner de gala',              103);

COMMIT;

-- ---------------------------------------------------------------------
-- 4) REQUÊTES SQL
-- ---------------------------------------------------------------------

-- 1. Projection, restriction et tri
SELECT Nom_Salle, Capacite_Salle, Prix_Loc_Salle
FROM Salle
WHERE Capacite_Salle >= 200
ORDER BY Prix_Loc_Salle DESC;

-- 2. Jointure interne simple (2 tables)
SELECT M.ID_MARIAGE, M.Date_Mar, M.Theme_Mar, S.Nom_Salle
FROM Mariage M
JOIN Salle S ON M.ID_SALLE = S.ID_SALLE;

-- 3. Jointure interne multiple (4 tables)
SELECT P.Nom_Personne, P.Prenom_Pers, M.Theme_Mar, T.NumTable
FROM Installe_dans I
JOIN Personne P       ON I.ID_PERSONNE = P.ID_PERSONNE
JOIN Mariage M        ON I.ID_MARIAGE  = M.ID_MARIAGE
JOIN TableReception T ON I.ID_TABLE    = T.ID_TABLE;

-- 4. Jointure externe avec agrégation (LEFT JOIN + GROUP BY)
SELECT T.ID_TRAITEUR, T.Nom_Trai, COUNT(M.ID_MENU) AS Nombre_Menus
FROM Traiteur T
LEFT JOIN MENU M ON T.ID_TRAITEUR = M.ID_TRAITEUR
GROUP BY T.ID_TRAITEUR, T.Nom_Trai;

-- 5. Jointure externe avec recherche d'absence (IS NULL)
SELECT S.ID_SALLE, S.Nom_Salle, S.AdresseSalle
FROM Salle S
LEFT JOIN Mariage M ON S.ID_SALLE = M.ID_SALLE
WHERE M.ID_MARIAGE IS NULL;

-- 6. Auto-jointure 1 : mariages à la même date
SELECT M1.ID_MARIAGE AS Mariage_1, M2.ID_MARIAGE AS Mariage_2, M1.Date_Mar
FROM Mariage M1
JOIN Mariage M2 ON M1.Date_Mar = M2.Date_Mar AND M1.ID_MARIAGE < M2.ID_MARIAGE;

-- 7. Auto-jointure 2 : prestataires au même tarif
SELECT P1.Nom_Pres AS Prestataire_1, P2.Nom_Pres AS Prestataire_2, P1.Tarif_Pres
FROM Prestataire P1
JOIN Prestataire P2 ON P1.Tarif_Pres = P2.Tarif_Pres AND P1.ID_PRESTATAIRE < P2.ID_PRESTATAIRE;

-- 8. Groupement et agrégation (GROUP BY + SUM)
SELECT C.ID_CONTRAT, C.Montant_Contrat, SUM(D.Montant_Paye) AS Total_Encaisse
FROM CONTRAT_TRAITEUR C
JOIN details_paiement_trait D ON C.ID_CONTRAT = D.ID_CONTRAT
GROUP BY C.ID_CONTRAT, C.Montant_Contrat;

-- 9. Groupement avec condition sur agrégat (HAVING)
SELECT C.ID_MARIAGE, COUNT(C.ID_PERSONNE) AS Nombre_Confirmes
FROM Concerne C
WHERE C.Statut_invitation = 'Confirmé'
GROUP BY C.ID_MARIAGE
HAVING COUNT(C.ID_PERSONNE) > 50;

-- 10. Sous-requête scalaire
SELECT ID_MARIAGE, Theme_Mar, Budget_Mar
FROM Mariage
WHERE Budget_Mar > (
    SELECT AVG(Budget_Mar)
    FROM Mariage
);

-- 11. Sous-requête avec NOT IN
SELECT ID_PRESTATAIRE, Nom_Pres, Prenom_Pres, Tarif_Pres
FROM Prestataire
WHERE ID_PRESTATAIRE NOT IN (
    SELECT DISTINCT ID_PRESTATAIRE
    FROM Fait_Appel
);

-- 12. Sous-requête corrélée avec EXISTS
SELECT R.ID_REGIME, R.Libelle_Regime
FROM REGIME_ALIMENTAIRE R
WHERE EXISTS (
    SELECT 1
    FROM Personne P
    WHERE P.ID_REGIME = R.ID_REGIME
      AND P.RolePers = 'Marié'
);

-- 13. Opération ensembliste (UNION ALL)
SELECT 'Contrat Traiteur' AS Type_Contrat, D.ID_CONTRAT, D.Date_Paiement, D.Montant_Paye, M.libelle AS Mode_Facturation
FROM details_paiement_trait D
JOIN MODE_FACTURATION M ON D.CODE_FACTURATION = M.CODE_FACTURATION
UNION ALL
SELECT 'Contrat Prestataire' AS Type_Contrat, D.ID_CONTRAT, D.Date_Paiement, D.Montant_Paye, M.libelle AS Mode_Facturation
FROM details_paiement_pres D
JOIN MODE_FACTURATION M ON D.CODE_FACTURATION = M.CODE_FACTURATION
ORDER BY Date_Paiement DESC;

-- 14. Table dérivée (sous-requête dans le FROM)
SELECT C.ID_CONTRAT, C.Montant_Contrat,
       COALESCE(P.Total_Paye, 0) AS Total_Paye,
       (C.Montant_Contrat - COALESCE(P.Total_Paye, 0)) AS Reste_A_Payer
FROM CONTRAT_TRAITEUR C
LEFT JOIN (
    SELECT ID_CONTRAT, SUM(Montant_Paye) AS Total_Paye
    FROM details_paiement_trait
    GROUP BY ID_CONTRAT
) P ON C.ID_CONTRAT = P.ID_CONTRAT;

-- 15. Quantificateur universel (>= ALL)
SELECT ID_MARIAGE, Theme_Mar, Budget_Mar, Date_Mar
FROM Mariage
WHERE Budget_Mar >= ALL (
    SELECT Budget_Mar
    FROM Mariage
);
