CREATE DATABASE crc;
USE crc;

CREATE TABLE categories (
	cat_id INT NOT NULL AUTO_INCREMENT,
	cat_label VARCHAR(45), 
    cat_desc VARCHAR(255), 
	PRIMARY KEY (cat_id)
);

CREATE TABLE cars (
	VIN VARCHAR(7) NOT NULL, 
	car_desc VARCHAR(255), 
    color VARCHAR(45), 
    brand VARCHAR(45), 
    model VARCHAR(45), 
    cat_id INT, 
    purch_date DATE, 
	PRIMARY KEY (VIN), 
	FOREIGN KEY (cat_id) REFERENCES categories(cat_id)
);

CREATE TABLE locations (
	loc_id INT NOT NULL AUTO_INCREMENT, 
    street VARCHAR(45), 
    streetno VARCHAR(10), -- We put it Varchar to account for cases like "34A Houston street"
    city VARCHAR(45), 
    lstate VARCHAR(45), 
    lcountry VARCHAR(45), 
    PRIMARY KEY (loc_id)
);

CREATE TABLE phones (
	phone_id INT NOT NULL AUTO_INCREMENT, 
    phone_no VARCHAR(15), 
    loc_id INT NOT NULL, 
    PRIMARY KEY (phone_id), 
    FOREIGN KEY (loc_id) REFERENCES locations(loc_id)
);

CREATE TABLE customers (
	id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(45),
    last_name VARCHAR(45), 
    email VARCHAR(45),
    ssn VARCHAR(11) NOT NULL, -- We put it as Varchar(11) to accommodate a 9 digit number with 2 dashes.
    mobile VARCHAR(15), 
    state_abbrev VARCHAR(45), 
    state_name VARCHAR(45),
    country VARCHAR(45), 
    PRIMARY KEY (id)
);

CREATE TABLE reservations (
	reservation_id INT NOT NULL AUTO_INCREMENT, 
    VIN VARCHAR(7) NOT NULL, 
    cust_id INT NOT NULL, 
    amount DECIMAL(6,2), 
    p_loc INT NOT NULL, 
    p_date DATE, 
    r_loc INT NOT NULL, 
    r_date DATE, 
    PRIMARY KEY (reservation_id), 
    FOREIGN KEY (VIN) REFERENCES cars(VIN),
    FOREIGN KEY (cust_id) REFERENCES customers(id), 
    FOREIGN KEY (p_loc) REFERENCES locations(loc_id),
    FOREIGN KEY (r_loc) REFERENCES locations(loc_id)
);
