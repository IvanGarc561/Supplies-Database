
DROP TABLE IF EXISTS
    alert, transfer_line, transfer, removal_line, removal,
    medication_order, prescriber, patient, par_level, stock, lot,
    purchase_order_line, purchase_order, location, medication,
    staff, role, supplier, category
CASCADE;

CREATE TABLE category (
    category_id    SERIAL       PRIMARY KEY,
    category_name  VARCHAR(50)  NOT NULL UNIQUE
);

CREATE TABLE supplier (
    supplier_id     SERIAL        PRIMARY KEY,
    name            VARCHAR(100)  NOT NULL UNIQUE,
    supplier_phone  VARCHAR(20),
    supplier_email  VARCHAR(100)
);

CREATE TABLE role (
    role_id  SERIAL       PRIMARY KEY,
    name     VARCHAR(50)  NOT NULL UNIQUE
);

CREATE TABLE staff (
    staff_id  SERIAL        PRIMARY KEY,
    name      VARCHAR(100)  NOT NULL,
    role_id   INT           NOT NULL REFERENCES role (role_id) ON DELETE RESTRICT
);

CREATE TABLE medication (
    item_id        SERIAL         PRIMARY KEY,
    ndc_code       VARCHAR(13)    UNIQUE,
    name           VARCHAR(100)   NOT NULL,
    strength       VARCHAR(50),
    unit           VARCHAR(20)    NOT NULL,
    unit_cost      NUMERIC(10,2)  NOT NULL CHECK (unit_cost >= 0),
    description    TEXT,
    is_perishable  BOOLEAN        NOT NULL DEFAULT TRUE,
    category_id    INT            NOT NULL REFERENCES category (category_id) ON DELETE RESTRICT,
    supplier_id    INT                     REFERENCES supplier (supplier_id) ON DELETE RESTRICT
);

CREATE TABLE location (
    location_id    SERIAL        PRIMARY KEY,
    name           VARCHAR(100)  NOT NULL UNIQUE,
    location_type  VARCHAR(30)   NOT NULL CHECK (location_type IN ('central', 'unit_cabinet'))
);

CREATE TABLE purchase_order (
    po_id          SERIAL       PRIMARY KEY,
    order_date     DATE         NOT NULL,
    expected_date  DATE         NOT NULL,
    received_date  DATE,
    status         VARCHAR(20)  NOT NULL CHECK (status IN ('pending', 'received', 'cancelled')),
    supplier_id    INT          NOT NULL REFERENCES supplier (supplier_id) ON DELETE RESTRICT,
    staff_id       INT          NOT NULL REFERENCES staff (staff_id)       ON DELETE RESTRICT,
    CONSTRAINT po_expected_after_order  CHECK (expected_date >= order_date),
    CONSTRAINT po_received_after_order  CHECK (received_date >= order_date),
    CONSTRAINT po_received_iff_date     CHECK ((status = 'received') = (received_date IS NOT NULL))
);

CREATE TABLE purchase_order_line (
    po_id             INT  NOT NULL REFERENCES purchase_order (po_id) ON DELETE CASCADE,
    item_id           INT  NOT NULL REFERENCES medication (item_id)   ON DELETE RESTRICT,
    quantity_ordered  INT  NOT NULL CHECK (quantity_ordered > 0),
    PRIMARY KEY (po_id, item_id)
);

CREATE TABLE lot (
    lot_id             SERIAL         PRIMARY KEY,
    lot_number         VARCHAR(50)    NOT NULL,
    exp_date           DATE,
    quantity_received  INT            NOT NULL CHECK (quantity_received > 0),
    unit_cost          NUMERIC(10,2)  NOT NULL CHECK (unit_cost >= 0),
    item_id            INT            NOT NULL REFERENCES medication (item_id)   ON DELETE RESTRICT,
    po_id              INT            NOT NULL REFERENCES purchase_order (po_id) ON DELETE RESTRICT,
    CONSTRAINT lot_number_unique_per_medication UNIQUE (item_id, lot_number),
    CONSTRAINT lot_matches_po_line FOREIGN KEY (po_id, item_id)
        REFERENCES purchase_order_line (po_id, item_id) ON DELETE RESTRICT
);

CREATE TABLE stock (
    lot_id       INT  NOT NULL REFERENCES lot (lot_id)           ON DELETE RESTRICT,
    location_id  INT  NOT NULL REFERENCES location (location_id) ON DELETE RESTRICT,
    quantity     INT  NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (lot_id, location_id)
);

CREATE TABLE par_level (
    item_id      INT  NOT NULL REFERENCES medication (item_id)   ON DELETE RESTRICT,
    location_id  INT  NOT NULL REFERENCES location (location_id) ON DELETE RESTRICT,
    min_lvl      INT  NOT NULL CHECK (min_lvl >= 0),
    target_lvl   INT  NOT NULL,
    PRIMARY KEY (item_id, location_id),
    CONSTRAINT par_target_at_least_min CHECK (target_lvl >= min_lvl)
);

