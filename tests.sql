
-- Run after schema.sql and sample.sql:
--     psql -d ucrshsinventory -f tests.sql > test_output.txt 2>&1
-- Part 1 shows the sample data loaded into every table.
-- Part 2 tries 13 things the database must REFUSE.
 
 
\echo ===== PART 1: the sample data loaded =====
\echo Every table should have rows.
 
SELECT 'category' AS table_name, COUNT(*) AS rows FROM category
UNION ALL SELECT 'supplier',            COUNT(*) FROM supplier
UNION ALL SELECT 'role',                COUNT(*) FROM role
UNION ALL SELECT 'staff',               COUNT(*) FROM staff
UNION ALL SELECT 'medication',          COUNT(*) FROM medication
UNION ALL SELECT 'location',            COUNT(*) FROM location
UNION ALL SELECT 'purchase_order',      COUNT(*) FROM purchase_order
UNION ALL SELECT 'purchase_order_line', COUNT(*) FROM purchase_order_line
UNION ALL SELECT 'lot',                 COUNT(*) FROM lot
UNION ALL SELECT 'stock',               COUNT(*) FROM stock
UNION ALL SELECT 'par_level',           COUNT(*) FROM par_level
UNION ALL SELECT 'patient',             COUNT(*) FROM patient
UNION ALL SELECT 'prescriber',          COUNT(*) FROM prescriber
UNION ALL SELECT 'medication_order',    COUNT(*) FROM medication_order
UNION ALL SELECT 'removal',             COUNT(*) FROM removal
UNION ALL SELECT 'removal_line',        COUNT(*) FROM removal_line
UNION ALL SELECT 'transfer',            COUNT(*) FROM transfer
UNION ALL SELECT 'transfer_line',       COUNT(*) FROM transfer_line
UNION ALL SELECT 'alert',               COUNT(*) FROM alert;
 
 
\echo
\echo ===== PART 2: things the database must refuse (13 ERRORs expected) =====
 
\echo
\echo T1. Stock cannot go below zero
-- Lot 9 has only 10 tablets at location 3 (ER Cabinet). Taking 50 would leave -40.
UPDATE stock SET quantity = quantity - 50
WHERE lot_id = 9 AND location_id = 3;
 
\echo
\echo T2. Two medications cannot share an NDC code
-- 76282-333 already belongs to Warfarin (item 1).
INSERT INTO medication (ndc_code, name, unit, unit_cost, category_id)
VALUES ('76282-333', 'Warfarin copy', 'tablet', 0.40, 1);
 
\echo
\echo T3. A medication must have a name
INSERT INTO medication (name, unit, unit_cost, category_id)
VALUES (NULL, 'tablet', 0.10, 1);
 
\echo
\echo T4. A lot must be for a medication that exists
-- There is no medication 999.
INSERT INTO lot (lot_number, exp_date, quantity_received, unit_cost, item_id, po_id)
VALUES ('XX-0001', CURRENT_DATE + 100, 50, 1.00, 999, 1);
 
\echo
\echo T5. A lot must be for an item that is on its purchase order
-- Purchase order 1 never ordered item 14 (docetaxel).
INSERT INTO lot (lot_number, exp_date, quantity_received, unit_cost, item_id, po_id)
VALUES ('XX-0002', CURRENT_DATE + 100, 50, 1.00, 14, 1);
 
\echo
\echo T6. A medication still in use cannot be deleted
-- Item 1 (Warfarin) has purchase orders, lots and orders pointing at it.
DELETE FROM medication WHERE item_id = 1;
 
\echo
\echo T7. A transfer must go between two different locations
INSERT INTO transfer (restocked_at, staff_id, from_location_id, to_location_id)
VALUES (CURRENT_TIMESTAMP, 3, 1, 1);
 
\echo
\echo T8. A target level cannot be below the minimum level
INSERT INTO par_level (item_id, location_id, min_lvl, target_lvl)
VALUES (2, 4, 50, 20);
 
\echo
\echo T9. An order cannot be dispensed twice
-- Order 1 already has a dispense (removal 1).
INSERT INTO removal (removed_at, reason, staff_id, location_id, order_id)
VALUES (CURRENT_TIMESTAMP, 'dispensed', 1, 2, 1);
 
\echo
\echo T10. A dispense must be for an order
INSERT INTO removal (removed_at, reason, staff_id, location_id, order_id)
VALUES (CURRENT_TIMESTAMP, 'dispensed', 1, 2, NULL);
 
\echo
\echo T11. An order cannot be marked verified unless someone verified it
-- Order 13 is pending and has no verifier (staff_id is empty).
UPDATE medication_order SET status = 'verified' WHERE order_id = 13;
 
\echo
\echo T12. A purchase order cannot be received without a received date
-- Purchase order 6 is still pending and has no received_date.
UPDATE purchase_order SET status = 'received' WHERE po_id = 6;
 
 
\echo
\echo T13. Two rows cannot share a primary key
-- Category 1 (Cardiovascular) already exists.
INSERT INTO category (category_id, category_name) VALUES (1, 'Duplicate');
 
\echo
\echo ===== Check: nothing above changed the data =====
\echo Expect 18 medications and 10 tablets of lot 9 at the ER Cabinet.
SELECT (SELECT COUNT(*) FROM medication) AS medications,
    (SELECT quantity FROM stock WHERE lot_id = 9 AND location_id = 3) AS lot9_at_er;