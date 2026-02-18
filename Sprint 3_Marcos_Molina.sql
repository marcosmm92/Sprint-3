#SPRINT 3: Manipulació de taules

#NIVELL 1

#EXERCICI 1: La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. 
#La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i "company"). 
#Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". 
#Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.

CREATE TABLE transactions.credit_card (
	id VARCHAR(20) NOT NULL PRIMARY KEY,
    iban VARCHAR(50) NOT NULL UNIQUE,
    pan VARCHAR(50) NOT NULL UNIQUE, 
    pin CHAR(4) NOT NULL, 
    cvv CHAR(3) NOT NULL, 
    expiring_date VARCHAR(20) NOT NULL
);
    
ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_credit_card
	FOREIGN KEY (credit_card_id)  
	REFERENCES credit_card(id);
    
#EXERCICI 2: El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit amb ID CcU-2938. 
#La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. Recorda mostrar que el canvi es va realitzar.
UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

#EXERCICI 3: En la taula "transaction" ingressa una nova transacció amb la següent informació:
INSERT INTO company (id)
VALUES ('b-9999');

INSERT INTO credit_card (id)
VALUES ('CcU-9999');

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, 111.11, 0);

#EXERCICI 4: Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.
ALTER TABLE credit_card DROP COLUMN pan;

########################################

#NIVELL 2

#EXERCICI 1: Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.
SELECT *
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

DELETE FROM transaction 
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

SELECT *
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

#EXERCICI 2: La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. S'ha sol·licitat crear una vista 
#que proporcioni detalls clau sobre les companyies i les seves transaccions. Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: 
#Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
#Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.
CREATE VIEW VistaMarketing AS 
SELECT c.company_name, c.phone, c.country, ROUND(AVG(t.amount), 2) AS mitjana_compra
FROM company c
JOIN transaction t ON c.id = t.company_id
WHERE t.declined=0
GROUP BY c.id;

SELECT *
FROM VistaMarketing
ORDER BY mitjana_compra DESC;

#EXERCICI 3: Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"
SELECT *
FROM VistaMarketing
WHERE country = 'Germany';

########################################

#NIVELL 3

#EXERCICI 1: La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. Un company del teu equip va realitzar modificacions en la base de dades, 
#però no recorda com les va realitzar. Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama:
CREATE TABLE IF NOT EXISTS user (
	id CHAR(10) PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)    
);

SELECT *
FROM user;

RENAME TABLE user TO data_user;

ALTER TABLE data_user
RENAME COLUMN email TO personal_email,
MODIFY COLUMN id INT;

ALTER TABLE company
DROP COLUMN website;

ALTER TABLE credit_card
MODIFY COLUMN pin VARCHAR(4),
MODIFY COLUMN cvv INT,
ADD fecha_actual DATE;
    
SELECT DISTINCT t.user_id
FROM transaction t
LEFT JOIN data_user d ON t.user_id = d.id
WHERE d.id IS NULL;

INSERT INTO data_user (id)
VALUES (9999);

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_data_user
	FOREIGN KEY (user_id)	
	REFERENCES data_user(id);

#EXERCICI 2: L'empresa també us demana crear una vista anomenada "InformeTecnico" que contingui la següent informació:
#ID de la transacció, Nom de l'usuari/ària, Cognom de l'usuari/ària, IBAN de la targeta de crèdit usada, Nom de la companyia de la transacció realitzada.
#Assegureu-vos d'incloure informació rellevant de les taules que coneixereu i utilitzeu àlies per canviar de nom columnes segons calgui.
#Mostra els resultats de la vista, ordena els resultats de forma descendent en funció de la variable ID de transacció.
CREATE VIEW InformeTecnico AS
SELECT t.id, d.name AS nom, d.surname AS cognom, d.country AS país_usuari, cc.iban, t.amount AS `import`, t.declined AS rebutjada, co.company_name AS nom_companyia
FROM transaction t
JOIN data_user d 	ON t.user_id = d.id
JOIN credit_card cc ON t.credit_card_id = cc.id
JOIN company co 	ON t.company_id = co.id;

SELECT *
FROM InformeTecnico
ORDER BY id DESC;