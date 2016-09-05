-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema QRemis
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema QRemis
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `QRemis` DEFAULT CHARACTER SET utf8 ;
USE `QRemis` ;

GRANT ALL PRIVILEGES ON QRemis.* TO 'operator'@'%' IDENTIFIED BY '8ab559469a70a24a1ae108a67a6c797e';

-- -----------------------------------------------------
-- Table `QRemis`.`Parada`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QRemis`.`Parada` (
  `idParada` INT NOT NULL AUTO_INCREMENT,
  `Parada` VARCHAR(45) NULL,
  `gps_pos` VARCHAR(45) NULL,
  PRIMARY KEY (`idParada`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `QRemis`.`Movil`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QRemis`.`Movil` (
  `idMovil` INT NOT NULL AUTO_INCREMENT,
  `idParada` INT NULL,
  `modelo` VARCHAR(45) NULL,
  `ultimaPos` VARCHAR(45) NULL,
  `estado` INT NULL,
  `added` DATETIME NULL,
  `endMulta` DATETIME NULL,
  PRIMARY KEY (`idMovil`),
  INDEX `fk_Movil_Parada1_idx` (`idParada` ASC),
  CONSTRAINT `fk_Movil_Parada1`
    FOREIGN KEY (`idParada`)
    REFERENCES `QRemis`.`Parada` (`idParada`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO Movil (modelo) VALUES ('Desconociodo'), ('Desconociodo'), ('Desconociodo'), ('Desconociodo');

-- -----------------------------------------------------
-- Table `QRemis`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QRemis`.`Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `telefono` DOUBLE NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `direccion` VARCHAR(45) NULL,
  `descripcion` VARCHAR(45) NULL,
  `gps_pos` VARCHAR(45) NULL,
  PRIMARY KEY (`idCliente`, `telefono`),
  UNIQUE INDEX `telefono_UNIQUE` (`telefono` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QRemis`.`sec_Rol`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QRemis`.`sec_Rol` (
  `idRol` INT NOT NULL AUTO_INCREMENT,
  `Rol` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idRol`))
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `QRemis`.`sec_Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QRemis`.`sec_Usuario` (
  `idUsuario` INT NOT NULL AUTO_INCREMENT,
  `idRol` INT NOT NULL,
  `user` VARCHAR(45) NULL DEFAULT NULL,
  `pass` VARCHAR(45) NULL DEFAULT NULL,
  `Nombre` VARCHAR(45) NULL DEFAULT NULL,
  `Apellido` VARCHAR(45) NULL DEFAULT NULL,
  `Direccion` VARCHAR(45) NULL DEFAULT NULL,
  `Telefono` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idUsuario`, `idRol`),
  INDEX `fk_Usuario_Rol1_idx` (`idRol` ASC),
  CONSTRAINT `fk_Usuario_Rol1`
    FOREIGN KEY (`idRol`)
    REFERENCES `QRemis`.`sec_Rol` (`idRol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `QRemis`.`Llamadas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QRemis`.`Llamadas` (
  `idLlamadas` INT NOT NULL AUTO_INCREMENT,
  `idUsuario` INT NULL,
  `fecha` DATETIME NULL,
  `telefono` DOUBLE NULL,
  `duracion` TIME NULL,
  `estado` INT NULL,
  `grabacion` VARCHAR(100) NULL,
  PRIMARY KEY (`idLlamadas`),
  INDEX `fk_Llamadas_sec_Usuario1_idx` (`idUsuario` ASC),
  CONSTRAINT `fk_Llamadas_sec_Usuario1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `QRemis`.`sec_Usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QRemis`.`Alquiler`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QRemis`.`Alquiler` (
  `idAlquiler` INT NOT NULL AUTO_INCREMENT,
  `idMovil` INT NULL,
  `idParada` INT NULL,
  `idCliente` INT NOT NULL,
  `idLlamadas` INT NOT NULL,
  `telefono` DOUBLE NOT NULL,
  `fecha` DATETIME NULL,
  `origen` VARCHAR(45) NULL,
  `origen_gps` VARCHAR(45) NULL,
  `destino` VARCHAR(45) NULL,
  `destino_gps` VARCHAR(45) NULL,
  `km` INT NULL,
  `fechaAtencion` DATETIME NULL,
  PRIMARY KEY (`idAlquiler`),
  INDEX `fk_Alquiler_Moviles_idx` (`idMovil` ASC),
  INDEX `fk_Alquiler_Llamadas1_idx` (`idLlamadas` ASC),
  INDEX `fk_Alquiler_Cliente1_idx` (`idCliente` ASC, `telefono` ASC),
  INDEX `fk_Alquiler_Parada1_idx` (`idParada` ASC),
  CONSTRAINT `fk_Alquiler_Moviles`
    FOREIGN KEY (`idMovil`)
    REFERENCES `QRemis`.`Movil` (`idMovil`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Alquiler_Llamadas1`
    FOREIGN KEY (`idLlamadas`)
    REFERENCES `QRemis`.`Llamadas` (`idLlamadas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Alquiler_Cliente1`
    FOREIGN KEY (`idCliente` , `telefono`)
    REFERENCES `QRemis`.`Cliente` (`idCliente` , `telefono`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Alquiler_Parada1`
    FOREIGN KEY (`idParada`)
    REFERENCES `QRemis`.`Parada` (`idParada`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QRemis`.`sec_Plugin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QRemis`.`sec_Plugin` (
  `idPlugin` INT NOT NULL AUTO_INCREMENT,
  `Plugin` VARCHAR(45) NULL DEFAULT NULL,
  `autor` VARCHAR(45) NULL DEFAULT NULL,
  `email` VARCHAR(45) NULL DEFAULT NULL,
  `key` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idPlugin`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QRemis`.`sec_RolDetalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QRemis`.`sec_RolDetalle` (
  `idRolDetalle` INT NOT NULL AUTO_INCREMENT,
  `idRol` INT NOT NULL,
  `idPlugin` INT NOT NULL,
  PRIMARY KEY (`idRolDetalle`, `idRol`),
  INDEX `fk_table1_Rol1_idx` (`idRol` ASC),
  INDEX `fk_sec_RolDetalle_sec_Plugin1_idx` (`idPlugin` ASC),
  CONSTRAINT `fk_table1_Rol1`
    FOREIGN KEY (`idRol`)
    REFERENCES `QRemis`.`sec_Rol` (`idRol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sec_RolDetalle_sec_Plugin1`
    FOREIGN KEY (`idPlugin`)
    REFERENCES `QRemis`.`sec_Plugin` (`idPlugin`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QRemis`.`Multas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QRemis`.`Multas` (
  `idMulta` INT NOT NULL AUTO_INCREMENT,
  `idMovil` INT NOT NULL,
  `idUsuario` INT NOT NULL,
  `inicio` DATETIME NULL,
  `fin` DATETIME NULL,
  PRIMARY KEY (`idMulta`),
  INDEX `fk_Multas_Movil1_idx` (`idMovil` ASC),
  INDEX `fk_Multas_sec_Usuario1_idx` (`idUsuario` ASC),
  CONSTRAINT `fk_Multas_Movil1`
    FOREIGN KEY (`idMovil`)
    REFERENCES `QRemis`.`Movil` (`idMovil`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Multas_sec_Usuario1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `QRemis`.`sec_Usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `QRemis` ;

-- -----------------------------------------------------
-- Placeholder table for view `QRemis`.`VMoviles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QRemis`.`VMoviles` (`idMovil` INT, `idParada` INT, `modelo` INT, `ultimaPos` INT, `estado` INT, `added` INT, `endMulta` INT);

-- -----------------------------------------------------
-- Placeholder table for view `QRemis`.`VEspera`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QRemis`.`VEspera` (`idAlquiler` INT, `idMovil` INT, `idParada` INT, `idCliente` INT, `idLlamadas` INT, `telefono` INT, `fecha` INT, `origen` INT, `origen_gps` INT, `destino` INT, `destino_gps` INT, `km` INT, `fechaAtencion` INT);

-- -----------------------------------------------------
-- procedure crearLlamada
-- -----------------------------------------------------

DELIMITER $$
USE `QRemis`$$
CREATE PROCEDURE `crearLlamada` (tel DOUBLE, date_time INT)
BEGIN
	INSERT INTO Llamadas (telefono, fecha, estado, operador) 
		   VALUES (tel, from_unixtime(date_time), 0, 1);
	SELECT last_insert_id();
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure finLlamada
-- -----------------------------------------------------

DELIMITER $$
USE `QRemis`$$
CREATE PROCEDURE `finLlamada` (id INT, date_time INT, grab VARCHAR(100))
BEGIN
	UPDATE Llamadas SET 
			duracion = timediff(from_unixtime(date_time), fecha),
            grabacion = grab
			WHERE idLlamadas = id;
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- View `QRemis`.`VMoviles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `QRemis`.`VMoviles`;
USE `QRemis`;
CREATE  OR REPLACE VIEW `VMoviles` AS
SELECT * FROM Movil WHERE estado != 3;

-- -----------------------------------------------------
-- View `QRemis`.`VEspera`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `QRemis`.`VEspera`;
USE `QRemis`;
CREATE  OR REPLACE VIEW `VEspera` AS
SELECT * FROM Alquiler WHERE isNull(fechaAtencion);


-- -----------------------------------------------------
-- ADD VALUES
-- -----------------------------------------------------
INSERT INTO sec_Rol (idRol, Rol) VALUES (1, 'Administrador'), (2, 'Operador');
INSERT INTO sec_Usuario (idRol, user, pass, Nombre) VALUE (1, 'admin', md5('admin'), 'Administrador');

INSERT INTO Parada (Parada) VALUES ('Parada 1'), ('Parada 2');
INSERT INTO Movil (modelo) VALUES ('Desconociodo'), ('Desconociodo'), ('Desconociodo'), ('Desconociodo');


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
