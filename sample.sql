
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
INSERT INTO item (item_id, ndc_code, name, strength, unit, unit_cost, description, category_id, is_perishable, supplier_id) VALUES
    ( 1, '76282-333',  'Warfarin Sodium',                    '6 mg',            'tablet',  0.42, 'Tablet. Labeler: Exelan Pharmaceuticals Inc.', 1, TRUE, 1),
    ( 2, '78206-121',  'Losartan Potassium',                 '25 mg',           'tablet',  1.85, 'Film-coated tablet (Cozaar). Labeler: Organon LLC', 1, TRUE, 2),
    ( 3, '0615-7959',  'Losartan Potassium',                 '50 mg',           'tablet',  0.18, 'Film-coated tablet. Labeler: NCS HealthCare of KY, LLC dba Vangard Labs', 1, TRUE, 1),
    ( 4, '76420-325',  'Meloxicam',                          '7.5 mg',          'tablet',  0.12, 'Tablet. Labeler: Asclemed USA, Inc.', 2, TRUE, 1),
    ( 5, '82461-711',  'Naproxen',                           '500 mg',          'tablet',  0.15, 'Tablet. Labeler: Medcore LLC', 2, TRUE, 1),
    ( 6, '80425-0501', 'Tramadol Hydrochloride',             '50 mg',           'tablet',  0.22, 'Coated tablet. DEA schedule CIV. Labeler: Advanced Rx of Tennessee, LLC', 2, TRUE, 2),
    ( 7, '76385-178',  'Pioglitazone Hydrochloride',         '15 mg',           'tablet',  0.35, 'Tablet. Labeler: Unichem Pharmaceuticals (USA), Inc.', 3, TRUE, 2),
    ( 8, '0603-5339',  'Prednisone',                         '20 mg',           'tablet',  0.14, 'Tablet. Labeler: Par Health USA, LLC', 3, TRUE, 1),
    ( 9, '83059-0005', 'Famotidine',                         '10 mg',           'tablet',  0.09, 'Film-coated tablet. Labeler: Shield Pharmaceuticals Corp', 4, TRUE, 1),
    (10, '80425-0246', 'Mupirocin',                          '20 mg/g',         'tube',    6.50, 'Ointment. Labeler: Advanced Rx Pharmacy of Tennessee, LLC', 5, TRUE, 2),
    (11, '80725-250',  'Paromomycin Sulfate',                '250 mg',          'capsule', 4.10, 'Capsule (Humatin). Labeler: Waylis Therapeutics LLC', 5, TRUE, 3),
    (12, '82009-109',  'Emtricitabine / Tenofovir Disoproxil Fumarate', '200 mg / 300 mg', 'tablet', 2.75, 'Film-coated tablet. Labeler: Quallent Pharmaceuticals Health LLC', 5, TRUE, 2),
    (13, '0703-4239',  'Carboplatin',                        '10 mg/mL',        'vial',   18.00, 'Injection, solution. Labeler: Teva Parenteral Medicines, Inc.', 6, TRUE, 2),
    (14, '83831-102',  'Docetaxel',                          '80 mg/8 mL',      'vial',  240.00, 'Injection, solution (Docivyx). Labeler: Avyxa Pharma, LLC', 6, TRUE, 2),
    (15, '76420-724',  'Buspirone Hydrochloride',            '15 mg',           'tablet',  0.11, 'Tablet. Labeler: Asclemed USA, Inc.', 7, TRUE, 1),
    (16, '0713-0226',  'Triamcinolone Acetonide',            '0.25 mg/g',       'tube',    5.20, 'Cream. Labeler: Cosette Pharmaceuticals, Inc.', 8, TRUE, 3);

-- Non-drug supplies
INSERT INTO item (item_id, ndc_code, name, strength, unit, unit_cost, description, is_perishable, category_id, supplier_id) VALUES
    (17, NULL, 'Nitrile Exam Gloves, Medium', NULL, 'box',  8.75, 'Box of 100',     FALSE, 9, 3),
    (18, NULL, 'Sterile Gauze Pads 4x4 in',   NULL, 'pack', 3.40, 'Pack of 25',     FALSE, 9, 3);


INSERT INTO inventory (location_id, name, location_type, quantity) VALUES
    (1, 'Central Pharmacy',  'central',      3402),
    (2, 'ICU Cabinet',       'unit_cabinet',  240),
    (3, 'ER Cabinet',        'unit_cabinet',  180),
    (4, 'Med-Surg Cabinet',  'unit_cabinet',  340),
    (5, 'Oncology Cabinet',  'unit_cabinet',   23);

