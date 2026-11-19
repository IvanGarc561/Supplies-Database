
BEGIN;

INSERT INTO category (category_id, category_name) VALUES
    (1, 'Cardiovascular'),
    (2, 'Analgesic / Anti-inflammatory'),
    (3, 'Endocrine'),
    (4, 'Gastrointestinal'),
    (5, 'Anti-infective'),
    (6, 'Oncology'),
    (7, 'Psychiatric'),
    (8, 'Dermatologic'),
    (9, 'Medical Supplies');

INSERT INTO supplier (supplier_id, name, supplier_phone, supplier_email) VALUES
    (1, 'Westbrook Medical Supply',     '951-555-0142', 'orders@westbrookmed.example'),
    (2, 'Pacific Pharma Distributors',  '213-555-0177', 'sales@pacificpharma.example'),
    (3, 'Inland Health Wholesale',      '909-555-0119', 'desk@inlandhealth.example'),
    (4, 'Summit Rx Supply',             '619-555-0163', NULL);    

INSERT INTO role (role_id, name) VALUES
    (1, 'pharmacist'),
    (2, 'technician'),
    (3, 'manager');

INSERT INTO staff (staff_id, name, role_id) VALUES
    (1, 'Priya Raman',    1),
    (2, 'Daniel Okafor',  1),
    (3, 'Mei Tanaka',     2),
    (4, 'Carlos Rivera',  2),
    (5, 'Helen Brooks',   3);

-- NDC code, name, strength and form are from the FDA NDC Directory. unit_cost is synthetic.
INSERT INTO medication (item_id, ndc_code, name, strength, unit, unit_cost, description, category_id) VALUES
    ( 1, '76282-333',  'Warfarin Sodium',                    '6 mg',            'tablet',  0.42, 'Tablet. Labeler: Exelan Pharmaceuticals Inc.', 1),
    ( 2, '78206-121',  'Losartan Potassium',                 '25 mg',           'tablet',  1.85, 'Film-coated tablet (Cozaar). Labeler: Organon LLC', 1),
    ( 3, '0615-7959',  'Losartan Potassium',                 '50 mg',           'tablet',  0.18, 'Film-coated tablet. Labeler: NCS HealthCare of KY, LLC dba Vangard Labs', 1),
    ( 4, '76420-325',  'Meloxicam',                          '7.5 mg',          'tablet',  0.12, 'Tablet. Labeler: Asclemed USA, Inc.', 2),
    ( 5, '82461-711',  'Naproxen',                           '500 mg',          'tablet',  0.15, 'Tablet. Labeler: Medcore LLC', 2),
    ( 6, '80425-0501', 'Tramadol Hydrochloride',             '50 mg',           'tablet',  0.22, 'Coated tablet. DEA schedule CIV. Labeler: Advanced Rx of Tennessee, LLC', 2),
    ( 7, '76385-178',  'Pioglitazone Hydrochloride',         '15 mg',           'tablet',  0.35, 'Tablet. Labeler: Unichem Pharmaceuticals (USA), Inc.', 3),
    ( 8, '0603-5339',  'Prednisone',                         '20 mg',           'tablet',  0.14, 'Tablet. Labeler: Par Health USA, LLC', 3),
    ( 9, '83059-0005', 'Famotidine',                         '10 mg',           'tablet',  0.09, 'Film-coated tablet. Labeler: Shield Pharmaceuticals Corp', 4),
    (10, '80425-0246', 'Mupirocin',                          '20 mg/g',         'tube',    6.50, 'Ointment. Labeler: Advanced Rx Pharmacy of Tennessee, LLC', 5),
    (11, '80725-250',  'Paromomycin Sulfate',                '250 mg',          'capsule', 4.10, 'Capsule (Humatin). Labeler: Waylis Therapeutics LLC', 5),
    (12, '82009-109',  'Emtricitabine / Tenofovir Disoproxil Fumarate', '200 mg / 300 mg', 'tablet', 2.75, 'Film-coated tablet. Labeler: Quallent Pharmaceuticals Health LLC', 5),
    (13, '0703-4239',  'Carboplatin',                        '10 mg/mL',        'vial',   18.00, 'Injection, solution. Labeler: Teva Parenteral Medicines, Inc.', 6),
    (14, '83831-102',  'Docetaxel',                          '80 mg/8 mL',      'vial',  240.00, 'Injection, solution (Docivyx). Labeler: Avyxa Pharma, LLC', 6),
    (15, '76420-724',  'Buspirone Hydrochloride',            '15 mg',           'tablet',  0.11, 'Tablet. Labeler: Asclemed USA, Inc.', 7),
    (16, '0713-0226',  'Triamcinolone Acetonide',            '0.25 mg/g',       'tube',    5.20, 'Cream. Labeler: Cosette Pharmaceuticals, Inc.', 8);

