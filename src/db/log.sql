-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`GrupoUsuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`GrupoUsuario` (
  `idGrupoUsuario` INT NOT NULL,
  `NomeGrupoUsuario` VARCHAR(50) NULL,
  PRIMARY KEY (`idGrupoUsuario`),
  UNIQUE INDEX `NomeGrupoUsuario_UNIQUE` (`NomeGrupoUsuario` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Usuario` (
  `idUsuario` INT NOT NULL,
  `nome` VARCHAR(500) NOT NULL,
  `login` VARCHAR(60) NOT NULL,
  `passwd` VARCHAR(15) NOT NULL,
  `idGrupoUsuario` INT NOT NULL,
  PRIMARY KEY (`idUsuario`),
  UNIQUE INDEX `login_UNIQUE` (`login` ASC),
  INDEX `fk_Usuario_GrupoUsuario_idx` (`idGrupoUsuario` ASC),
  CONSTRAINT `fk_Usuario_GrupoUsuario`
    FOREIGN KEY (`idGrupoUsuario`)
    REFERENCES `mydb`.`GrupoUsuario` (`idGrupoUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Estado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Estado` (
  `idEstado` INT NOT NULL,
  `sigla` VARCHAR(2) NULL,
  PRIMARY KEY (`idEstado`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Cidade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Cidade` (
  `idCidade` INT NOT NULL,
  `nome` VARCHAR(250) NULL,
  `idEstado` INT NULL,
  PRIMARY KEY (`idCidade`),
  INDEX `fk_Cidade_Estado1_idx` (`idEstado` ASC),
  CONSTRAINT `fk_Cidade_Estado1`
    FOREIGN KEY (`idEstado`)
    REFERENCES `mydb`.`Estado` (`idEstado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Endereco` (
  `idEndereco` INT NOT NULL,
  `logradouro` VARCHAR(150) NULL,
  `numero` INT NULL,
  `bairro` VARCHAR(150) NULL,
  `CEP` INT(8) NULL,
  `idCidade` INT NULL,
  PRIMARY KEY (`idEndereco`),
  INDEX `fk_Endereco_Cidade1_idx` (`idCidade` ASC),
  CONSTRAINT `fk_Endereco_Cidade1`
    FOREIGN KEY (`idCidade`)
    REFERENCES `mydb`.`Cidade` (`idCidade`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DadosFinanceiros`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`DadosFinanceiros` (
  `idDadosFinanceiros` INT NOT NULL,
  `banco` VARCHAR(145) NULL,
  `agencia` VARCHAR(145) NULL,
  `contaCorrente` INT NULL,
  `rendaFamiliar` FLOAT NULL,
  `rendaPessoal` FLOAT NULL,
  `observacao` VARCHAR(1000) NULL,
  PRIMARY KEY (`idDadosFinanceiros`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Cliente` (
  `idCliente` INT NOT NULL,
  `nomeCompleto` VARCHAR(500) NULL,
  `dataNascimento` DATE NULL,
  `CPF` INT(11) NULL,
  `RG` INT(45) NULL,
  `idEndereco` INT NOT NULL,
  `idDadosFinanceiros` INT NOT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE INDEX `CPF_UNIQUE` (`CPF` ASC),
  INDEX `fk_Cliente_Endereco1_idx` (`idEndereco` ASC),
  INDEX `fk_Cliente_DadosFinanceiros1_idx` (`idDadosFinanceiros` ASC),
  CONSTRAINT `fk_Cliente_Endereco1`
    FOREIGN KEY (`idEndereco`)
    REFERENCES `mydb`.`Endereco` (`idEndereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cliente_DadosFinanceiros1`
    FOREIGN KEY (`idDadosFinanceiros`)
    REFERENCES `mydb`.`DadosFinanceiros` (`idDadosFinanceiros`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Funcionario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Funcionario` (
  `idfuncionario` INT NOT NULL,
  `nome` VARCHAR(150) NULL,
  `dataNascimento` DATE NULL,
  `CPF` INT(11) NULL,
  `RG` INT(45) NULL,
  `cargo` VARCHAR(150) NULL,
  `email` VARCHAR(45) NULL,
  `telefone` INT(14) NULL,
  `idEndereco` INT NOT NULL,
  PRIMARY KEY (`idfuncionario`),
  INDEX `fk_funcionario_Endereco1_idx` (`idEndereco` ASC),
  CONSTRAINT `fk_funcionario_Endereco1`
    FOREIGN KEY (`idEndereco`)
    REFERENCES `mydb`.`Endereco` (`idEndereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`planoEmprestimo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`planoEmprestimo` (
  `idplanoEmprestimo` INT NOT NULL,
  `nome` VARCHAR(150) NULL,
  `dataCadastro` DATE NULL,
  `jurosTotal` FLOAT NULL,
  `jurosMensal` FLOAT NULL,
  `valorMinimo` FLOAT NULL,
  `valorMaximo` FLOAT NULL,
  `maxParcelas` INT NULL,
  `minParcelas` INT NULL,
  `observacao` VARCHAR(1500) NULL,
  `idFuncionarioResponsavel` INT NOT NULL,
  PRIMARY KEY (`idplanoEmprestimo`),
  INDEX `fk_planoEmprestimo_Funcionario1_idx` (`idFuncionarioResponsavel` ASC),
  CONSTRAINT `fk_planoEmprestimo_Funcionario1`
    FOREIGN KEY (`idFuncionarioResponsavel`)
    REFERENCES `mydb`.`Funcionario` (`idfuncionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Contrato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Contrato` (
  `idContrato` INT NOT NULL,
  `qtdParcelas` INT NULL,
  `valorEmprestimo` FLOAT NULL,
  `valorParcelas` FLOAT NULL,
  `dataCriacaoContrato` DATE NULL,
  `dataTerminoContrato` DATE NULL,
  `statusContrato` VARCHAR(150) NOT NULL,
  `idCliente` INT NOT NULL,
  `idFuncionarioResponsavel` INT NOT NULL,
  `idplanoEmprestimo` INT NOT NULL,
  PRIMARY KEY (`idContrato`),
  INDEX `fk_Contrato_Cliente1_idx` (`idCliente` ASC),
  INDEX `fk_Contrato_funcionario1_idx` (`idFuncionarioResponsavel` ASC),
  INDEX `fk_Contrato_planoEmprestimo1_idx` (`idplanoEmprestimo` ASC),
  CONSTRAINT `fk_Contrato_Cliente1`
    FOREIGN KEY (`idCliente`)
    REFERENCES `mydb`.`Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Contrato_funcionario1`
    FOREIGN KEY (`idFuncionarioResponsavel`)
    REFERENCES `mydb`.`Funcionario` (`idfuncionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Contrato_planoEmprestimo1`
    FOREIGN KEY (`idplanoEmprestimo`)
    REFERENCES `mydb`.`planoEmprestimo` (`idplanoEmprestimo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
