
DROP TABLE IF EXISTS
    SUPPLIER, ROLE, STAFF, PURCHASEORDER, CATEGORY, ITEM, PURCHASEORDERLINE, 
    INVENTORY, LOT, TRANSFER, REMOVAL, REMOVALLINE, TRANSFERLINE, PARLEVEL
CASCADE;
CREATE TABLE SUPPLIER
(
  supplier_id INT NOT NULL,
  name INT NOT NULL,
  supplier_phone INT NOT NULL,
  supplier_email INT NOT NULL,
  PRIMARY KEY (supplier_id)
);

CREATE TABLE ROLE
(
  role_id INT NOT NULL,
  name INT NOT NULL,
  PRIMARY KEY (role_id)
);

CREATE TABLE STAFF
(
  staff_id INT NOT NULL,
  name INT NOT NULL,
  role_id INT NOT NULL,
  PRIMARY KEY (staff_id),
  FOREIGN KEY (role_id) REFERENCES ROLE(role_id)
);

CREATE TABLE PURCHASEORDER
(
  po_id INT NOT NULL,
  order_date INT NOT NULL,
  expected_date INT NOT NULL,
  received_date INT NOT NULL,
  status INT NOT NULL,
  supplier_id INT NOT NULL,
  staff_id INT NOT NULL,
  PRIMARY KEY (po_id),
  FOREIGN KEY (supplier_id) REFERENCES SUPPLIER(supplier_id),
  FOREIGN KEY (staff_id) REFERENCES STAFF(staff_id)
);

CREATE TABLE CATEGORY
(
  category_id INT NOT NULL,
  category_name INT NOT NULL,
  PRIMARY KEY (category_id)
);

CREATE TABLE ITEM
(
  item_id INT NOT NULL,
  name INT NOT NULL,
  unit INT NOT NULL,
  is_perishable INT NOT NULL,
  ndc_code INT NOT NULL,
  strength INT NOT NULL,
  unit_cost INT NOT NULL,
  description INT NOT NULL,
  category_id INT NOT NULL,
  supplier_id INT NOT NULL,
  PRIMARY KEY (item_id),
  FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id),
  FOREIGN KEY (supplier_id) REFERENCES SUPPLIER(supplier_id)
);

CREATE TABLE PURCHASEORDERLINE
(
  quantity_ordered INT NOT NULL,
  po_id INT NOT NULL,
  item_id INT NOT NULL,
  PRIMARY KEY (po_id, item_id),
  FOREIGN KEY (po_id) REFERENCES PURCHASEORDER(po_id),
  FOREIGN KEY (item_id) REFERENCES ITEM(item_id)
);

CREATE TABLE INVENTORY
(
  location_id INT NOT NULL,
  name INT NOT NULL,
  location_type INT NOT NULL,
  quantity INT NOT NULL,
  PRIMARY KEY (location_id)
);

CREATE TABLE LOT
(
  lot_id INT NOT NULL,
  lot_number INT NOT NULL,
  exp_date INT NOT NULL,
  quantity_received INT NOT NULL,
  unit_cost INT NOT NULL,
  item_id INT NOT NULL,
  po_id INT NOT NULL,
  PRIMARY KEY (lot_id),
  FOREIGN KEY (item_id) REFERENCES ITEM(item_id),
  FOREIGN KEY (po_id) REFERENCES PURCHASEORDER(po_id)
);

CREATE TABLE TRANSFER
(
  restocked_at INT NOT NULL,
  restock_id INT NOT NULL,
  staff_id INT NOT NULL,
  location_id INT NOT NULL,
  PRIMARY KEY (restock_id),
  FOREIGN KEY (staff_id) REFERENCES STAFF(staff_id),
  FOREIGN KEY (location_id) REFERENCES INVENTORY(location_id),
);

CREATE TABLE REMOVAL
(
  removal_id INT NOT NULL,
  removed_at INT NOT NULL,
  reason INT NOT NULL,
  staff_id INT NOT NULL,
  location_id INT NOT NULL,
  PRIMARY KEY (removal_id),
  FOREIGN KEY (staff_id) REFERENCES STAFF(staff_id),
  FOREIGN KEY (location_id) REFERENCES INVENTORY(location_id)
);

CREATE TABLE REMOVALLINE
(
  quantity INT NOT NULL,
  removal_id INT NOT NULL,
  lot_id INT NOT NULL,
  PRIMARY KEY (removal_id, lot_id),
  FOREIGN KEY (removal_id) REFERENCES REMOVAL(removal_id),
  FOREIGN KEY (lot_id) REFERENCES LOT(lot_id)
);

CREATE TABLE TRANSFERLINE
(
  quantity INT NOT NULL,
  restock_id INT NOT NULL,
  lot_id INT NOT NULL,
  PRIMARY KEY (restock_id, lot_id),
  FOREIGN KEY (restock_id) REFERENCES TRANSFER(restock_id),
  FOREIGN KEY (lot_id) REFERENCES LOT(lot_id)
);

CREATE TABLE PARLEVEL
(
  min_lvl INT NOT NULL,
  target_lvl INT NOT NULL,
  item_id INT NOT NULL,
  location_id INT NOT NULL,
  PRIMARY KEY (item_id, location_id),
  FOREIGN KEY (item_id) REFERENCES ITEM(item_id),
  FOREIGN KEY (location_id) REFERENCES INVENTORY(location_id)
);