-- Non-drug supplies
INSERT INTO medication (item_id, ndc_code, name, strength, unit, unit_cost, description, is_perishable, category_id) VALUES
    (17, NULL, 'Nitrile Exam Gloves, Medium', NULL, 'box',  8.75, 'Box of 100',     FALSE, 9),
    (18, NULL, 'Sterile Gauze Pads 4x4 in',   NULL, 'pack', 3.40, 'Pack of 25',     FALSE, 9);

-- Preferred supplier for reordering 
UPDATE medication SET supplier_id = 1 WHERE item_id IN (1, 3, 8, 9);
UPDATE medication SET supplier_id = 2 WHERE item_id IN (2, 6, 7, 10, 12, 13, 14);
UPDATE medication SET supplier_id = 3 WHERE item_id IN (11, 16, 17, 18);

INSERT INTO location (location_id, name, location_type) VALUES
    (1, 'Central Pharmacy',  'central'),
    (2, 'ICU Cabinet',       'unit_cabinet'),
    (3, 'ER Cabinet',        'unit_cabinet'),
    (4, 'Med-Surg Cabinet',  'unit_cabinet'),
    (5, 'Oncology Cabinet',  'unit_cabinet');

-- Purchasing
INSERT INTO purchase_order (po_id, order_date, expected_date, received_date, status, supplier_id, staff_id) VALUES
    (1, CURRENT_DATE - 120, CURRENT_DATE - 113, CURRENT_DATE - 114, 'received',  1, 5),   -- a day early
    (2, CURRENT_DATE -  60, CURRENT_DATE -  53, CURRENT_DATE -  53, 'received',  1, 5),   -- on time
    (3, CURRENT_DATE -  90, CURRENT_DATE -  83, CURRENT_DATE -  78, 'received',  2, 5),   -- 5 days LATE
    (4, CURRENT_DATE -  30, CURRENT_DATE -  23, CURRENT_DATE -  25, 'received',  2, 3),   -- early
    (5, CURRENT_DATE -  45, CURRENT_DATE -  38, CURRENT_DATE -  38, 'received',  3, 5),   -- on time
    (6, CURRENT_DATE -   5, CURRENT_DATE +   2, NULL,               'pending',   3, 5),   -- not here yet
    (7, CURRENT_DATE -  20, CURRENT_DATE -  13, NULL,               'cancelled', 1, 3);

INSERT INTO purchase_order_line (po_id, item_id, quantity_ordered) VALUES
    (1,  1, 500), (1,  3, 600), (1,  8, 400), (1,  9, 300),
    (2,  3, 400), (2,  4, 300), (2,  5, 300), (2, 15, 200),
    (3,  6, 200), (3,  7, 200), (3, 10,  40), (3, 13,  30),
    (4,  2, 200), (4,  7, 200), (4, 12, 120), (4, 14,  10),
    (5,  1, 300), (5, 11,  60), (5, 16,  50), (5, 17,  40), (5, 18,  60),
    (6,  5, 200), (6,  9, 300),
    (7,  6, 100);

