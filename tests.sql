
-- Run after schema.sql and sample.sql:
--     psql -d ucrshsinventory -f tests.sql > test_output.txt 2>&1
-- Part 1 shows the sample data loaded into every table.
-- Part 2 tries 12 things the database must REFUSE.
-- Every INSERT gives an explicit id, so each test fails only for the rule it checks.


\echo ===== PART 1: the sample data loaded =====
\echo Every table should have rows.

SELECT 'category' AS table_name, COUNT(*) AS rows FROM category
UNION ALL SELECT 'supplier',          COUNT(*) FROM supplier
UNION ALL SELECT 'role',              COUNT(*) FROM role
UNION ALL SELECT 'staff',             COUNT(*) FROM staff
UNION ALL SELECT 'item',              COUNT(*) FROM item
UNION ALL SELECT 'inventory',         COUNT(*) FROM inventory
UNION ALL SELECT 'purchaseorder',     COUNT(*) FROM purchaseorder
UNION ALL SELECT 'purchaseorderline', COUNT(*) FROM purchaseorderline
UNION ALL SELECT 'lot',               COUNT(*) FROM lot
UNION ALL SELECT 'parlevel',          COUNT(*) FROM parlevel
UNION ALL SELECT 'removal',           COUNT(*) FROM removal
UNION ALL SELECT 'removalline',       COUNT(*) FROM removalline
UNION ALL SELECT 'transfer',          COUNT(*) FROM transfer
UNION ALL SELECT 'transferline',      COUNT(*) FROM transferline;


\echo
\echo ===== PART 2: things the database must refuse (12 ERRORs expected) =====

\echo
\echo T1. Inventory quantity cannot go below zero
-- The Oncology Cabinet (location 5) holds 23 units. Taking 50 would leave -27.
UPDATE inventory SET quantity = quantity - 50
WHERE location_id = 5;

\echo
\echo T2. Two items cannot share an NDC code
-- 76282-333 already belongs to Warfarin (item 1).
INSERT INTO item (item_id, ndc_code, name, strength, unit, unit_cost, description, is_perishable, category_id, supplier_id)
VALUES (100, '76282-333', 'Warfarin copy', '6 mg', 'tablet', 0.40, 'Duplicate NDC', TRUE, 1, 1);

\echo
\echo T3. An item must have a name
INSERT INTO item (item_id, ndc_code, name, strength, unit, unit_cost, description, is_perishable, category_id, supplier_id)
VALUES (101, '99999-001', NULL, '10 mg', 'tablet', 0.10, 'No name', TRUE, 1, 1);

\echo
\echo T4. A lot must be for an item that exists
-- There is no item 999.
INSERT INTO lot (lot_id, lot_number, exp_date, quantity_received, unit_cost, item_id, po_id)
VALUES (100, 'XX-0001', CURRENT_DATE + 100, 50, 1.00, 999, 1);

\echo
\echo T5. A lot must be for an item that is on its purchase order
-- Purchase order 1 never ordered item 14 (docetaxel).
INSERT INTO lot (lot_id, lot_number, exp_date, quantity_received, unit_cost, item_id, po_id)
VALUES (101, 'XX-0002', CURRENT_DATE + 100, 50, 1.00, 14, 1);

\echo
\echo T6. An item still in use cannot be deleted
-- Item 1 (Warfarin) has purchase order lines, lots and par levels pointing at it.
DELETE FROM item WHERE item_id = 1;

\echo
\echo T7. A transfer must go to a location that exists
-- There is no location 999.
INSERT INTO transfer (restock_id, restocked_at, staff_id, location_id)
VALUES (100, CURRENT_TIMESTAMP, 3, 999);

\echo
\echo T8. A target level cannot be below the minimum level
INSERT INTO parlevel (item_id, location_id, min_lvl, target_lvl)
VALUES (2, 4, 50, 20);

\echo
\echo T9. A removal line must point to a lot that exists
-- There is no lot 999.
INSERT INTO removalline (removal_id, lot_id, quantity)
VALUES (1, 999, 5);

\echo
\echo T10. A transfer line must belong to a transfer that exists
-- There is no transfer 999.
INSERT INTO transferline (restock_id, lot_id, quantity)
VALUES (999, 1, 5);

\echo
\echo T11. A purchase order cannot be received without a received date
-- Purchase order 6 is still pending and has no received_date.
UPDATE purchaseorder SET status = 'received' WHERE po_id = 6;

\echo
\echo T12. Two rows cannot share a primary key
-- Category 1 (Cardiovascular) already exists.
INSERT INTO category (category_id, category_name) VALUES (1, 'Duplicate');

\echo
\echo ===== Check: nothing above changed the data =====
\echo Expect 18 items and 23 units at the Oncology Cabinet.
SELECT (SELECT COUNT(*) FROM item) AS items,
    (SELECT quantity FROM inventory WHERE location_id = 5) AS oncology_qty;
