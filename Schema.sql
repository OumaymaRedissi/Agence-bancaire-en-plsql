CREATE TABLE Banque (	num_b DECIMAL( 5 ) ,
			nom_b VARCHAR2( 9 ) NOT NULL ,
			PRIMARY KEY ( num_b ) 
) ;
CREATE TABLE Agence (
			num_a DECIMAL( 5 ) ,
			num_b DECIMAL( 5 ) ,
			chef_a VARCHAR2(25) ,
			telephone_a VARCHAR2(20) NOT NULL,
			devise_a VARCHAR2( 3 ) NOT NULL,
			PRIMARY KEY (num_a, num_b) ,
			FOREIGN KEY ( num_b ) REFERENCES banque ( num_b )
 ) ;
CREATE TABLE Client (
			id_cl DECIMAL( 5 ) ,
			nom VARCHAR2(25) NOT NULL,
			prenom VARCHAR2(25) NOT NULL,
			telephone VARCHAR2(255) NOT NULL,
			email VARCHAR2(255) ,
			adresse VARCHAR2(100) NOT NULL,
			num_a DECIMAL( 5 ) ,
			num_b DECIMAL( 5 ) ,
			PRIMARY KEY ( id_cl ) ,
			FOREIGN KEY ( num_a, num_b) REFERENCES agence (num_a, num_b) 
) ;
CREATE TABLE Parrainer (
			id_parraine DECIMAL( 5 ) ,
			id_parrain DECIMAL( 5 ) ,
			prime_fid NUMBER(19,4) NOT NULL,
			FOREIGN KEY ( id_parraine ) REFERENCES client (id_cl ),
			FOREIGN KEY ( id_parrain ) REFERENCES client (id_cl ),
			PRIMARY KEY ( id_parraine, id_parrain ) 
) ;
CREATE TABLE tmm (
			id_tmm DECIMAL( 5 ) ,
			valeur_t NUMBER(19,4 ) NOT NULL,
			date_t DATE NOT NULL,
			PRIMARY KEY ( id_tmm )
 ) ;
CREATE TABLE Pret (
			id_pret DECIMAL( 5 ) ,
			type_p VARCHAR2(50) NOT NULL,
			raison_p VARCHAR2(50) NOT NULL,
			montant_p NUMBER(19,4) NOT NULL,
			taux_interet_p NUMBER(19,4) NOT NULL,
			date_ob_p DATE,
			date_limite_p DATE,
			PRIMARY KEY ( id_pret ) ,
			CHECK ( type_p in('Maison','Voiture','Autre' ))
 ) ;
CREATE TABLE Devise (
			id_dev DECIMAL( 5 ) ,
			designation VARCHAR2(30) NOT NULL,
			code VARCHAR2( 3 ) NOT NULL,
			unite NUMBER(10) NOT NULL,
			PRIMARY KEY ( id_dev ) 
) ;
CREATE TABLE Compte (
			num_co DECIMAL( 5 ) ,
			date_ouver_c DATE NOT NULL,
			solde_c NUMBER(19,4) NOT NULL,
			frais_c NUMBER(19,4) NOT NULL,
			etat_c VARCHAR(30) NOT NULL,
			type_c VARCHAR2(255) NOT NULL,
			rib_cc NUMBER UNIQUE ,
			decouvert_max_cc NUMBER(19,4) ,
			taux_int_ce NUMBER(19,4) ,
			id_dev DECIMAL(5 ) ,
			id_pret DECIMAL( 5 ) ,
			id_cl DECIMAL( 5 ) ,
			PRIMARY KEY ( num_co ) ,
			FOREIGN KEY ( id_dev )REFERENCES devise ( id_dev) ,
			FOREIGN KEY( id_pret )REFERENCES pret ( id_pret ),
			FOREIGN KEY( id_cl )REFERENCES client ( id_cl ) ,
			CHECK ( ( etat_c in ( 'Active' , 'Bloque' ) ) and (type_c in ( 'Courant' , 'Devise' , 'Epargne' ) ) )
 ) ;
CREATE TABLE Operation (
			num_op DECIMAL( 5 ) ,
			type_op VARCHAR2(30) NOT NULL,
			date_op DATE NOT NULL,
			montant_op NUMBER(19,4) NOT NULL,
			libelle_op VARCHAR2 (255) ,
			id_tmm DECIMAL( 5 ) NOT NULL,
			num_co DECIMAL( 5 ) NOT NULL,
			PRIMARY KEY ( num_op ) ,
			FOREIGN KEY ( num_co ) REFERENCES compte ( num_co ) ,
			FOREIGN KEY ( id_tmm ) REFERENCES tmm ( id_tmm ),
			CHECK ( type_op in ('Debit','Credit') )
);
CREATE TABLE carte (
			num_car NUMBER(20) ,
			plafond NUMBER(19,4) ,
			type_car VARCHAR2(255) NOT NULL,
			date_ob_car DATE,
			num_co DECIMAL( 5 )NOT NULL,
			PRIMARY KEY ( num_car ) ,
			FOREIGN KEY (num_co)REFERENCES compte (num_co) ,
			CHECK ( type_car in ( 'A' , 'B' ) ) 
);
CREATE TABLE Chequier (
			num_ch DECIMAL( 20 ),
			nb_ch NUMBER NOT NULL,
			type_ch VARCHAR2(255) NOT NULL,
			date_ob_ch DATE,
			num_co DECIMAL( 5 ) NOT NULL,
			PRIMARY KEY ( num_ch) ,
			FOREIGN KEY(num_co)REFERENCES compte (num_co) ,
			CHECK ( type_ch in ('A','B') ) 
) ;