INSERT INTO lot (lot_id, lot_number, exp_date, quantity_received, unit_cost, item_id, po_id) VALUES
    ( 1, 'WF-2411A', CURRENT_DATE + 200, 500,   0.40,  1, 1),
    ( 2, 'LS-5501',  CURRENT_DATE +  25, 600,   0.17,  3, 1),   -- expires within 30 days
    ( 3, 'PR-8830',  CURRENT_DATE + 300, 400,   0.13,  8, 1),
    ( 4, 'FM-1022',  CURRENT_DATE + 400, 300,   0.08,  9, 1),
    ( 5, 'LS-5617',  CURRENT_DATE + 320, 400,   0.18,  3, 2),
    ( 6, 'MX-3090',  CURRENT_DATE + 250, 300,   0.11,  4, 2),
    ( 7, 'NP-7745',  CURRENT_DATE + 280, 300,   0.14,  5, 2),
    ( 8, 'BU-2206',  CURRENT_DATE + 340, 200,   0.10, 15, 2),   -- never used
    ( 9, 'TR-6614',  CURRENT_DATE + 180, 200,   0.21,  6, 3),
    (10, 'PG-4402',  CURRENT_DATE -  10, 200,   0.33,  7, 3),   -- EXPIRED
    (11, 'MU-0915',  CURRENT_DATE + 150,  40,   6.20, 10, 3),
    (12, 'CB-7781',  CURRENT_DATE +  90,  30,  17.50, 13, 3),
    (13, 'CZ-1183',  CURRENT_DATE + 365, 200,   1.80,  2, 4),
    (14, 'ET-5540',  CURRENT_DATE + 270, 120,   2.70, 12, 4),   -- never used
    (15, 'DX-9002',  CURRENT_DATE +  15,  10, 235.00, 14, 4),   -- expires within 30 days
    (16, 'PG-4519',  CURRENT_DATE + 330, 200,   0.34,  7, 4),   -- never used
    (17, 'HM-3307',  CURRENT_DATE + 210,  60,   4.00, 11, 5),   -- never used
    (18, 'TA-6120',  CURRENT_DATE + 190,  50,   5.00, 16, 5),   -- never used
    (19, 'WF-2502B', CURRENT_DATE + 400, 300,   0.41,  1, 5),   -- never used
    (20, 'GL-0447',  NULL,                40,   8.50, 17, 5),   -- gloves: no expiration date, never used
    (21, 'GZ-1290',  NULL,                60,   3.25, 18, 5);   -- gauze: no expiration date, never used


-- Transfers (central pharmacy -> unit cabinets)


INSERT INTO transfer (restock_id, restocked_at, staff_id, from_location_id, to_location_id) VALUES
    (1, (CURRENT_DATE - 110) + TIME '08:30', 3, 1, 2),
    (2, (CURRENT_DATE - 108) + TIME '09:10', 4, 1, 4),
    (3, (CURRENT_DATE -  55) + TIME '10:00', 3, 1, 3),
    (4, (CURRENT_DATE -  50) + TIME '08:45', 4, 1, 2),
    (5, (CURRENT_DATE -  70) + TIME '13:20', 3, 1, 5),
    (6, (CURRENT_DATE -  25) + TIME '11:05', 4, 1, 5),
    (7, (CURRENT_DATE -  28) + TIME '14:40', 3, 1, 4),
    (8, (CURRENT_DATE -  40) + TIME '09:55', 4, 1, 3);

INSERT INTO transfer_line (restock_id, lot_id, quantity) VALUES
    (1,  1, 100), (1,  2,  20), (1,  3,  80), (1,  4,  60),
    (2,  2, 200), (2,  3, 100), (2,  4, 100),
    (3,  6,  80), (3,  7, 100),
    (4,  5,  50), (4,  9,  40),
    (5, 12,  20),
    (6, 15,   6),
    (7, 10,  60), (7, 13,  50),
    (8,  9,  30), (8, 11,  10);

-- Patients, prescribers and medication orders

INSERT INTO patient (patient_id, first_name, last_name, date_of_birth) VALUES
    (1, 'Arthur',  'Bennett',   DATE '1948-03-14'),
    (2, 'Lucia',   'Fernandez', DATE '1962-11-02'),
    (3, 'Samuel',  'Osei',      DATE '1975-07-21'),
    (4, 'Grace',   'Whitfield', DATE '1990-01-30'),
    (5, 'Hiroshi', 'Nakamura',  DATE '1956-09-08'),
    (6, 'Amara',   'Diallo',    DATE '1983-05-17'),
    (7, 'Thomas',  'Kowalski',  DATE '1969-12-25'),
    (8, 'Elena',   'Petrova',   DATE '1941-06-03');

INSERT INTO prescriber (prescriber_id, name, license_no, department) VALUES
    (1, 'Dr. Anita Patel',     'CA-A104523', 'Internal Medicine'),
    (2, 'Dr. Marcus Lee',      'CA-G088217', 'Critical Care'),
    (3, 'Dr. Sofia Alvarez',   'CA-A119045', 'Emergency Medicine'),
    (4, 'Dr. Jonathan Reyes',  'CA-C067331', 'Oncology');

