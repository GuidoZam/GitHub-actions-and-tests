IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    IF SCHEMA_ID(N'rda') IS NULL EXEC(N'CREATE SCHEMA [rda];');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE TABLE [rda].[Categories] (
        [IdCategory] uniqueidentifier NOT NULL,
        [Code] nvarchar(100) NOT NULL,
        [DisplayName] nvarchar(500) NOT NULL,
        [VisibleTo] nvarchar(max) NULL,
        [RowVersion] rowversion NOT NULL,
        [CreatedBy] nvarchar(max) NOT NULL,
        [Created] datetime2 NOT NULL,
        [UpdatedBy] nvarchar(max) NOT NULL,
        [Updated] datetime2 NOT NULL,
        CONSTRAINT [PK_Categories] PRIMARY KEY ([IdCategory])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE TABLE [rda].[Companies] (
        [IdCompany] uniqueidentifier NOT NULL,
        [ExternalId] nvarchar(100) NOT NULL,
        [DisplayName] nvarchar(500) NOT NULL,
        [RowVersion] rowversion NOT NULL,
        [CreatedBy] nvarchar(max) NOT NULL,
        [Created] datetime2 NOT NULL,
        [UpdatedBy] nvarchar(max) NOT NULL,
        [Updated] datetime2 NOT NULL,
        CONSTRAINT [PK_Companies] PRIMARY KEY ([IdCompany])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE TABLE [rda].[OrdersStatuses] (
        [IdOrderStatus] uniqueidentifier NOT NULL,
        [Code] nvarchar(100) NULL,
        [DisplayName] nvarchar(500) NOT NULL,
        [RowVersion] rowversion NOT NULL,
        [CreatedBy] nvarchar(max) NOT NULL,
        [Created] datetime2 NOT NULL,
        [UpdatedBy] nvarchar(max) NOT NULL,
        [Updated] datetime2 NOT NULL,
        CONSTRAINT [PK_OrdersStatuses] PRIMARY KEY ([IdOrderStatus])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE TABLE [rda].[CostCenters] (
        [IdCostCenter] uniqueidentifier NOT NULL,
        [IdCompany] uniqueidentifier NOT NULL,
        [ExternalId] nvarchar(100) NULL,
        [DisplayName] nvarchar(500) NOT NULL,
        [RowVersion] rowversion NOT NULL,
        [CreatedBy] nvarchar(max) NOT NULL,
        [Created] datetime2 NOT NULL,
        [UpdatedBy] nvarchar(max) NOT NULL,
        [Updated] datetime2 NOT NULL,
        CONSTRAINT [PK_CostCenters] PRIMARY KEY ([IdCostCenter], [IdCompany]),
        CONSTRAINT [FK_CostCenters_Companies_IdCompany] FOREIGN KEY ([IdCompany]) REFERENCES [rda].[Companies] ([IdCompany]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE TABLE [rda].[Suppliers] (
        [IdSupplier] uniqueidentifier NOT NULL,
        [IdCompany] uniqueidentifier NOT NULL,
        [ExternalId] nvarchar(100) NULL,
        [DisplayName] nvarchar(500) NOT NULL,
        [Referrer] nvarchar(200) NOT NULL,
        [Telephone] nvarchar(200) NULL,
        [Email] nvarchar(200) NULL,
        [RowVersion] rowversion NOT NULL,
        [CreatedBy] nvarchar(max) NOT NULL,
        [Created] datetime2 NOT NULL,
        [UpdatedBy] nvarchar(max) NOT NULL,
        [Updated] datetime2 NOT NULL,
        CONSTRAINT [PK_Suppliers] PRIMARY KEY ([IdSupplier], [IdCompany]),
        CONSTRAINT [FK_Suppliers_Companies_IdCompany] FOREIGN KEY ([IdCompany]) REFERENCES [rda].[Companies] ([IdCompany]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE TABLE [rda].[Orders] (
        [IdOrder] uniqueidentifier NOT NULL,
        [IdCompany] uniqueidentifier NULL,
        [UserRequestedBy] nvarchar(200) NOT NULL,
        [UserManager] nvarchar(200) NOT NULL,
        [DisplayName] nvarchar(500) NOT NULL,
        [Description] nvarchar(max) NULL,
        [IdCategory] uniqueidentifier NULL,
        [RequiresContract] bit NOT NULL,
        [ContractUrl] nvarchar(max) NOT NULL,
        [ContractSigned] bit NULL,
        [Notes] nvarchar(max) NULL,
        [IdSupplierSelected] uniqueidentifier NULL,
        [FinalPrice] decimal(18,2) NOT NULL,
        [CoGeAccount] nvarchar(100) NULL,
        [OrderNumber] nvarchar(100) NULL,
        [IdCostCenter] uniqueidentifier NULL,
        [BudgetCoverage] bit NOT NULL,
        [BudgetCoverageNotes] nvarchar(max) NULL,
        [IdOrderStatus] uniqueidentifier NULL,
        [ContractSignedDateTime] datetime2 NULL,
        [RowVersion] rowversion NOT NULL,
        [CreatedBy] nvarchar(max) NOT NULL,
        [Created] datetime2 NOT NULL,
        [UpdatedBy] nvarchar(max) NOT NULL,
        [Updated] datetime2 NOT NULL,
        CONSTRAINT [PK_Orders] PRIMARY KEY ([IdOrder]),
        CONSTRAINT [FK_Orders_Categories_IdCategory] FOREIGN KEY ([IdCategory]) REFERENCES [rda].[Categories] ([IdCategory]),
        CONSTRAINT [FK_Orders_Companies_IdCompany] FOREIGN KEY ([IdCompany]) REFERENCES [rda].[Companies] ([IdCompany]),
        CONSTRAINT [FK_Orders_CostCenters_IdCostCenter_IdCompany] FOREIGN KEY ([IdCostCenter], [IdCompany]) REFERENCES [rda].[CostCenters] ([IdCostCenter], [IdCompany]),
        CONSTRAINT [FK_Orders_OrdersStatuses_IdOrderStatus] FOREIGN KEY ([IdOrderStatus]) REFERENCES [rda].[OrdersStatuses] ([IdOrderStatus]),
        CONSTRAINT [FK_Orders_Suppliers_IdSupplierSelected_IdCompany] FOREIGN KEY ([IdSupplierSelected], [IdCompany]) REFERENCES [rda].[Suppliers] ([IdSupplier], [IdCompany])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE TABLE [rda].[OrdersAttachments] (
        [IdOrder] uniqueidentifier NOT NULL,
        [IdOrderAttachment] uniqueidentifier NOT NULL,
        [FileName] nvarchar(max) NULL,
        [GraphSiteId] nvarchar(max) NULL,
        [GraphDriveId] nvarchar(max) NULL,
        [GraphContainerId] nvarchar(max) NULL,
        [GraphItemId] nvarchar(max) NULL,
        [RowVersion] rowversion NOT NULL,
        [CreatedBy] nvarchar(max) NOT NULL,
        [Created] datetime2 NOT NULL,
        [UpdatedBy] nvarchar(max) NOT NULL,
        [Updated] datetime2 NOT NULL,
        CONSTRAINT [PK_OrdersAttachments] PRIMARY KEY ([IdOrderAttachment], [IdOrder]),
        CONSTRAINT [FK_OrdersAttachments_Orders_IdOrder] FOREIGN KEY ([IdOrder]) REFERENCES [rda].[Orders] ([IdOrder]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE TABLE [rda].[OrdersDetails] (
        [IdOrder] uniqueidentifier NOT NULL,
        [IdOrderDetail] uniqueidentifier NOT NULL,
        [ItemCode] nvarchar(100) NULL,
        [ItemDescription] nvarchar(max) NOT NULL,
        [Quantity] int NOT NULL,
        [UnitPrice] decimal(18,2) NOT NULL,
        [EstimatedDeliveryDate] datetime2 NULL,
        [RowVersion] rowversion NOT NULL,
        [CreatedBy] nvarchar(max) NOT NULL,
        [Created] datetime2 NOT NULL,
        [UpdatedBy] nvarchar(max) NOT NULL,
        [Updated] datetime2 NOT NULL,
        CONSTRAINT [PK_OrdersDetails] PRIMARY KEY ([IdOrderDetail], [IdOrder]),
        CONSTRAINT [FK_OrdersDetails_Orders_IdOrder] FOREIGN KEY ([IdOrder]) REFERENCES [rda].[Orders] ([IdOrder]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE INDEX [IX_CostCenters_IdCompany] ON [rda].[CostCenters] ([IdCompany]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE INDEX [IX_Orders_IdCategory] ON [rda].[Orders] ([IdCategory]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE INDEX [IX_Orders_IdCompany] ON [rda].[Orders] ([IdCompany]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE INDEX [IX_Orders_IdCostCenter_IdCompany] ON [rda].[Orders] ([IdCostCenter], [IdCompany]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE INDEX [IX_Orders_IdOrderStatus] ON [rda].[Orders] ([IdOrderStatus]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE INDEX [IX_Orders_IdSupplierSelected_IdCompany] ON [rda].[Orders] ([IdSupplierSelected], [IdCompany]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE INDEX [IX_OrdersAttachments_IdOrder] ON [rda].[OrdersAttachments] ([IdOrder]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE INDEX [IX_OrdersDetails_IdOrder] ON [rda].[OrdersDetails] ([IdOrder]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    CREATE INDEX [IX_Suppliers_IdCompany] ON [rda].[Suppliers] ([IdCompany]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230330103839_InitialMigration')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230330103839_InitialMigration', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230516102744_AddedAdditionalFields')
BEGIN
    ALTER TABLE [rda].[Orders] ADD [CurrentTaskAssignee] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230516102744_AddedAdditionalFields')
BEGIN
    ALTER TABLE [rda].[Categories] ADD [SkipFinance] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230516102744_AddedAdditionalFields')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230516102744_AddedAdditionalFields', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230518141651_AddedSkipProcurement')
BEGIN
    ALTER TABLE [rda].[Categories] ADD [SkipProcurement] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230518141651_AddedSkipProcurement')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230518141651_AddedSkipProcurement', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230519110641_OptionalCurrentAssignee')
BEGIN
    DECLARE @var0 sysname;
    SELECT @var0 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[rda].[Orders]') AND [c].[name] = N'CurrentTaskAssignee');
    IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [rda].[Orders] DROP CONSTRAINT [' + @var0 + '];');
    ALTER TABLE [rda].[Orders] ALTER COLUMN [CurrentTaskAssignee] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230519110641_OptionalCurrentAssignee')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230519110641_OptionalCurrentAssignee', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230609124004_OptionalContractUrl')
BEGIN
    DECLARE @var1 sysname;
    SELECT @var1 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[rda].[Orders]') AND [c].[name] = N'ContractUrl');
    IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [rda].[Orders] DROP CONSTRAINT [' + @var1 + '];');
    ALTER TABLE [rda].[Orders] ALTER COLUMN [ContractUrl] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230609124004_OptionalContractUrl')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230609124004_OptionalContractUrl', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230619101249_NewSupplierFields')
BEGIN
    ALTER TABLE [rda].[Orders] ADD [NewSupplierDisplayName] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230619101249_NewSupplierFields')
BEGIN
    ALTER TABLE [rda].[Orders] ADD [NewSupplierEmail] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230619101249_NewSupplierFields')
BEGIN
    ALTER TABLE [rda].[Orders] ADD [NewSupplierReferrer] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230619101249_NewSupplierFields')
BEGIN
    ALTER TABLE [rda].[Orders] ADD [NewSupplierTelephone] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230619101249_NewSupplierFields')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230619101249_NewSupplierFields', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230621102316_MadeOrderStatusCodeUnique')
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [IX_OrdersStatuses_Code] ON [rda].[OrdersStatuses] ([Code]) WHERE [Code] IS NOT NULL');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230621102316_MadeOrderStatusCodeUnique')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230621102316_MadeOrderStatusCodeUnique', N'7.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230628104419_ManagerNotrequired')
BEGIN
    DECLARE @var2 sysname;
    SELECT @var2 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[rda].[Orders]') AND [c].[name] = N'UserManager');
    IF @var2 IS NOT NULL EXEC(N'ALTER TABLE [rda].[Orders] DROP CONSTRAINT [' + @var2 + '];');
    ALTER TABLE [rda].[Orders] ALTER COLUMN [UserManager] nvarchar(200) NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20230628104419_ManagerNotrequired')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230628104419_ManagerNotrequired', N'7.0.4');
END;
GO

COMMIT;
GO