CREATE TABLE patient (
    patient_id     SERIAL       PRIMARY KEY,
    first_name     VARCHAR(50)  NOT NULL,
    last_name      VARCHAR(50)  NOT NULL,
    date_of_birth  DATE         NOT NULL
);

CREATE TABLE prescriber (
    prescriber_id  SERIAL        PRIMARY KEY,
    name           VARCHAR(100)  NOT NULL,
    license_no     VARCHAR(20)   NOT NULL UNIQUE,
    department     VARCHAR(50)
);

CREATE TABLE medication_order (
    order_id       SERIAL       PRIMARY KEY,
    quantity       INT          NOT NULL CHECK (quantity > 0),
    status         VARCHAR(20)  NOT NULL CHECK (status IN ('pending', 'verified', 'dispensed', 'cancelled')),
    ordered_at     TIMESTAMP    NOT NULL,
    patient_id     INT          NOT NULL REFERENCES patient (patient_id)       ON DELETE RESTRICT,
    prescriber_id  INT          NOT NULL REFERENCES prescriber (prescriber_id) ON DELETE RESTRICT,
    item_id        INT          NOT NULL REFERENCES medication (item_id)       ON DELETE RESTRICT,
    location_id    INT          NOT NULL REFERENCES location (location_id)     ON DELETE RESTRICT,
    staff_id       INT                   REFERENCES staff (staff_id)           ON DELETE RESTRICT,
    CONSTRAINT order_verified_has_verifier CHECK (status IN ('pending', 'cancelled') OR staff_id IS NOT NULL)
);

CREATE TABLE removal (
    removal_id   SERIAL       PRIMARY KEY,
    removed_at   TIMESTAMP    NOT NULL,
    reason       VARCHAR(20)  NOT NULL CHECK (reason IN ('dispensed', 'expired', 'damaged')),
    staff_id     INT          NOT NULL REFERENCES staff (staff_id)       ON DELETE RESTRICT,
    location_id  INT          NOT NULL REFERENCES location (location_id) ON DELETE RESTRICT,
    order_id     INT          UNIQUE   REFERENCES medication_order (order_id) ON DELETE RESTRICT,
    CONSTRAINT removal_dispense_has_order CHECK ((reason = 'dispensed') = (order_id IS NOT NULL))
);

CREATE TABLE removal_line (
    removal_id  INT  NOT NULL REFERENCES removal (removal_id) ON DELETE CASCADE,
    lot_id      INT  NOT NULL REFERENCES lot (lot_id)         ON DELETE RESTRICT,
    quantity    INT  NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (removal_id, lot_id)
);

CREATE TABLE transfer (
    restock_id        SERIAL     PRIMARY KEY,
    restocked_at      TIMESTAMP  NOT NULL,
    staff_id          INT        NOT NULL REFERENCES staff (staff_id)       ON DELETE RESTRICT,
    from_location_id  INT        NOT NULL REFERENCES location (location_id) ON DELETE RESTRICT,
    to_location_id    INT        NOT NULL REFERENCES location (location_id) ON DELETE RESTRICT,
    CONSTRAINT transfer_different_locations CHECK (from_location_id <> to_location_id)
);

CREATE TABLE transfer_line (
    restock_id  INT  NOT NULL REFERENCES transfer (restock_id) ON DELETE CASCADE,
    lot_id      INT  NOT NULL REFERENCES lot (lot_id)          ON DELETE RESTRICT,
    quantity    INT  NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (restock_id, lot_id)
);

CREATE TABLE alert (
    alert_id         SERIAL       PRIMARY KEY,
    alert_type       VARCHAR(30)  NOT NULL CHECK (alert_type IN ('low_stock', 'expiring')),
    created_at       TIMESTAMP    NOT NULL,
    status           VARCHAR(20)  NOT NULL CHECK (status IN ('open', 'acknowledged')),
    location_id      INT          NOT NULL REFERENCES location (location_id) ON DELETE RESTRICT,
    item_id          INT                   REFERENCES medication (item_id)   ON DELETE RESTRICT,
    lot_id           INT                   REFERENCES lot (lot_id)           ON DELETE RESTRICT,
    acknowledged_by  INT                   REFERENCES staff (staff_id)       ON DELETE RESTRICT,
    CONSTRAINT alert_target_matches_type CHECK (
        (alert_type = 'low_stock' AND item_id IS NOT NULL AND lot_id IS NULL) OR
        (alert_type = 'expiring'  AND lot_id IS NOT NULL AND item_id IS NULL)
    ),
    CONSTRAINT alert_ack_has_staff CHECK ((status = 'acknowledged') = (acknowledged_by IS NOT NULL))
);

CREATE INDEX idx_lot_exp_date ON lot (exp_date);
CREATE INDEX idx_stock_location ON stock (location_id);
CREATE INDEX idx_removal_removed_at ON removal (removed_at);
CREATE INDEX idx_removal_line_lot  ON removal_line (lot_id);
CREATE INDEX idx_transfer_line_lot ON transfer_line (lot_id);
CREATE INDEX idx_purchase_order_supplier ON purchase_order (supplier_id);