INSERT INTO medication_order (order_id, quantity, status, ordered_at, patient_id, prescriber_id, item_id, location_id, staff_id) VALUES
    ( 1, 30, 'dispensed', (CURRENT_DATE - 20) + TIME '08:05', 1, 1,  3, 2, 1),
    ( 2, 30, 'dispensed', (CURRENT_DATE - 18) + TIME '09:40', 2, 2,  1, 2, 1),
    ( 3, 20, 'dispensed', (CURRENT_DATE - 15) + TIME '10:15', 3, 1,  8, 4, 2),
    ( 4, 30, 'dispensed', (CURRENT_DATE - 12) + TIME '13:00', 4, 3,  9, 4, 2),
    ( 5, 20, 'dispensed', (CURRENT_DATE -  9) + TIME '21:30', 5, 3,  6, 3, 1),
    ( 6,  2, 'dispensed', (CURRENT_DATE -  7) + TIME '07:50', 1, 4, 13, 5, 2),
    ( 7, 60, 'dispensed', (CURRENT_DATE -  6) + TIME '11:20', 6, 1,  3, 4, 1),
    ( 8, 20, 'dispensed', (CURRENT_DATE -  5) + TIME '15:45', 7, 3,  5, 3, 2),
    ( 9, 20, 'dispensed', (CURRENT_DATE -  3) + TIME '08:25', 2, 2,  9, 2, 1),
    (10,  1, 'dispensed', (CURRENT_DATE -  2) + TIME '09:00', 8, 4, 14, 5, 2),
    (11, 30, 'dispensed', (CURRENT_DATE - 45) + TIME '10:30', 3, 2,  1, 2, 1),   -- older than 30 days
    (12, 14, 'verified',  (CURRENT_DATE -  1) + TIME '16:10', 4, 3,  4, 3, 2),   -- ready to dispense
    (13, 10, 'pending',    CURRENT_DATE       + TIME '07:15', 5, 2,  6, 2, NULL),
    (14, 30, 'cancelled', (CURRENT_DATE -  8) + TIME '12:00', 6, 1,  7, 4, NULL),
    (15, 30, 'verified',  (CURRENT_DATE -  1) + TIME '17:30', 7, 1,  3, 4, 1);   -- ready to dispense


-- Removals: dispenses (1-11), expired disposal (12), damage (13)


INSERT INTO removal (removal_id, removed_at, reason, staff_id, location_id, order_id) VALUES
    ( 1, (CURRENT_DATE - 20) + TIME '08:40', 'dispensed', 1, 2,  1),
    ( 2, (CURRENT_DATE - 18) + TIME '10:05', 'dispensed', 1, 2,  2),
    ( 3, (CURRENT_DATE - 15) + TIME '10:50', 'dispensed', 2, 4,  3),
    ( 4, (CURRENT_DATE - 12) + TIME '13:25', 'dispensed', 2, 4,  4),
    ( 5, (CURRENT_DATE -  9) + TIME '21:55', 'dispensed', 1, 3,  5),
    ( 6, (CURRENT_DATE -  7) + TIME '08:20', 'dispensed', 2, 5,  6),
    ( 7, (CURRENT_DATE -  6) + TIME '11:45', 'dispensed', 1, 4,  7),
    ( 8, (CURRENT_DATE -  5) + TIME '16:10', 'dispensed', 2, 3,  8),
    ( 9, (CURRENT_DATE -  3) + TIME '08:50', 'dispensed', 1, 2,  9),
    (10, (CURRENT_DATE -  2) + TIME '09:30', 'dispensed', 2, 5, 10),
    (11, (CURRENT_DATE - 45) + TIME '11:00', 'dispensed', 1, 2, 11),
    (12, (CURRENT_DATE -  8) + TIME '14:15', 'expired',   3, 4, NULL),
    (13, (CURRENT_DATE - 30) + TIME '15:35', 'damaged',   4, 1, NULL);

INSERT INTO removal_line (removal_id, lot_id, quantity) VALUES
    ( 1,  2, 20), ( 1,  5, 10),      -- one order split across two lots, earliest expiration first
    ( 2,  1, 30),
    ( 3,  3, 20),
    ( 4,  4, 30),
    ( 5,  9, 20),
    ( 6, 12,  2),
    ( 7,  2, 60),
    ( 8,  7, 20),
    ( 9,  4, 20),
    (10, 15,  1),
    (11,  1, 30),
    (12, 10, 60),                    -- expired pioglitazone pulled from Med-Surg
    (13, 11,  2);                    -- two damaged tubes

-- Stock on hand (after every transfer and removal above)

