show triggers;
SET GLOBAL event_scheduler = ON;


-- #1
-- calculate total amount in the sales based on the price and quantity on the orders and product table -- 
DELIMITER $$

CREATE TRIGGER calculateTotalAmount
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
  DECLARE price DECIMAL(10,2);
  DECLARE qty INT;

  SELECT p.price, o.quantity
  INTO price, qty
  FROM orders o
  JOIN products p ON o.productID = p.productID
  WHERE o.orderID = NEW.orderID;

  SET NEW.totalAmount = price * qty;
END $$

DELIMITER ;

-- #2
-- update (reduce) stock in the product table after insert order --
DELIMITER $$

CREATE TRIGGER update_stock_after_insert_order
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
  UPDATE products
  SET stock = stock - NEW.quantity
  WHERE productID = NEW.productID;
END $$

DELIMITER ;

-- #3
-- update (restore) stock in the product after delete order --
DELIMITER $$

CREATE TRIGGER restore_stock_after_delete_order
AFTER DELETE ON orders
FOR EACH ROW
BEGIN
  UPDATE products
  SET stock = stock + OLD.quantity
  WHERE productID = OLD.productID;
END $$

DELIMITER ;

-- #4
-- delete products under a deleted category -- 
DELIMITER $$

CREATE TRIGGER delete_products_deleted_category
AFTER DELETE ON category
FOR EACH ROW
BEGIN
  DELETE FROM products
  WHERE categoryID = OLD.categoryID;
END $$

DELIMITER ;

-- #5
-- delete row in the sales order after delete order -- 
DELIMITER $$

CREATE TRIGGER after_order_delete_delete_sales
AFTER DELETE ON orders
FOR EACH ROW
BEGIN
  DELETE FROM sales
  WHERE orderID = OLD.orderID;
END $$

DELIMITER ;


-- #6
-- restock products
DELIMITER $$

CREATE PROCEDURE restock_products()
BEGIN
  UPDATE products
  SET stock = stock + 10;
END $$

DELIMITER ;

-- calls the restock procedure everynight
DELIMITER $$

CREATE EVENT daily_restock_event
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
  CALL restock_products(); $$

DELIMITER ;

-- #7 
-- prevent inserting orders with insufficient stock --
DELIMITER $$

CREATE TRIGGER prevent_order_with_insufficient_stock
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
  DECLARE current_stock INT;

  SELECT stock INTO current_stock
  FROM products
  WHERE productID = NEW.productID;

  IF NEW.quantity > current_stock THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Not enough stock for this product';
  END IF;
END $$

DELIMITER ;