-- Purchasing
INSERT INTO purchaseorder (po_id, order_date, expected_date, received_date, status, supplier_id, staff_id) VALUES
    (1, CURRENT_DATE - 120, CURRENT_DATE - 113, CURRENT_DATE - 114, 'received',  1, 5),   -- a day early
    (2, CURRENT_DATE -  60, CURRENT_DATE -  53, CURRENT_DATE -  53, 'received',  1, 5),   -- on time
    (3, CURRENT_DATE -  90, CURRENT_DATE -  83, CURRENT_DATE -  78, 'received',  2, 5),   -- 5 days LATE
    (4, CURRENT_DATE -  30, CURRENT_DATE -  23, CURRENT_DATE -  25, 'received',  2, 3),   -- early
    (5, CURRENT_DATE -  45, CURRENT_DATE -  38, CURRENT_DATE -  38, 'received',  3, 5),   -- on time
    (6, CURRENT_DATE -   5, CURRENT_DATE +   2, NULL,               'pending',   3, 5),   -- not here yet
    (7, CURRENT_DATE -  20, CURRENT_DATE -  13, NULL,               'cancelled', 1, 3);

INSERT INTO purchaseorderline (po_id, item_id, quantity_ordered) VALUES
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


-- Transfers from the central pharmacy; location_id is the receiving unit cabinet


INSERT INTO transfer (restock_id, restocked_at, staff_id, location_id) VALUES
    (1, (CURRENT_DATE - 110) + TIME '08:30', 3, 2),
    (2, (CURRENT_DATE - 108) + TIME '09:10', 4, 4),
    (3, (CURRENT_DATE -  55) + TIME '10:00', 3, 3),
    (4, (CURRENT_DATE -  50) + TIME '08:45', 4, 2),
    (5, (CURRENT_DATE -  70) + TIME '13:20', 3, 5),
    (6, (CURRENT_DATE -  25) + TIME '11:05', 4, 5),
    (7, (CURRENT_DATE -  28) + TIME '14:40', 3, 4),
    (8, (CURRENT_DATE -  40) + TIME '09:55', 4, 3);

INSERT INTO transferline (restock_id, lot_id, quantity) VALUES
    (1,  1, 100), (1,  2,  20), (1,  3,  80), (1,  4,  60),
    (2,  2, 200), (2,  3, 100), (2,  4, 100),
    (3,  6,  80), (3,  7, 100),
    (4,  5,  50), (4,  9,  40),
    (5, 12,  20),
    (6, 15,   6),
    (7, 10,  60), (7, 13,  50),
    (8,  9,  30), (8, 11,  10);


-- Removals: dispenses (1-11), expired disposal (12), damage (13)


INSERT INTO removal (removal_id, removed_at, reason, staff_id, location_id) VALUES
    ( 1, (CURRENT_DATE - 20) + TIME '08:40', 'dispensed', 1, 2),
    ( 2, (CURRENT_DATE - 18) + TIME '10:05', 'dispensed', 1, 2),
    ( 3, (CURRENT_DATE - 15) + TIME '10:50', 'dispensed', 2, 4),
    ( 4, (CURRENT_DATE - 12) + TIME '13:25', 'dispensed', 2, 4),
    ( 5, (CURRENT_DATE -  9) + TIME '21:55', 'dispensed', 1, 3),
    ( 6, (CURRENT_DATE -  7) + TIME '08:20', 'dispensed', 2, 5),
    ( 7, (CURRENT_DATE -  6) + TIME '11:45', 'dispensed', 1, 4),
    ( 8, (CURRENT_DATE -  5) + TIME '16:10', 'dispensed', 2, 3),
    ( 9, (CURRENT_DATE -  3) + TIME '08:50', 'dispensed', 1, 2),
    (10, (CURRENT_DATE -  2) + TIME '09:30', 'dispensed', 2, 5),
    (11, (CURRENT_DATE - 45) + TIME '11:00', 'dispensed', 1, 2),
    (12, (CURRENT_DATE -  8) + TIME '14:15', 'expired',   3, 4),
    (13, (CURRENT_DATE - 30) + TIME '15:35', 'damaged',   4, 1);

INSERT INTO removalline (removal_id, lot_id, quantity) VALUES
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


INSERT INTO parlevel (item_id, location_id, min_lvl, target_lvl) VALUES
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


COMMIT;