INSERT INTO stock (lot_id, location_id, quantity) VALUES
    ( 1, 1, 400), ( 1, 2,  40),
    ( 2, 1, 380), ( 2, 2,   0), ( 2, 4, 140),
    ( 3, 1, 220), ( 3, 2,  80), ( 3, 4,  80),
    ( 4, 1, 140), ( 4, 2,  40), ( 4, 4,  70),
    ( 5, 1, 350), ( 5, 2,  40),
    ( 6, 1, 220), ( 6, 3,  80),
    ( 7, 1, 200), ( 7, 3,  80),
    ( 8, 1, 200),
    ( 9, 1, 130), ( 9, 2,  40), ( 9, 3,  10),
    (10, 1, 140), (10, 4,   0),      -- 140 expired units still on the central shelf
    (11, 1,  28), (11, 3,  10),
    (12, 1,  10), (12, 5,  18),
    (13, 1, 150), (13, 4,  50),
    (14, 1, 120),
    (15, 1,   4), (15, 5,   5),
    (16, 1, 200),
    (17, 1,  60),
    (18, 1,  50),
    (19, 1, 300),
    (20, 1,  40),
    (21, 1,  60);

INSERT INTO par_level (item_id, location_id, min_lvl, target_lvl) VALUES
    ( 1, 1, 200, 800),
    ( 3, 1, 300, 800),
    ( 1, 2,  30, 100),
    ( 3, 2,  60, 120),      -- BELOW MIN: 40 unexpired tablets at ICU
    ( 9, 2,  30, 100),
    ( 4, 3,  40, 100),
    ( 5, 3,  50, 120),
    ( 6, 3,  20,  60),      -- BELOW MIN: 10 tablets at ER
    ( 7, 4,  30,  90),      -- BELOW MIN: 0 unexpired tablets at Med-Surg
    ( 8, 4,  40, 120),
    (13, 5,  10,  25),
    (14, 5,   4,   8);


-- Alerts


INSERT INTO alert (alert_id, alert_type, created_at, status, location_id, item_id, lot_id, acknowledged_by) VALUES
    (1, 'low_stock', (CURRENT_DATE -  1) + TIME '06:00', 'open',         2,    3, NULL, NULL),
    (2, 'low_stock', (CURRENT_DATE -  4) + TIME '06:00', 'acknowledged', 3,    6, NULL, 5),
    (3, 'expiring',  (CURRENT_DATE -  2) + TIME '06:00', 'open',         5, NULL,   15, NULL),
    (4, 'expiring',  (CURRENT_DATE -  5) + TIME '06:00', 'acknowledged', 4, NULL,    2, 2),
    (5, 'expiring',  (CURRENT_DATE - 20) + TIME '06:00', 'open',         1, NULL,   10, NULL);


-- The rows above use explicit ids, so move each SERIAL counter past them.
-- Without this, the next INSERT from the application would collide on id 1.


SELECT setval(pg_get_serial_sequence('category',         'category_id'),   (SELECT MAX(category_id)   FROM category));
SELECT setval(pg_get_serial_sequence('supplier',         'supplier_id'),   (SELECT MAX(supplier_id)   FROM supplier));
SELECT setval(pg_get_serial_sequence('role',             'role_id'),       (SELECT MAX(role_id)       FROM role));
SELECT setval(pg_get_serial_sequence('staff',            'staff_id'),      (SELECT MAX(staff_id)      FROM staff));
SELECT setval(pg_get_serial_sequence('medication',       'item_id'), (SELECT MAX(item_id) FROM medication));
SELECT setval(pg_get_serial_sequence('location',         'location_id'),   (SELECT MAX(location_id)   FROM location));
SELECT setval(pg_get_serial_sequence('purchase_order',   'po_id'),         (SELECT MAX(po_id)         FROM purchase_order));
SELECT setval(pg_get_serial_sequence('lot',              'lot_id'),        (SELECT MAX(lot_id)        FROM lot));
SELECT setval(pg_get_serial_sequence('patient',          'patient_id'),    (SELECT MAX(patient_id)    FROM patient));
SELECT setval(pg_get_serial_sequence('prescriber',       'prescriber_id'), (SELECT MAX(prescriber_id) FROM prescriber));
SELECT setval(pg_get_serial_sequence('medication_order', 'order_id'),      (SELECT MAX(order_id)      FROM medication_order));
SELECT setval(pg_get_serial_sequence('removal',          'removal_id'),    (SELECT MAX(removal_id)    FROM removal));
SELECT setval(pg_get_serial_sequence('transfer',         'restock_id'),   (SELECT MAX(restock_id)   FROM transfer));
SELECT setval(pg_get_serial_sequence('alert',            'alert_id'),      (SELECT MAX(alert_id)      FROM alert));

COMMIT;