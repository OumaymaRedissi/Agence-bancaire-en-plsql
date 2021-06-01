/***********Manipulation des données************/
-- Ajouter client Oumayma Redissi à l'agence numéro 5 de la banque STB 
create sequence seq_client start with 531 increment by 1;
Insert into client
values(seq_client.nextval, 'Oumayma', 'Redissi', '669-860-9209', 'redissi.oumaima@gmail.com', '12 rue Ribat Rades Meliane', 5,
(select num_b from banque where nom_b='STB'));
commit ;
-- Créer trois comptes des différents type pour Oumayma Redissi ayant comme id_cl=531
create sequence seq_compte start with 801 increment by 1;

INSERT INTO COMPTE (NUM_CO, DATE_OUVER_C, SOLDE_C, FRAIS_C, ETAT_C, TYPE_C, RIB_CC, DECOUVERT_MAX_CC, TAUX_INT_CE, ID_DEV, ID_PRET, ID_CL) 
VALUES (seq_compte.nextval, to_date(sysdate, 'YYYY-MM-DD:HH24:MI:SS'), 0, 0, 'Active', 'Courant', 5010999679910612, 1000, NULL, NULL, NULL, 531);

INSERT INTO COMPTE (NUM_CO, DATE_OUVER_C, SOLDE_C, FRAIS_C, ETAT_C, TYPE_C, RIB_CC, DECOUVERT_MAX_CC, TAUX_INT_CE, ID_DEV, ID_PRET, ID_CL) 
VALUES (seq_compte.nextval, to_date(sysdate, 'YYYY-MM-DD:HH24:MI:SS'), 0, 0, 'Active', 'Epargne', NULL, NULL, 0.704, NULL, NULL, 531);

INSERT INTO COMPTE (NUM_CO, DATE_OUVER_C, SOLDE_C, FRAIS_C, ETAT_C, TYPE_C, RIB_CC, DECOUVERT_MAX_CC, TAUX_INT_CE, ID_DEV, ID_PRET, ID_CL) 
VALUES (seq_compte.nextval, to_date(sysdate, 'YYYY-MM-DD:HH24:MI:SS'), 0, 0,  'Active', 'Devise', NULL, NULL, NULL, 124, NULL, 531);

 
--Supprimer la carte numero 1000001048
 delete from carte where num_car=1000001048;
commit;

-- Modifier le taux d'interet du pret du monsieur Lani McCole  en 0.25
update pret
set taux_interet_p=0.25
where id_pret= any(select co.id_pret from compte co, client c
                where c.id_cl=co.id_cl and c.nom='McCole'and  c.prenom='Lani');

/*******Requêtes simples*********/
-- Toutes les clients qui ont un nom qui commence par un b
select * from client
where  nom like 'A%';
-- Toutes les opération éffectuée en 2020
select * from operation
where to_char(date_op,'yyyy') = 2020
order by date_op;
/**************Jointures-sous requêtes- requêtes quantifiées***********/

--Les client qui ont un compte courant créé entre 2002 et 2005 et qui ont un ’a’ comme deuxième lettre de leur nom de famille.
 Select c.id_cl,nom,prenom from client c ,compte co
 where (upper(nom) like upper('_a%')) 
 and (co.id_cl=c.id_cl)
 and (co.type_c='Courant')
 and (to_char(co.date_ouver_c,'yyyy')  between 2002 AND 2005)
 order by c.id_cl;
 
 -- Les clients parrain
select * 
from client c, parrainer p
where c.id_cl=p.id_parrain;

-- les clients qui ont un pret 
select c.id_cl,nom,prenom from client c ,compte co, pret pr
where co.id_cl=c.id_cl and co.id_pret=pr.id_pret and co.etat_c='Active';

--Les client de l'agence 4 de la banque 1 qui on au moins un compte activé
select * 
from client c
where c.num_a=4 and c.num_b=1 and exists (select * from compte co
                                            where co.id_cl=c.id_cl and co.etat_c='Active'  
                                            );
--Les clients qui ont plus de 2 chéquiers 
select c.id_cl,nom,prenom from client c 
where 2 <= (select count( ch.num_ch) from compte co, chequier ch
            where ch.num_co=co.num_co and co.id_cl=c.id_cl and co.etat_c='Active');

/***********Négation et requêtes composées************/

--Les clients qui n'ont pas de carte bancaire 
select *
from client c
where not exists (select * from compte co, carte ca  
                    where co.id_cl=c.id_cl and ca.num_co=co.num_co ) ;
/***********Agrégats et Division************/
-- Le client le plus ancien
Select prenom, nom  from client c, compte co  
where co.id_cl=c.id_cl
and co.date_ouver_c = (select min(date_ouver_c) from compte) ;

-- Le client le plus riche
Select prenom, nom  from client c, compte co  
where co.id_cl=c.id_cl
and co.solde_c >= all(select solde_c from compte) ;


--Les client ayant un nombre de compte > au nombre moyen de compte par client
select c.id_cl,c.nom,c.prenom
from client c, compte co
where c.id_cl=co.id_cl
group by c.id_cl,c.nom,c.prenom
having (count(*)) >= (select avg(CL.nbCo) from 
(select c1.id_cl, count(*) as nbCo
 from client c1, compte co1
 where c1.id_cl=co1.id_cl
 Group by c1.id_cl) CL);
 
 --Les clients qui ont tous les types des comptes

select c.id_cl,c.nom,c.prenom
from client c, compte co
where c.id_cl=co.id_cl
group by c.id_cl,c.nom,c.prenom
having count(distinct co.type_c)=(select count(distinct type_c)from compte);
 




