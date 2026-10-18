USE [master]
GO
CREATE DATABASE [DB_Zhurikhin_AutoDealerManagement]
GO
USE [DB_Zhurikhin_AutoDealerManagement]
GO
/****** Object:  Table [dbo].[Parts]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Parts](
	[PartID] [int] IDENTITY(1,1) NOT NULL,
	[Article] [nvarchar](50) NOT NULL,
	[PartName] [nvarchar](150) NOT NULL,
	[RetailPrice] [decimal](10, 2) NOT NULL,
	[MinStockLevel] [int] NOT NULL,
	[CurrentStock] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_LowStockParts]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[v_LowStockParts]
AS
SELECT PartID,Article,PartName,CurrentStock,MinStockLevel,RetailPrice
FROM dbo.Parts WHERE CurrentStock<=MinStockLevel AND IsActive=1;
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [int] NOT NULL,
	[FullName] [nvarchar](150) NOT NULL,
	[Position] [nvarchar](50) NOT NULL,
	[Phone] [nvarchar](20) NULL,
	[Login] [nvarchar](50) NOT NULL,
	[PasswordHash] [nvarchar](256) NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Deals]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Deals](
	[DealID] [int] IDENTITY(1,1) NOT NULL,
	[VIN] [nvarchar](17) NOT NULL,
	[ClientID] [int] NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[DealDate] [datetime] NOT NULL,
	[FinalPrice] [decimal](12, 2) NOT NULL,
	[ContractStatus] [nvarchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DealID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_EmployeeSales]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[v_EmployeeSales]
AS
SELECT e.EmployeeID,e.FullName,CAST(d.DealDate AS date) AS SaleDate,COUNT_BIG(*) AS DealsCount,SUM(d.FinalPrice) AS Revenue
FROM dbo.Deals d JOIN dbo.Employees e ON e.EmployeeID=d.EmployeeID
WHERE d.ContractStatus=N'Исполнен'
GROUP BY e.EmployeeID,e.FullName,CAST(d.DealDate AS date);
GO
/****** Object:  Table [dbo].[AuditLog]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditLog](
	[AuditID] [bigint] IDENTITY(1,1) NOT NULL,
	[EventTime] [datetime2](0) NOT NULL,
	[SqlLogin] [nvarchar](128) NOT NULL,
	[ActorEmployeeID] [int] NULL,
	[TableName] [nvarchar](50) NOT NULL,
	[RecordID] [nvarchar](50) NOT NULL,
	[ActionName] [nvarchar](20) NOT NULL,
	[OldData] [nvarchar](max) NULL,
	[NewData] [nvarchar](max) NULL,
 CONSTRAINT [PK_AuditLog] PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cars]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cars](
	[VIN] [nvarchar](17) NOT NULL,
	[Brand] [nvarchar](50) NOT NULL,
	[Model] [nvarchar](50) NOT NULL,
	[Year] [int] NOT NULL,
	[Color] [nvarchar](30) NULL,
	[Kilomitrage] [int] NOT NULL,
	[Price] [decimal](12, 2) NOT NULL,
	[Status] [nvarchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[VIN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clients]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients](
	[ClientID] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](150) NOT NULL,
	[Phone] [nvarchar](20) NOT NULL,
	[Passport] [nvarchar](30) NULL,
	[Email] [nvarchar](100) NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Deliveries]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Deliveries](
	[DeliveryID] [int] IDENTITY(1,1) NOT NULL,
	[SupplierID] [int] NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[DeliveryDate] [datetime] NOT NULL,
	[WaybillNumber] [nvarchar](50) NOT NULL,
	[Status] [nvarchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DeliveryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeliveryParts]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryParts](
	[DeliveryPartID] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryID] [int] NOT NULL,
	[PartID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[PurchasePrice] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DeliveryPartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderParts]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderParts](
	[OrderPartID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[PartID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[PriceAtMoment] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderPartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderWorks]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderWorks](
	[OrderWorkID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[ServiceID] [int] NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[FactHours] [decimal](5, 2) NOT NULL,
	[CostPerHourAtMoment] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderWorkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SchemaMigrations]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SchemaMigrations](
	[MigrationID] [nvarchar](100) NOT NULL,
	[AppliedAt] [datetime2](0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MigrationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServiceOrders]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceOrders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[VIN] [nvarchar](17) NOT NULL,
	[ClientID] [int] NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[IssueDescription] [nvarchar](500) NULL,
	[Status] [nvarchar](30) NOT NULL,
	[TotalCost] [decimal](12, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Services]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Services](
	[ServiceID] [int] IDENTITY(1,1) NOT NULL,
	[ServiceName] [nvarchar](200) NOT NULL,
	[StandardHours] [decimal](5, 2) NOT NULL,
	[CostPerHour] [decimal](10, 2) NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ServiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StockMovements]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockMovements](
	[MovementID] [bigint] IDENTITY(1,1) NOT NULL,
	[PartID] [int] NOT NULL,
	[QuantityDelta] [int] NOT NULL,
	[MovementDate] [datetime2](0) NOT NULL,
	[SourceType] [nvarchar](30) NOT NULL,
	[SourceID] [int] NULL,
 CONSTRAINT [PK_StockMovements] PRIMARY KEY CLUSTERED 
(
	[MovementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Suppliers]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Suppliers](
	[SupplierID] [int] IDENTITY(1,1) NOT NULL,
	[SupplierName] [nvarchar](150) NOT NULL,
	[ContactPhone] [nvarchar](20) NULL,
	[LegalAddress] [nvarchar](255) NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SupplierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

GO
GO
GO

GO

GO

GO

GO

GO

GO

GO

GO

GO
GO

GO

GO

GO

GO
SET IDENTITY_INSERT [dbo].[AuditLog] ON
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (1,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'2',N'INSERT',NULL,N'{"DealID":2,"VIN":"JHMCR2850BC000003","ClientID":1,"EmployeeID":3,"DealDate":"2026-09-01T00:00:00","FinalPrice":4200000.00,"ContractStatus":"Черновик"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (2,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'JHMCR2850BC000003',N'UPDATE',N'{"VIN":"JHMCR2850BC000003","Brand":"Honda","Model":"CR-V","Year":2026,"Color":"Черный","Kilomitrage":10,"Price":4200000.00,"Status":"Зарезервирован"}',N'{"VIN":"JHMCR2850BC000003","Brand":"Honda","Model":"CR-V","Year":2026,"Color":"Черный","Kilomitrage":10,"Price":4200000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (3,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'JHMCR2850BC000003',N'UPDATE',N'{"VIN":"JHMCR2850BC000003","Brand":"Honda","Model":"CR-V","Year":2026,"Color":"Черный","Kilomitrage":10,"Price":4200000.00,"Status":"На складе"}',N'{"VIN":"JHMCR2850BC000003","Brand":"Honda","Model":"CR-V","Year":2026,"Color":"Черный","Kilomitrage":10,"Price":4200000.00,"Status":"Зарезервирован"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (4,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'2',N'UPDATE',N'{"DealID":2,"VIN":"JHMCR2850BC000003","ClientID":1,"EmployeeID":3,"DealDate":"2026-09-01T00:00:00","FinalPrice":4200000.00,"ContractStatus":"Черновик"}',N'{"DealID":2,"VIN":"JHMCR2850BC000003","ClientID":1,"EmployeeID":3,"DealDate":"2026-09-01T00:00:00","FinalPrice":4200000.00,"ContractStatus":"Зарезервирован"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (5,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'1',N'UPDATE',N'{"EmployeeID":1,"RoleID":1,"FullName":"Михаил Волков","Position":"Системный администратор","Phone":"+7(999)123-45-67","Login":"mvolkov","IsActive":true}',N'{"EmployeeID":1,"RoleID":1,"FullName":"Михаил Волков","Position":"Системный администратор","Phone":"+7(999)123-45-67","Login":"mvolkov","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (6,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'2',N'UPDATE',N'{"EmployeeID":2,"RoleID":2,"FullName":"Сергей Соколов","Position":"Старший мастер-приемщик","Phone":"+7(999)234-56-78","Login":"ssokolov","IsActive":true}',N'{"EmployeeID":2,"RoleID":2,"FullName":"Сергей Соколов","Position":"Старший мастер-приемщик","Phone":"+7(999)234-56-78","Login":"ssokolov","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (7,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'3',N'UPDATE',N'{"EmployeeID":3,"RoleID":3,"FullName":"Анна Кузнецова","Position":"Менеджер отдела продаж","Phone":"+7(999)345-67-89","Login":"akuznetsova","IsActive":true}',N'{"EmployeeID":3,"RoleID":3,"FullName":"Анна Кузнецова","Position":"Менеджер отдела продаж","Phone":"+7(999)345-67-89","Login":"akuznetsova","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (8,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'4',N'UPDATE',N'{"EmployeeID":4,"RoleID":4,"FullName":"Дмитрий Лебедев","Position":"Начальник склада","Phone":"+7(999)456-78-90","Login":"dlebedev","IsActive":true}',N'{"EmployeeID":4,"RoleID":4,"FullName":"Дмитрий Лебедев","Position":"Начальник склада","Phone":"+7(999)456-78-90","Login":"dlebedev","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (9,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'5',N'UPDATE',N'{"EmployeeID":5,"RoleID":5,"FullName":"Евгений Морозов","Position":"Слесарь-механик","Phone":"+7(999)567-89-01","Login":"emorozov","IsActive":true}',N'{"EmployeeID":5,"RoleID":5,"FullName":"Евгений Морозов","Position":"Слесарь-механик","Phone":"+7(999)567-89-01","Login":"emorozov","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (10,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'6',N'INSERT',NULL,N'{"EmployeeID":6,"RoleID":6,"FullName":"Тестовый пользователь","Position":"Наблюдатель","Phone":"+7(900)555-00-00","Login":"user_demo","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (11,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'7',N'INSERT',NULL,N'{"EmployeeID":7,"RoleID":7,"FullName":"Олег Викторович Орлов","Position":"Директор","Phone":"+7(900)555-00-00","Login":"director_demo","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (12,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'8',N'INSERT',NULL,N'{"EmployeeID":8,"RoleID":3,"FullName":"Максим Андреевич Белов","Position":"Менеджер отдела продаж","Phone":"+7(900)555-00-00","Login":"sales_demo","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (13,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'9',N'INSERT',NULL,N'{"EmployeeID":9,"RoleID":5,"FullName":"Павел Сергеевич Громов","Position":"Автомеханик","Phone":"+7(900)555-00-00","Login":"mechanic_demo","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (14,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000001',N'INSERT',NULL,N'{"VIN":"TST00000000000001","Brand":"Lada","Model":"Vesta","Year":2025,"Color":"Белый","Kilomitrage":2100,"Price":1850000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (15,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000002',N'INSERT',NULL,N'{"VIN":"TST00000000000002","Brand":"Lada","Model":"Niva Travel","Year":2026,"Color":"Черный","Kilomitrage":0,"Price":1650000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (16,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000003',N'INSERT',NULL,N'{"VIN":"TST00000000000003","Brand":"Toyota","Model":"Camry","Year":2023,"Color":"Серый","Kilomitrage":6300,"Price":3800000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (17,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000004',N'INSERT',NULL,N'{"VIN":"TST00000000000004","Brand":"Toyota","Model":"RAV4","Year":2024,"Color":"Синий","Kilomitrage":8400,"Price":4500000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (18,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000005',N'INSERT',NULL,N'{"VIN":"TST00000000000005","Brand":"Kia","Model":"Rio","Year":2021,"Color":"Красный","Kilomitrage":10500,"Price":1700000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (19,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000006',N'INSERT',NULL,N'{"VIN":"TST00000000000006","Brand":"Kia","Model":"Sportage","Year":2022,"Color":"Серебристый","Kilomitrage":12600,"Price":3100000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (20,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000007',N'INSERT',NULL,N'{"VIN":"TST00000000000007","Brand":"Hyundai","Model":"Solaris","Year":2020,"Color":"Белый","Kilomitrage":14700,"Price":1500000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (21,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000008',N'INSERT',NULL,N'{"VIN":"TST00000000000008","Brand":"Hyundai","Model":"Tucson","Year":2023,"Color":"Черный","Kilomitrage":16800,"Price":3400000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (22,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000009',N'INSERT',NULL,N'{"VIN":"TST00000000000009","Brand":"Skoda","Model":"Octavia","Year":2021,"Color":"Серый","Kilomitrage":18900,"Price":2200000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (23,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000010',N'INSERT',NULL,N'{"VIN":"TST00000000000010","Brand":"Skoda","Model":"Kodiaq","Year":2022,"Color":"Синий","Kilomitrage":21000,"Price":3500000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (24,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000011',N'INSERT',NULL,N'{"VIN":"TST00000000000011","Brand":"Volkswagen","Model":"Tiguan","Year":2021,"Color":"Красный","Kilomitrage":23100,"Price":3200000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (25,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000012',N'INSERT',NULL,N'{"VIN":"TST00000000000012","Brand":"Renault","Model":"Duster","Year":2020,"Color":"Серебристый","Kilomitrage":25200,"Price":1800000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (26,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000013',N'INSERT',NULL,N'{"VIN":"TST00000000000013","Brand":"Nissan","Model":"Qashqai","Year":2022,"Color":"Белый","Kilomitrage":27300,"Price":2700000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (27,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000014',N'INSERT',NULL,N'{"VIN":"TST00000000000014","Brand":"Mazda","Model":"CX-5","Year":2023,"Color":"Черный","Kilomitrage":29400,"Price":3600000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (28,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000015',N'INSERT',NULL,N'{"VIN":"TST00000000000015","Brand":"Chery","Model":"Tiggo 7 Pro","Year":2025,"Color":"Серый","Kilomitrage":31500,"Price":2800000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (29,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000016',N'INSERT',NULL,N'{"VIN":"TST00000000000016","Brand":"Haval","Model":"Jolion","Year":2026,"Color":"Синий","Kilomitrage":0,"Price":2450000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (30,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000017',N'INSERT',NULL,N'{"VIN":"TST00000000000017","Brand":"Geely","Model":"Coolray","Year":2025,"Color":"Красный","Kilomitrage":35700,"Price":2600000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (31,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000018',N'INSERT',NULL,N'{"VIN":"TST00000000000018","Brand":"Changan","Model":"CS55 Plus","Year":2026,"Color":"Серебристый","Kilomitrage":0,"Price":2900000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (32,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000019',N'INSERT',NULL,N'{"VIN":"TST00000000000019","Brand":"BMW","Model":"320i","Year":2021,"Color":"Белый","Kilomitrage":39900,"Price":4100000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (33,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000020',N'INSERT',NULL,N'{"VIN":"TST00000000000020","Brand":"Mercedes-Benz","Model":"C180","Year":2020,"Color":"Черный","Kilomitrage":42000,"Price":3900000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (34,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000021',N'INSERT',NULL,N'{"VIN":"TST00000000000021","Brand":"Audi","Model":"A4","Year":2022,"Color":"Серый","Kilomitrage":44100,"Price":4300000.00,"Status":"На складе"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (35,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000022',N'INSERT',NULL,N'{"VIN":"TST00000000000022","Brand":"Lexus","Model":"NX","Year":2023,"Color":"Синий","Kilomitrage":46200,"Price":5200000.00,"Status":"В пути"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (36,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000023',N'INSERT',NULL,N'{"VIN":"TST00000000000023","Brand":"Honda","Model":"Civic","Year":2021,"Color":"Красный","Kilomitrage":48300,"Price":2500000.00,"Status":"В пути"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (37,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000024',N'INSERT',NULL,N'{"VIN":"TST00000000000024","Brand":"Suzuki","Model":"Vitara","Year":2022,"Color":"Серебристый","Kilomitrage":50400,"Price":2400000.00,"Status":"На диагностике"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (38,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'3',N'INSERT',NULL,N'{"DeliveryID":3,"SupplierID":3,"EmployeeID":4,"DeliveryDate":"2026-08-06T00:00:00","WaybillNumber":"DEMO-TTN-001","Status":"Черновик"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (39,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'3',N'UPDATE',N'{"DeliveryID":3,"SupplierID":3,"EmployeeID":4,"DeliveryDate":"2026-08-06T00:00:00","WaybillNumber":"DEMO-TTN-001","Status":"Черновик"}',N'{"DeliveryID":3,"SupplierID":3,"EmployeeID":4,"DeliveryDate":"2026-08-06T00:00:00","WaybillNumber":"DEMO-TTN-001","Status":"Проведена"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (40,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'4',N'INSERT',NULL,N'{"DeliveryID":4,"SupplierID":4,"EmployeeID":4,"DeliveryDate":"2026-08-11T00:00:00","WaybillNumber":"DEMO-TTN-002","Status":"Черновик"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (41,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'4',N'UPDATE',N'{"DeliveryID":4,"SupplierID":4,"EmployeeID":4,"DeliveryDate":"2026-08-11T00:00:00","WaybillNumber":"DEMO-TTN-002","Status":"Черновик"}',N'{"DeliveryID":4,"SupplierID":4,"EmployeeID":4,"DeliveryDate":"2026-08-11T00:00:00","WaybillNumber":"DEMO-TTN-002","Status":"Проведена"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (42,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'5',N'INSERT',NULL,N'{"DeliveryID":5,"SupplierID":5,"EmployeeID":4,"DeliveryDate":"2026-08-16T00:00:00","WaybillNumber":"DEMO-TTN-003","Status":"Черновик"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (43,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'5',N'UPDATE',N'{"DeliveryID":5,"SupplierID":5,"EmployeeID":4,"DeliveryDate":"2026-08-16T00:00:00","WaybillNumber":"DEMO-TTN-003","Status":"Черновик"}',N'{"DeliveryID":5,"SupplierID":5,"EmployeeID":4,"DeliveryDate":"2026-08-16T00:00:00","WaybillNumber":"DEMO-TTN-003","Status":"Проведена"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (44,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'6',N'INSERT',NULL,N'{"DeliveryID":6,"SupplierID":3,"EmployeeID":4,"DeliveryDate":"2026-08-21T00:00:00","WaybillNumber":"DEMO-TTN-004","Status":"Черновик"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (45,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'6',N'UPDATE',N'{"DeliveryID":6,"SupplierID":3,"EmployeeID":4,"DeliveryDate":"2026-08-21T00:00:00","WaybillNumber":"DEMO-TTN-004","Status":"Черновик"}',N'{"DeliveryID":6,"SupplierID":3,"EmployeeID":4,"DeliveryDate":"2026-08-21T00:00:00","WaybillNumber":"DEMO-TTN-004","Status":"Проведена"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (46,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'7',N'INSERT',NULL,N'{"DeliveryID":7,"SupplierID":4,"EmployeeID":4,"DeliveryDate":"2026-08-26T00:00:00","WaybillNumber":"DEMO-TTN-005","Status":"Черновик"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (47,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'7',N'UPDATE',N'{"DeliveryID":7,"SupplierID":4,"EmployeeID":4,"DeliveryDate":"2026-08-26T00:00:00","WaybillNumber":"DEMO-TTN-005","Status":"Черновик"}',N'{"DeliveryID":7,"SupplierID":4,"EmployeeID":4,"DeliveryDate":"2026-08-26T00:00:00","WaybillNumber":"DEMO-TTN-005","Status":"Проведена"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (48,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'8',N'INSERT',NULL,N'{"DeliveryID":8,"SupplierID":5,"EmployeeID":4,"DeliveryDate":"2026-08-31T00:00:00","WaybillNumber":"DEMO-TTN-006","Status":"Черновик"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (49,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'8',N'UPDATE',N'{"DeliveryID":8,"SupplierID":5,"EmployeeID":4,"DeliveryDate":"2026-08-31T00:00:00","WaybillNumber":"DEMO-TTN-006","Status":"Черновик"}',N'{"DeliveryID":8,"SupplierID":5,"EmployeeID":4,"DeliveryDate":"2026-08-31T00:00:00","WaybillNumber":"DEMO-TTN-006","Status":"Проведена"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (50,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'9',N'INSERT',NULL,N'{"DeliveryID":9,"SupplierID":3,"EmployeeID":4,"DeliveryDate":"2026-09-05T00:00:00","WaybillNumber":"DEMO-TTN-007","Status":"Черновик"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (51,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'9',N'UPDATE',N'{"DeliveryID":9,"SupplierID":3,"EmployeeID":4,"DeliveryDate":"2026-09-05T00:00:00","WaybillNumber":"DEMO-TTN-007","Status":"Черновик"}',N'{"DeliveryID":9,"SupplierID":3,"EmployeeID":4,"DeliveryDate":"2026-09-05T00:00:00","WaybillNumber":"DEMO-TTN-007","Status":"Проведена"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (52,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'10',N'INSERT',NULL,N'{"DeliveryID":10,"SupplierID":4,"EmployeeID":4,"DeliveryDate":"2026-09-10T00:00:00","WaybillNumber":"DEMO-TTN-008","Status":"Черновик"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (53,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'10',N'UPDATE',N'{"DeliveryID":10,"SupplierID":4,"EmployeeID":4,"DeliveryDate":"2026-09-10T00:00:00","WaybillNumber":"DEMO-TTN-008","Status":"Черновик"}',N'{"DeliveryID":10,"SupplierID":4,"EmployeeID":4,"DeliveryDate":"2026-09-10T00:00:00","WaybillNumber":"DEMO-TTN-008","Status":"Проведена"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (54,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'11',N'INSERT',NULL,N'{"DeliveryID":11,"SupplierID":5,"EmployeeID":4,"DeliveryDate":"2026-09-15T00:00:00","WaybillNumber":"DEMO-TTN-009","Status":"Черновик"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (55,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deliveries',N'12',N'INSERT',NULL,N'{"DeliveryID":12,"SupplierID":3,"EmployeeID":4,"DeliveryDate":"2026-09-20T00:00:00","WaybillNumber":"DEMO-TTN-010","Status":"Черновик"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (56,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000001',N'UPDATE',N'{"VIN":"TST00000000000001","Brand":"Lada","Model":"Vesta","Year":2025,"Color":"Белый","Kilomitrage":2100,"Price":1850000.00,"Status":"На складе"}',N'{"VIN":"TST00000000000001","Brand":"Lada","Model":"Vesta","Year":2025,"Color":"Белый","Kilomitrage":2100,"Price":1850000.00,"Status":"Продан"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (57,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'3',N'INSERT',NULL,N'{"DealID":3,"VIN":"TST00000000000001","ClientID":3,"EmployeeID":3,"DealDate":"2026-07-05T00:00:00","FinalPrice":1800000.00,"ContractStatus":"Исполнен"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (58,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000002',N'UPDATE',N'{"VIN":"TST00000000000002","Brand":"Lada","Model":"Niva Travel","Year":2026,"Color":"Черный","Kilomitrage":0,"Price":1650000.00,"Status":"На складе"}',N'{"VIN":"TST00000000000002","Brand":"Lada","Model":"Niva Travel","Year":2026,"Color":"Черный","Kilomitrage":0,"Price":1650000.00,"Status":"Продан"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (59,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'4',N'INSERT',NULL,N'{"DealID":4,"VIN":"TST00000000000002","ClientID":4,"EmployeeID":3,"DealDate":"2026-07-09T00:00:00","FinalPrice":1600000.00,"ContractStatus":"Исполнен"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (60,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000003',N'UPDATE',N'{"VIN":"TST00000000000003","Brand":"Toyota","Model":"Camry","Year":2023,"Color":"Серый","Kilomitrage":6300,"Price":3800000.00,"Status":"На складе"}',N'{"VIN":"TST00000000000003","Brand":"Toyota","Model":"Camry","Year":2023,"Color":"Серый","Kilomitrage":6300,"Price":3800000.00,"Status":"Продан"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (61,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'5',N'INSERT',NULL,N'{"DealID":5,"VIN":"TST00000000000003","ClientID":5,"EmployeeID":3,"DealDate":"2026-07-13T00:00:00","FinalPrice":3750000.00,"ContractStatus":"Исполнен"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (62,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000004',N'UPDATE',N'{"VIN":"TST00000000000004","Brand":"Toyota","Model":"RAV4","Year":2024,"Color":"Синий","Kilomitrage":8400,"Price":4500000.00,"Status":"На складе"}',N'{"VIN":"TST00000000000004","Brand":"Toyota","Model":"RAV4","Year":2024,"Color":"Синий","Kilomitrage":8400,"Price":4500000.00,"Status":"Продан"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (63,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'6',N'INSERT',NULL,N'{"DealID":6,"VIN":"TST00000000000004","ClientID":6,"EmployeeID":3,"DealDate":"2026-07-17T00:00:00","FinalPrice":4450000.00,"ContractStatus":"Исполнен"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (64,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000005',N'UPDATE',N'{"VIN":"TST00000000000005","Brand":"Kia","Model":"Rio","Year":2021,"Color":"Красный","Kilomitrage":10500,"Price":1700000.00,"Status":"На складе"}',N'{"VIN":"TST00000000000005","Brand":"Kia","Model":"Rio","Year":2021,"Color":"Красный","Kilomitrage":10500,"Price":1700000.00,"Status":"Продан"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (65,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'7',N'INSERT',NULL,N'{"DealID":7,"VIN":"TST00000000000005","ClientID":7,"EmployeeID":3,"DealDate":"2026-07-21T00:00:00","FinalPrice":1650000.00,"ContractStatus":"Исполнен"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (66,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000006',N'UPDATE',N'{"VIN":"TST00000000000006","Brand":"Kia","Model":"Sportage","Year":2022,"Color":"Серебристый","Kilomitrage":12600,"Price":3100000.00,"Status":"На складе"}',N'{"VIN":"TST00000000000006","Brand":"Kia","Model":"Sportage","Year":2022,"Color":"Серебристый","Kilomitrage":12600,"Price":3100000.00,"Status":"Продан"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (67,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'8',N'INSERT',NULL,N'{"DealID":8,"VIN":"TST00000000000006","ClientID":8,"EmployeeID":3,"DealDate":"2026-07-25T00:00:00","FinalPrice":3050000.00,"ContractStatus":"Исполнен"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (68,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000007',N'UPDATE',N'{"VIN":"TST00000000000007","Brand":"Hyundai","Model":"Solaris","Year":2020,"Color":"Белый","Kilomitrage":14700,"Price":1500000.00,"Status":"На складе"}',N'{"VIN":"TST00000000000007","Brand":"Hyundai","Model":"Solaris","Year":2020,"Color":"Белый","Kilomitrage":14700,"Price":1500000.00,"Status":"Продан"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (69,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'9',N'INSERT',NULL,N'{"DealID":9,"VIN":"TST00000000000007","ClientID":9,"EmployeeID":3,"DealDate":"2026-07-29T00:00:00","FinalPrice":1450000.00,"ContractStatus":"Исполнен"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (70,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000008',N'UPDATE',N'{"VIN":"TST00000000000008","Brand":"Hyundai","Model":"Tucson","Year":2023,"Color":"Черный","Kilomitrage":16800,"Price":3400000.00,"Status":"На складе"}',N'{"VIN":"TST00000000000008","Brand":"Hyundai","Model":"Tucson","Year":2023,"Color":"Черный","Kilomitrage":16800,"Price":3400000.00,"Status":"Продан"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (71,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'10',N'INSERT',NULL,N'{"DealID":10,"VIN":"TST00000000000008","ClientID":10,"EmployeeID":3,"DealDate":"2026-08-02T00:00:00","FinalPrice":3350000.00,"ContractStatus":"Исполнен"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (72,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000009',N'UPDATE',N'{"VIN":"TST00000000000009","Brand":"Skoda","Model":"Octavia","Year":2021,"Color":"Серый","Kilomitrage":18900,"Price":2200000.00,"Status":"На складе"}',N'{"VIN":"TST00000000000009","Brand":"Skoda","Model":"Octavia","Year":2021,"Color":"Серый","Kilomitrage":18900,"Price":2200000.00,"Status":"Продан"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (73,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'11',N'INSERT',NULL,N'{"DealID":11,"VIN":"TST00000000000009","ClientID":11,"EmployeeID":3,"DealDate":"2026-08-06T00:00:00","FinalPrice":2150000.00,"ContractStatus":"Исполнен"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (74,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000010',N'UPDATE',N'{"VIN":"TST00000000000010","Brand":"Skoda","Model":"Kodiaq","Year":2022,"Color":"Синий","Kilomitrage":21000,"Price":3500000.00,"Status":"На складе"}',N'{"VIN":"TST00000000000010","Brand":"Skoda","Model":"Kodiaq","Year":2022,"Color":"Синий","Kilomitrage":21000,"Price":3500000.00,"Status":"Продан"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (75,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'12',N'INSERT',NULL,N'{"DealID":12,"VIN":"TST00000000000010","ClientID":12,"EmployeeID":3,"DealDate":"2026-08-10T00:00:00","FinalPrice":3450000.00,"ContractStatus":"Исполнен"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (76,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000011',N'UPDATE',N'{"VIN":"TST00000000000011","Brand":"Volkswagen","Model":"Tiguan","Year":2021,"Color":"Красный","Kilomitrage":23100,"Price":3200000.00,"Status":"На складе"}',N'{"VIN":"TST00000000000011","Brand":"Volkswagen","Model":"Tiguan","Year":2021,"Color":"Красный","Kilomitrage":23100,"Price":3200000.00,"Status":"Зарезервирован"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (77,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'13',N'INSERT',NULL,N'{"DealID":13,"VIN":"TST00000000000011","ClientID":13,"EmployeeID":3,"DealDate":"2026-08-14T00:00:00","FinalPrice":3150000.00,"ContractStatus":"Зарезервирован"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (78,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000012',N'UPDATE',N'{"VIN":"TST00000000000012","Brand":"Renault","Model":"Duster","Year":2020,"Color":"Серебристый","Kilomitrage":25200,"Price":1800000.00,"Status":"На складе"}',N'{"VIN":"TST00000000000012","Brand":"Renault","Model":"Duster","Year":2020,"Color":"Серебристый","Kilomitrage":25200,"Price":1800000.00,"Status":"Зарезервирован"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (79,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'14',N'INSERT',NULL,N'{"DealID":14,"VIN":"TST00000000000012","ClientID":14,"EmployeeID":3,"DealDate":"2026-08-18T00:00:00","FinalPrice":1750000.00,"ContractStatus":"Зарезервирован"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (80,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000013',N'UPDATE',N'{"VIN":"TST00000000000013","Brand":"Nissan","Model":"Qashqai","Year":2022,"Color":"Белый","Kilomitrage":27300,"Price":2700000.00,"Status":"На складе"}',N'{"VIN":"TST00000000000013","Brand":"Nissan","Model":"Qashqai","Year":2022,"Color":"Белый","Kilomitrage":27300,"Price":2700000.00,"Status":"Зарезервирован"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (81,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'15',N'INSERT',NULL,N'{"DealID":15,"VIN":"TST00000000000013","ClientID":15,"EmployeeID":3,"DealDate":"2026-08-22T00:00:00","FinalPrice":2650000.00,"ContractStatus":"Зарезервирован"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (82,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Cars',N'TST00000000000014',N'UPDATE',N'{"VIN":"TST00000000000014","Brand":"Mazda","Model":"CX-5","Year":2023,"Color":"Черный","Kilomitrage":29400,"Price":3600000.00,"Status":"На складе"}',N'{"VIN":"TST00000000000014","Brand":"Mazda","Model":"CX-5","Year":2023,"Color":"Черный","Kilomitrage":29400,"Price":3600000.00,"Status":"Зарезервирован"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (83,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'16',N'INSERT',NULL,N'{"DealID":16,"VIN":"TST00000000000014","ClientID":16,"EmployeeID":3,"DealDate":"2026-08-26T00:00:00","FinalPrice":3550000.00,"ContractStatus":"Зарезервирован"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (84,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'17',N'INSERT',NULL,N'{"DealID":17,"VIN":"TST00000000000015","ClientID":17,"EmployeeID":3,"DealDate":"2026-08-30T00:00:00","FinalPrice":2750000.00,"ContractStatus":"Черновик"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (85,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'18',N'INSERT',NULL,N'{"DealID":18,"VIN":"TST00000000000016","ClientID":18,"EmployeeID":3,"DealDate":"2026-09-03T00:00:00","FinalPrice":2400000.00,"ContractStatus":"Черновик"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (86,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'19',N'INSERT',NULL,N'{"DealID":19,"VIN":"TST00000000000017","ClientID":19,"EmployeeID":3,"DealDate":"2026-09-07T00:00:00","FinalPrice":2550000.00,"ContractStatus":"Отменен"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (87,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Deals',N'20',N'INSERT',NULL,N'{"DealID":20,"VIN":"TST00000000000018","ClientID":20,"EmployeeID":3,"DealDate":"2026-09-11T00:00:00","FinalPrice":2850000.00,"ContractStatus":"Отменен"}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (88,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'2',N'INSERT',NULL,N'{"OrderID":2,"VIN":"TST00000000000001","ClientID":3,"EmployeeID":2,"OrderDate":"2026-08-04T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (89,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'2',N'UPDATE',N'{"OrderID":2,"VIN":"TST00000000000001","ClientID":3,"EmployeeID":2,"OrderDate":"2026-08-04T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":2,"VIN":"TST00000000000001","ClientID":3,"EmployeeID":2,"OrderDate":"2026-08-04T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":900.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (90,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'2',N'UPDATE',N'{"OrderID":2,"VIN":"TST00000000000001","ClientID":3,"EmployeeID":2,"OrderDate":"2026-08-04T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":900.00}',N'{"OrderID":2,"VIN":"TST00000000000001","ClientID":3,"EmployeeID":2,"OrderDate":"2026-08-04T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":1500.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (91,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'2',N'UPDATE',N'{"OrderID":2,"VIN":"TST00000000000001","ClientID":3,"EmployeeID":2,"OrderDate":"2026-08-04T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":1500.00}',N'{"OrderID":2,"VIN":"TST00000000000001","ClientID":3,"EmployeeID":2,"OrderDate":"2026-08-04T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Закрыт","TotalCost":1500.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (92,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'3',N'INSERT',NULL,N'{"OrderID":3,"VIN":"TST00000000000002","ClientID":4,"EmployeeID":2,"OrderDate":"2026-08-07T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (93,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'3',N'UPDATE',N'{"OrderID":3,"VIN":"TST00000000000002","ClientID":4,"EmployeeID":2,"OrderDate":"2026-08-07T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":3,"VIN":"TST00000000000002","ClientID":4,"EmployeeID":2,"OrderDate":"2026-08-07T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":1100.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (94,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'3',N'UPDATE',N'{"OrderID":3,"VIN":"TST00000000000002","ClientID":4,"EmployeeID":2,"OrderDate":"2026-08-07T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":1100.00}',N'{"OrderID":3,"VIN":"TST00000000000002","ClientID":4,"EmployeeID":2,"OrderDate":"2026-08-07T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":2860.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (95,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'3',N'UPDATE',N'{"OrderID":3,"VIN":"TST00000000000002","ClientID":4,"EmployeeID":2,"OrderDate":"2026-08-07T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":2860.00}',N'{"OrderID":3,"VIN":"TST00000000000002","ClientID":4,"EmployeeID":2,"OrderDate":"2026-08-07T00:00:00","IssueDescription":"Шум при движении.","Status":"Закрыт","TotalCost":2860.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (96,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'4',N'INSERT',NULL,N'{"OrderID":4,"VIN":"TST00000000000003","ClientID":5,"EmployeeID":2,"OrderDate":"2026-08-10T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (97,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'4',N'UPDATE',N'{"OrderID":4,"VIN":"TST00000000000003","ClientID":5,"EmployeeID":2,"OrderDate":"2026-08-10T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":4,"VIN":"TST00000000000003","ClientID":5,"EmployeeID":2,"OrderDate":"2026-08-10T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":650.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (98,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'4',N'UPDATE',N'{"OrderID":4,"VIN":"TST00000000000003","ClientID":5,"EmployeeID":2,"OrderDate":"2026-08-10T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":650.00}',N'{"OrderID":4,"VIN":"TST00000000000003","ClientID":5,"EmployeeID":2,"OrderDate":"2026-08-10T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":1450.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (99,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'4',N'UPDATE',N'{"OrderID":4,"VIN":"TST00000000000003","ClientID":5,"EmployeeID":2,"OrderDate":"2026-08-10T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":1450.00}',N'{"OrderID":4,"VIN":"TST00000000000003","ClientID":5,"EmployeeID":2,"OrderDate":"2026-08-10T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Закрыт","TotalCost":1450.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (100,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'5',N'INSERT',NULL,N'{"OrderID":5,"VIN":"TST00000000000004","ClientID":6,"EmployeeID":2,"OrderDate":"2026-08-13T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (101,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'5',N'UPDATE',N'{"OrderID":5,"VIN":"TST00000000000004","ClientID":6,"EmployeeID":2,"OrderDate":"2026-08-13T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":5,"VIN":"TST00000000000004","ClientID":6,"EmployeeID":2,"OrderDate":"2026-08-13T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":8500.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (102,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'5',N'UPDATE',N'{"OrderID":5,"VIN":"TST00000000000004","ClientID":6,"EmployeeID":2,"OrderDate":"2026-08-13T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":8500.00}',N'{"OrderID":5,"VIN":"TST00000000000004","ClientID":6,"EmployeeID":2,"OrderDate":"2026-08-13T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":11950.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (103,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'5',N'UPDATE',N'{"OrderID":5,"VIN":"TST00000000000004","ClientID":6,"EmployeeID":2,"OrderDate":"2026-08-13T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":11950.00}',N'{"OrderID":5,"VIN":"TST00000000000004","ClientID":6,"EmployeeID":2,"OrderDate":"2026-08-13T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Закрыт","TotalCost":11950.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (104,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'6',N'INSERT',NULL,N'{"OrderID":6,"VIN":"TST00000000000005","ClientID":7,"EmployeeID":2,"OrderDate":"2026-08-16T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (105,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'6',N'UPDATE',N'{"OrderID":6,"VIN":"TST00000000000005","ClientID":7,"EmployeeID":2,"OrderDate":"2026-08-16T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":6,"VIN":"TST00000000000005","ClientID":7,"EmployeeID":2,"OrderDate":"2026-08-16T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":4500.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (106,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'6',N'UPDATE',N'{"OrderID":6,"VIN":"TST00000000000005","ClientID":7,"EmployeeID":2,"OrderDate":"2026-08-16T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":4500.00}',N'{"OrderID":6,"VIN":"TST00000000000005","ClientID":7,"EmployeeID":2,"OrderDate":"2026-08-16T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":6600.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (107,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'6',N'UPDATE',N'{"OrderID":6,"VIN":"TST00000000000005","ClientID":7,"EmployeeID":2,"OrderDate":"2026-08-16T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":6600.00}',N'{"OrderID":6,"VIN":"TST00000000000005","ClientID":7,"EmployeeID":2,"OrderDate":"2026-08-16T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Закрыт","TotalCost":6600.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (108,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'7',N'INSERT',NULL,N'{"OrderID":7,"VIN":"TST00000000000006","ClientID":8,"EmployeeID":2,"OrderDate":"2026-08-19T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (109,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'7',N'UPDATE',N'{"OrderID":7,"VIN":"TST00000000000006","ClientID":8,"EmployeeID":2,"OrderDate":"2026-08-19T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":7,"VIN":"TST00000000000006","ClientID":8,"EmployeeID":2,"OrderDate":"2026-08-19T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":1800.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (110,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'7',N'UPDATE',N'{"OrderID":7,"VIN":"TST00000000000006","ClientID":8,"EmployeeID":2,"OrderDate":"2026-08-19T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":1800.00}',N'{"OrderID":7,"VIN":"TST00000000000006","ClientID":8,"EmployeeID":2,"OrderDate":"2026-08-19T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":6600.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (111,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'7',N'UPDATE',N'{"OrderID":7,"VIN":"TST00000000000006","ClientID":8,"EmployeeID":2,"OrderDate":"2026-08-19T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":6600.00}',N'{"OrderID":7,"VIN":"TST00000000000006","ClientID":8,"EmployeeID":2,"OrderDate":"2026-08-19T00:00:00","IssueDescription":"Шум при движении.","Status":"Закрыт","TotalCost":6600.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (112,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'8',N'INSERT',NULL,N'{"OrderID":8,"VIN":"TST00000000000007","ClientID":9,"EmployeeID":2,"OrderDate":"2026-08-22T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (113,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'8',N'UPDATE',N'{"OrderID":8,"VIN":"TST00000000000007","ClientID":9,"EmployeeID":2,"OrderDate":"2026-08-22T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":8,"VIN":"TST00000000000007","ClientID":9,"EmployeeID":2,"OrderDate":"2026-08-22T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":1600.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (114,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'8',N'UPDATE',N'{"OrderID":8,"VIN":"TST00000000000007","ClientID":9,"EmployeeID":2,"OrderDate":"2026-08-22T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":1600.00}',N'{"OrderID":8,"VIN":"TST00000000000007","ClientID":9,"EmployeeID":2,"OrderDate":"2026-08-22T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":3140.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (115,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'8',N'UPDATE',N'{"OrderID":8,"VIN":"TST00000000000007","ClientID":9,"EmployeeID":2,"OrderDate":"2026-08-22T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":3140.00}',N'{"OrderID":8,"VIN":"TST00000000000007","ClientID":9,"EmployeeID":2,"OrderDate":"2026-08-22T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Закрыт","TotalCost":3140.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (116,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'9',N'INSERT',NULL,N'{"OrderID":9,"VIN":"TST00000000000008","ClientID":10,"EmployeeID":2,"OrderDate":"2026-08-25T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (117,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'9',N'UPDATE',N'{"OrderID":9,"VIN":"TST00000000000008","ClientID":10,"EmployeeID":2,"OrderDate":"2026-08-25T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":9,"VIN":"TST00000000000008","ClientID":10,"EmployeeID":2,"OrderDate":"2026-08-25T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":750.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (118,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'9',N'UPDATE',N'{"OrderID":9,"VIN":"TST00000000000008","ClientID":10,"EmployeeID":2,"OrderDate":"2026-08-25T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":750.00}',N'{"OrderID":9,"VIN":"TST00000000000008","ClientID":10,"EmployeeID":2,"OrderDate":"2026-08-25T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":3510.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (119,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'9',N'UPDATE',N'{"OrderID":9,"VIN":"TST00000000000008","ClientID":10,"EmployeeID":2,"OrderDate":"2026-08-25T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":3510.00}',N'{"OrderID":9,"VIN":"TST00000000000008","ClientID":10,"EmployeeID":2,"OrderDate":"2026-08-25T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Закрыт","TotalCost":3510.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (120,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'10',N'INSERT',NULL,N'{"OrderID":10,"VIN":"TST00000000000009","ClientID":11,"EmployeeID":2,"OrderDate":"2026-08-28T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (121,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'10',N'UPDATE',N'{"OrderID":10,"VIN":"TST00000000000009","ClientID":11,"EmployeeID":2,"OrderDate":"2026-08-28T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":10,"VIN":"TST00000000000009","ClientID":11,"EmployeeID":2,"OrderDate":"2026-08-28T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":1200.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (122,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'10',N'UPDATE',N'{"OrderID":10,"VIN":"TST00000000000009","ClientID":11,"EmployeeID":2,"OrderDate":"2026-08-28T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":1200.00}',N'{"OrderID":10,"VIN":"TST00000000000009","ClientID":11,"EmployeeID":2,"OrderDate":"2026-08-28T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":1800.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (123,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'10',N'UPDATE',N'{"OrderID":10,"VIN":"TST00000000000009","ClientID":11,"EmployeeID":2,"OrderDate":"2026-08-28T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":1800.00}',N'{"OrderID":10,"VIN":"TST00000000000009","ClientID":11,"EmployeeID":2,"OrderDate":"2026-08-28T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Закрыт","TotalCost":1800.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (124,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'11',N'INSERT',NULL,N'{"OrderID":11,"VIN":"TST00000000000010","ClientID":12,"EmployeeID":2,"OrderDate":"2026-08-31T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (125,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'11',N'UPDATE',N'{"OrderID":11,"VIN":"TST00000000000010","ClientID":12,"EmployeeID":2,"OrderDate":"2026-08-31T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":11,"VIN":"TST00000000000010","ClientID":12,"EmployeeID":2,"OrderDate":"2026-08-31T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":550.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (126,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'11',N'UPDATE',N'{"OrderID":11,"VIN":"TST00000000000010","ClientID":12,"EmployeeID":2,"OrderDate":"2026-08-31T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":550.00}',N'{"OrderID":11,"VIN":"TST00000000000010","ClientID":12,"EmployeeID":2,"OrderDate":"2026-08-31T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":2310.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (127,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'11',N'UPDATE',N'{"OrderID":11,"VIN":"TST00000000000010","ClientID":12,"EmployeeID":2,"OrderDate":"2026-08-31T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":2310.00}',N'{"OrderID":11,"VIN":"TST00000000000010","ClientID":12,"EmployeeID":2,"OrderDate":"2026-08-31T00:00:00","IssueDescription":"Шум при движении.","Status":"Закрыт","TotalCost":2310.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (128,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'12',N'INSERT',NULL,N'{"OrderID":12,"VIN":"TST00000000000011","ClientID":13,"EmployeeID":2,"OrderDate":"2026-09-03T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (129,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'12',N'UPDATE',N'{"OrderID":12,"VIN":"TST00000000000011","ClientID":13,"EmployeeID":2,"OrderDate":"2026-09-03T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":12,"VIN":"TST00000000000011","ClientID":13,"EmployeeID":2,"OrderDate":"2026-09-03T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":6200.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (130,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'12',N'UPDATE',N'{"OrderID":12,"VIN":"TST00000000000011","ClientID":13,"EmployeeID":2,"OrderDate":"2026-09-03T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":6200.00}',N'{"OrderID":12,"VIN":"TST00000000000011","ClientID":13,"EmployeeID":2,"OrderDate":"2026-09-03T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":7000.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (131,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'12',N'UPDATE',N'{"OrderID":12,"VIN":"TST00000000000011","ClientID":13,"EmployeeID":2,"OrderDate":"2026-09-03T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":7000.00}',N'{"OrderID":12,"VIN":"TST00000000000011","ClientID":13,"EmployeeID":2,"OrderDate":"2026-09-03T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"В работе","TotalCost":7000.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (132,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'13',N'INSERT',NULL,N'{"OrderID":13,"VIN":"TST00000000000012","ClientID":14,"EmployeeID":2,"OrderDate":"2026-09-06T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (133,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'13',N'UPDATE',N'{"OrderID":13,"VIN":"TST00000000000012","ClientID":14,"EmployeeID":2,"OrderDate":"2026-09-06T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":13,"VIN":"TST00000000000012","ClientID":14,"EmployeeID":2,"OrderDate":"2026-09-06T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":3200.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (134,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'13',N'UPDATE',N'{"OrderID":13,"VIN":"TST00000000000012","ClientID":14,"EmployeeID":2,"OrderDate":"2026-09-06T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":3200.00}',N'{"OrderID":13,"VIN":"TST00000000000012","ClientID":14,"EmployeeID":2,"OrderDate":"2026-09-06T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":6650.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (135,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'13',N'UPDATE',N'{"OrderID":13,"VIN":"TST00000000000012","ClientID":14,"EmployeeID":2,"OrderDate":"2026-09-06T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":6650.00}',N'{"OrderID":13,"VIN":"TST00000000000012","ClientID":14,"EmployeeID":2,"OrderDate":"2026-09-06T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"В работе","TotalCost":6650.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (136,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'14',N'INSERT',NULL,N'{"OrderID":14,"VIN":"TST00000000000013","ClientID":15,"EmployeeID":2,"OrderDate":"2026-09-09T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (137,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'14',N'UPDATE',N'{"OrderID":14,"VIN":"TST00000000000013","ClientID":15,"EmployeeID":2,"OrderDate":"2026-09-09T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":14,"VIN":"TST00000000000013","ClientID":15,"EmployeeID":2,"OrderDate":"2026-09-09T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":900.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (138,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'14',N'UPDATE',N'{"OrderID":14,"VIN":"TST00000000000013","ClientID":15,"EmployeeID":2,"OrderDate":"2026-09-09T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":900.00}',N'{"OrderID":14,"VIN":"TST00000000000013","ClientID":15,"EmployeeID":2,"OrderDate":"2026-09-09T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":3000.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (139,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'14',N'UPDATE',N'{"OrderID":14,"VIN":"TST00000000000013","ClientID":15,"EmployeeID":2,"OrderDate":"2026-09-09T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":3000.00}',N'{"OrderID":14,"VIN":"TST00000000000013","ClientID":15,"EmployeeID":2,"OrderDate":"2026-09-09T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"В работе","TotalCost":3000.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (140,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'15',N'INSERT',NULL,N'{"OrderID":15,"VIN":"TST00000000000014","ClientID":16,"EmployeeID":2,"OrderDate":"2026-09-12T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (141,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'15',N'UPDATE',N'{"OrderID":15,"VIN":"TST00000000000014","ClientID":16,"EmployeeID":2,"OrderDate":"2026-09-12T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":15,"VIN":"TST00000000000014","ClientID":16,"EmployeeID":2,"OrderDate":"2026-09-12T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":1100.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (142,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'15',N'UPDATE',N'{"OrderID":15,"VIN":"TST00000000000014","ClientID":16,"EmployeeID":2,"OrderDate":"2026-09-12T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":1100.00}',N'{"OrderID":15,"VIN":"TST00000000000014","ClientID":16,"EmployeeID":2,"OrderDate":"2026-09-12T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":5900.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (143,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'15',N'UPDATE',N'{"OrderID":15,"VIN":"TST00000000000014","ClientID":16,"EmployeeID":2,"OrderDate":"2026-09-12T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":5900.00}',N'{"OrderID":15,"VIN":"TST00000000000014","ClientID":16,"EmployeeID":2,"OrderDate":"2026-09-12T00:00:00","IssueDescription":"Шум при движении.","Status":"В работе","TotalCost":5900.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (144,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'16',N'INSERT',NULL,N'{"OrderID":16,"VIN":"TST00000000000015","ClientID":17,"EmployeeID":2,"OrderDate":"2026-09-15T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (145,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'16',N'UPDATE',N'{"OrderID":16,"VIN":"TST00000000000015","ClientID":17,"EmployeeID":2,"OrderDate":"2026-09-15T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":16,"VIN":"TST00000000000015","ClientID":17,"EmployeeID":2,"OrderDate":"2026-09-15T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":650.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (146,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'16',N'UPDATE',N'{"OrderID":16,"VIN":"TST00000000000015","ClientID":17,"EmployeeID":2,"OrderDate":"2026-09-15T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":650.00}',N'{"OrderID":16,"VIN":"TST00000000000015","ClientID":17,"EmployeeID":2,"OrderDate":"2026-09-15T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":2190.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (147,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'16',N'UPDATE',N'{"OrderID":16,"VIN":"TST00000000000015","ClientID":17,"EmployeeID":2,"OrderDate":"2026-09-15T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":2190.00}',N'{"OrderID":16,"VIN":"TST00000000000015","ClientID":17,"EmployeeID":2,"OrderDate":"2026-09-15T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"В работе","TotalCost":2190.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (148,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'17',N'INSERT',NULL,N'{"OrderID":17,"VIN":"TST00000000000016","ClientID":18,"EmployeeID":2,"OrderDate":"2026-09-18T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (149,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'17',N'UPDATE',N'{"OrderID":17,"VIN":"TST00000000000016","ClientID":18,"EmployeeID":2,"OrderDate":"2026-09-18T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":17,"VIN":"TST00000000000016","ClientID":18,"EmployeeID":2,"OrderDate":"2026-09-18T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":8500.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (150,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'17',N'UPDATE',N'{"OrderID":17,"VIN":"TST00000000000016","ClientID":18,"EmployeeID":2,"OrderDate":"2026-09-18T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":8500.00}',N'{"OrderID":17,"VIN":"TST00000000000016","ClientID":18,"EmployeeID":2,"OrderDate":"2026-09-18T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":11260.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (151,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'18',N'INSERT',NULL,N'{"OrderID":18,"VIN":"TST00000000000017","ClientID":19,"EmployeeID":2,"OrderDate":"2026-09-21T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (152,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'18',N'UPDATE',N'{"OrderID":18,"VIN":"TST00000000000017","ClientID":19,"EmployeeID":2,"OrderDate":"2026-09-21T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":18,"VIN":"TST00000000000017","ClientID":19,"EmployeeID":2,"OrderDate":"2026-09-21T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":4500.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (153,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'18',N'UPDATE',N'{"OrderID":18,"VIN":"TST00000000000017","ClientID":19,"EmployeeID":2,"OrderDate":"2026-09-21T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":4500.00}',N'{"OrderID":18,"VIN":"TST00000000000017","ClientID":19,"EmployeeID":2,"OrderDate":"2026-09-21T00:00:00","IssueDescription":"Плановое техническое обслуживание.","Status":"Открыт","TotalCost":5100.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (154,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'19',N'INSERT',NULL,N'{"OrderID":19,"VIN":"TST00000000000018","ClientID":20,"EmployeeID":2,"OrderDate":"2026-09-24T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (155,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'19',N'UPDATE',N'{"OrderID":19,"VIN":"TST00000000000018","ClientID":20,"EmployeeID":2,"OrderDate":"2026-09-24T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":19,"VIN":"TST00000000000018","ClientID":20,"EmployeeID":2,"OrderDate":"2026-09-24T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":1800.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (156,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'19',N'UPDATE',N'{"OrderID":19,"VIN":"TST00000000000018","ClientID":20,"EmployeeID":2,"OrderDate":"2026-09-24T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":1800.00}',N'{"OrderID":19,"VIN":"TST00000000000018","ClientID":20,"EmployeeID":2,"OrderDate":"2026-09-24T00:00:00","IssueDescription":"Шум при движении.","Status":"Открыт","TotalCost":3560.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (157,CONVERT(datetime2(7),N'2026-10-05T17:37:20.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'20',N'INSERT',NULL,N'{"OrderID":20,"VIN":"TST00000000000019","ClientID":21,"EmployeeID":2,"OrderDate":"2026-09-27T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (158,CONVERT(datetime2(7),N'2026-10-05T17:37:20.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'20',N'UPDATE',N'{"OrderID":20,"VIN":"TST00000000000019","ClientID":21,"EmployeeID":2,"OrderDate":"2026-09-27T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":20,"VIN":"TST00000000000019","ClientID":21,"EmployeeID":2,"OrderDate":"2026-09-27T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":1600.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (159,CONVERT(datetime2(7),N'2026-10-05T17:37:20.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'20',N'UPDATE',N'{"OrderID":20,"VIN":"TST00000000000019","ClientID":21,"EmployeeID":2,"OrderDate":"2026-09-27T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":1600.00}',N'{"OrderID":20,"VIN":"TST00000000000019","ClientID":21,"EmployeeID":2,"OrderDate":"2026-09-27T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":2400.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (160,CONVERT(datetime2(7),N'2026-10-05T17:37:20.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'20',N'UPDATE',N'{"OrderID":20,"VIN":"TST00000000000019","ClientID":21,"EmployeeID":2,"OrderDate":"2026-09-27T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Открыт","TotalCost":2400.00}',N'{"OrderID":20,"VIN":"TST00000000000019","ClientID":21,"EmployeeID":2,"OrderDate":"2026-09-27T00:00:00","IssueDescription":"Проверка перед дальней поездкой.","Status":"Отменен","TotalCost":2400.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (161,CONVERT(datetime2(7),N'2026-10-05T17:37:20.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'21',N'INSERT',NULL,N'{"OrderID":21,"VIN":"TST00000000000020","ClientID":22,"EmployeeID":2,"OrderDate":"2026-09-30T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":0.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (162,CONVERT(datetime2(7),N'2026-10-05T17:37:20.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'21',N'UPDATE',N'{"OrderID":21,"VIN":"TST00000000000020","ClientID":22,"EmployeeID":2,"OrderDate":"2026-09-30T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":0.00}',N'{"OrderID":21,"VIN":"TST00000000000020","ClientID":22,"EmployeeID":2,"OrderDate":"2026-09-30T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":750.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (163,CONVERT(datetime2(7),N'2026-10-05T17:37:20.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'21',N'UPDATE',N'{"OrderID":21,"VIN":"TST00000000000020","ClientID":22,"EmployeeID":2,"OrderDate":"2026-09-30T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":750.00}',N'{"OrderID":21,"VIN":"TST00000000000020","ClientID":22,"EmployeeID":2,"OrderDate":"2026-09-30T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":4200.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (164,CONVERT(datetime2(7),N'2026-10-05T17:37:20.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'ServiceOrders',N'21',N'UPDATE',N'{"OrderID":21,"VIN":"TST00000000000020","ClientID":22,"EmployeeID":2,"OrderDate":"2026-09-30T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Открыт","TotalCost":4200.00}',N'{"OrderID":21,"VIN":"TST00000000000020","ClientID":22,"EmployeeID":2,"OrderDate":"2026-09-30T00:00:00","IssueDescription":"Замена расходных материалов.","Status":"Отменен","TotalCost":4200.00}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (165,CONVERT(datetime2(7),N'2026-10-17T16:36:56.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'1',N'UPDATE',N'{"EmployeeID":1,"RoleID":1,"FullName":"Михаил Волков","Position":"Системный администратор","Phone":"+7(999)123-45-67","Login":"mvolkov","IsActive":true}',N'{"EmployeeID":1,"RoleID":1,"FullName":"Михаил Волков","Position":"Системный администратор","Phone":"+7(999)123-45-67","Login":"mvolkov","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (166,CONVERT(datetime2(7),N'2026-10-17T16:36:57.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'2',N'UPDATE',N'{"EmployeeID":2,"RoleID":2,"FullName":"Сергей Соколов","Position":"Старший мастер-приемщик","Phone":"+7(999)234-56-78","Login":"ssokolov","IsActive":true}',N'{"EmployeeID":2,"RoleID":2,"FullName":"Сергей Соколов","Position":"Старший мастер-приемщик","Phone":"+7(999)234-56-78","Login":"ssokolov","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (167,CONVERT(datetime2(7),N'2026-10-17T16:36:57.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'3',N'UPDATE',N'{"EmployeeID":3,"RoleID":3,"FullName":"Анна Кузнецова","Position":"Менеджер отдела продаж","Phone":"+7(999)345-67-89","Login":"akuznetsova","IsActive":true}',N'{"EmployeeID":3,"RoleID":3,"FullName":"Анна Кузнецова","Position":"Менеджер отдела продаж","Phone":"+7(999)345-67-89","Login":"akuznetsova","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (168,CONVERT(datetime2(7),N'2026-10-17T16:36:57.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'4',N'UPDATE',N'{"EmployeeID":4,"RoleID":4,"FullName":"Дмитрий Лебедев","Position":"Начальник склада","Phone":"+7(999)456-78-90","Login":"dlebedev","IsActive":true}',N'{"EmployeeID":4,"RoleID":4,"FullName":"Дмитрий Лебедев","Position":"Начальник склада","Phone":"+7(999)456-78-90","Login":"dlebedev","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (169,CONVERT(datetime2(7),N'2026-10-17T16:36:57.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'5',N'UPDATE',N'{"EmployeeID":5,"RoleID":5,"FullName":"Евгений Морозов","Position":"Слесарь-механик","Phone":"+7(999)567-89-01","Login":"emorozov","IsActive":true}',N'{"EmployeeID":5,"RoleID":5,"FullName":"Евгений Морозов","Position":"Слесарь-механик","Phone":"+7(999)567-89-01","Login":"emorozov","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (170,CONVERT(datetime2(7),N'2026-10-17T16:36:57.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'6',N'UPDATE',N'{"EmployeeID":6,"RoleID":6,"FullName":"Тестовый пользователь","Position":"Наблюдатель","Phone":"+7(900)555-00-00","Login":"user_demo","IsActive":true}',N'{"EmployeeID":6,"RoleID":6,"FullName":"Тестовый пользователь","Position":"Наблюдатель","Phone":"+7(900)555-00-00","Login":"user_demo","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (171,CONVERT(datetime2(7),N'2026-10-17T16:36:57.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'7',N'UPDATE',N'{"EmployeeID":7,"RoleID":7,"FullName":"Олег Викторович Орлов","Position":"Директор","Phone":"+7(900)555-00-00","Login":"director_demo","IsActive":true}',N'{"EmployeeID":7,"RoleID":7,"FullName":"Олег Викторович Орлов","Position":"Директор","Phone":"+7(900)555-00-00","Login":"director_demo","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (172,CONVERT(datetime2(7),N'2026-10-17T16:36:57.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'8',N'UPDATE',N'{"EmployeeID":8,"RoleID":3,"FullName":"Максим Андреевич Белов","Position":"Менеджер отдела продаж","Phone":"+7(900)555-00-00","Login":"sales_demo","IsActive":true}',N'{"EmployeeID":8,"RoleID":3,"FullName":"Максим Андреевич Белов","Position":"Менеджер отдела продаж","Phone":"+7(900)555-00-00","Login":"sales_demo","IsActive":true}')
GO
INSERT [dbo].[AuditLog] ([AuditID],[EventTime],[SqlLogin],[ActorEmployeeID],[TableName],[RecordID],[ActionName],[OldData],[NewData]) VALUES (173,CONVERT(datetime2(7),N'2026-10-17T16:36:57.0000000',126),N'DESKTOP-5Q6T8JB\bebreef',NULL,N'Employees',N'9',N'UPDATE',N'{"EmployeeID":9,"RoleID":5,"FullName":"Павел Сергеевич Громов","Position":"Автомеханик","Phone":"+7(900)555-00-00","Login":"mechanic_demo","IsActive":true}',N'{"EmployeeID":9,"RoleID":5,"FullName":"Павел Сергеевич Громов","Position":"Автомеханик","Phone":"+7(900)555-00-00","Login":"mechanic_demo","IsActive":true}')
GO
SET IDENTITY_INSERT [dbo].[AuditLog] OFF
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'JHMCR2850BC000003',N'Honda',N'CR-V',2026,N'Черный',10,4200000.00,N'Зарезервирован')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000001',N'Lada',N'Vesta',2025,N'Белый',2100,1850000.00,N'Продан')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000002',N'Lada',N'Niva Travel',2026,N'Черный',0,1650000.00,N'Продан')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000003',N'Toyota',N'Camry',2023,N'Серый',6300,3800000.00,N'Продан')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000004',N'Toyota',N'RAV4',2024,N'Синий',8400,4500000.00,N'Продан')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000005',N'Kia',N'Rio',2021,N'Красный',10500,1700000.00,N'Продан')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000006',N'Kia',N'Sportage',2022,N'Серебристый',12600,3100000.00,N'Продан')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000007',N'Hyundai',N'Solaris',2020,N'Белый',14700,1500000.00,N'Продан')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000008',N'Hyundai',N'Tucson',2023,N'Черный',16800,3400000.00,N'Продан')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000009',N'Skoda',N'Octavia',2021,N'Серый',18900,2200000.00,N'Продан')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000010',N'Skoda',N'Kodiaq',2022,N'Синий',21000,3500000.00,N'Продан')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000011',N'Volkswagen',N'Tiguan',2021,N'Красный',23100,3200000.00,N'Зарезервирован')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000012',N'Renault',N'Duster',2020,N'Серебристый',25200,1800000.00,N'Зарезервирован')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000013',N'Nissan',N'Qashqai',2022,N'Белый',27300,2700000.00,N'Зарезервирован')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000014',N'Mazda',N'CX-5',2023,N'Черный',29400,3600000.00,N'Зарезервирован')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000015',N'Chery',N'Tiggo 7 Pro',2025,N'Серый',31500,2800000.00,N'На складе')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000016',N'Haval',N'Jolion',2026,N'Синий',0,2450000.00,N'На складе')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000017',N'Geely',N'Coolray',2025,N'Красный',35700,2600000.00,N'На складе')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000018',N'Changan',N'CS55 Plus',2026,N'Серебристый',0,2900000.00,N'На складе')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000019',N'BMW',N'320i',2021,N'Белый',39900,4100000.00,N'На складе')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000020',N'Mercedes-Benz',N'C180',2020,N'Черный',42000,3900000.00,N'На складе')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000021',N'Audi',N'A4',2022,N'Серый',44100,4300000.00,N'На складе')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000022',N'Lexus',N'NX',2023,N'Синий',46200,5200000.00,N'В пути')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000023',N'Honda',N'Civic',2021,N'Красный',48300,2500000.00,N'В пути')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'TST00000000000024',N'Suzuki',N'Vitara',2022,N'Серебристый',50400,2400000.00,N'На диагностике')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'XTA219000H0000001',N'Lada',N'Granta',2026,N'Белый',0,950000.00,N'На складе')
GO
INSERT [dbo].[Cars] ([VIN],[Brand],[Model],[Year],[Color],[Kilomitrage],[Price],[Status]) VALUES (N'XW8ZZZ1KZH0000002',N'Volkswagen',N'Polo',2024,N'Серебристый',45000,1500000.00,N'Продан')
GO
SET IDENTITY_INSERT [dbo].[Clients] ON
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (1,N'Александров Александр',N'+7(900)123-45-67',N'45 10 123456',N'alex@email.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (2,N'Екатерина Великая',N'+7(900)987-65-43',N'45 12 654321',N'kate@email.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (3,N'Иванов Иван Петрович',N'+7(901)000-01-00',N'99 99 000001',N'client01@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (4,N'Петрова Мария Сергеевна',N'+7(901)000-02-00',N'99 99 000002',N'client02@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (5,N'Смирнов Алексей Викторович',N'+7(901)000-03-00',N'99 99 000003',N'client03@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (6,N'Кузнецова Елена Андреевна',N'+7(901)000-04-00',N'99 99 000004',N'client04@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (7,N'Попов Дмитрий Олегович',N'+7(901)000-05-00',N'99 99 000005',N'client05@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (8,N'Васильева Анна Игоревна',N'+7(901)000-06-00',N'99 99 000006',N'client06@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (9,N'Соколов Николай Павлович',N'+7(901)000-07-00',N'99 99 000007',N'client07@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (10,N'Михайлова Ольга Романовна',N'+7(901)000-08-00',N'99 99 000008',N'client08@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (11,N'Новиков Артем Денисович',N'+7(901)000-09-00',N'99 99 000009',N'client09@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (12,N'Федорова Софья Максимовна',N'+7(901)000-10-00',N'99 99 000010',N'client10@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (13,N'Морозов Михаил Юрьевич',N'+7(901)000-11-00',N'99 99 000011',N'client11@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (14,N'Волкова Дарья Никитична',N'+7(901)000-12-00',N'99 99 000012',N'client12@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (15,N'Алексеев Денис Сергеевич',N'+7(901)000-13-00',N'99 99 000013',N'client13@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (16,N'Лебедева Полина Вадимовна',N'+7(901)000-14-00',N'99 99 000014',N'client14@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (17,N'Семенов Кирилл Александрович',N'+7(901)000-15-00',N'99 99 000015',N'client15@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (18,N'Егорова Виктория Леонидовна',N'+7(901)000-16-00',N'99 99 000016',N'client16@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (19,N'Павлов Роман Михайлович',N'+7(901)000-17-00',N'99 99 000017',N'client17@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (20,N'Козлова Алина Евгеньевна',N'+7(901)000-18-00',N'99 99 000018',N'client18@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (21,N'Степанов Андрей Ильич',N'+7(901)000-19-00',N'99 99 000019',N'client19@example.com',1)
GO
INSERT [dbo].[Clients] ([ClientID],[FullName],[Phone],[Passport],[Email],[IsActive]) VALUES (22,N'Николаева Ксения Олеговна',N'+7(901)000-20-00',N'99 99 000020',N'client20@example.com',1)
GO
SET IDENTITY_INSERT [dbo].[Clients] OFF
GO
SET IDENTITY_INSERT [dbo].[Deals] ON
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (1,N'XW8ZZZ1KZH0000002',1,3,CONVERT(datetime2(7),N'2026-06-10T14:30:00.0000000',126),1450000.00,N'Исполнен')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (2,N'JHMCR2850BC000003',1,3,CONVERT(datetime2(7),N'2026-09-01T00:00:00.0000000',126),4200000.00,N'Зарезервирован')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (3,N'TST00000000000001',3,3,CONVERT(datetime2(7),N'2026-07-05T00:00:00.0000000',126),1800000.00,N'Исполнен')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (4,N'TST00000000000002',4,3,CONVERT(datetime2(7),N'2026-07-09T00:00:00.0000000',126),1600000.00,N'Исполнен')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (5,N'TST00000000000003',5,3,CONVERT(datetime2(7),N'2026-07-13T00:00:00.0000000',126),3750000.00,N'Исполнен')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (6,N'TST00000000000004',6,3,CONVERT(datetime2(7),N'2026-07-17T00:00:00.0000000',126),4450000.00,N'Исполнен')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (7,N'TST00000000000005',7,3,CONVERT(datetime2(7),N'2026-07-21T00:00:00.0000000',126),1650000.00,N'Исполнен')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (8,N'TST00000000000006',8,3,CONVERT(datetime2(7),N'2026-07-25T00:00:00.0000000',126),3050000.00,N'Исполнен')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (9,N'TST00000000000007',9,3,CONVERT(datetime2(7),N'2026-07-29T00:00:00.0000000',126),1450000.00,N'Исполнен')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (10,N'TST00000000000008',10,3,CONVERT(datetime2(7),N'2026-08-02T00:00:00.0000000',126),3350000.00,N'Исполнен')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (11,N'TST00000000000009',11,3,CONVERT(datetime2(7),N'2026-08-06T00:00:00.0000000',126),2150000.00,N'Исполнен')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (12,N'TST00000000000010',12,3,CONVERT(datetime2(7),N'2026-08-10T00:00:00.0000000',126),3450000.00,N'Исполнен')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (13,N'TST00000000000011',13,3,CONVERT(datetime2(7),N'2026-08-14T00:00:00.0000000',126),3150000.00,N'Зарезервирован')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (14,N'TST00000000000012',14,3,CONVERT(datetime2(7),N'2026-08-18T00:00:00.0000000',126),1750000.00,N'Зарезервирован')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (15,N'TST00000000000013',15,3,CONVERT(datetime2(7),N'2026-08-22T00:00:00.0000000',126),2650000.00,N'Зарезервирован')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (16,N'TST00000000000014',16,3,CONVERT(datetime2(7),N'2026-08-26T00:00:00.0000000',126),3550000.00,N'Зарезервирован')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (17,N'TST00000000000015',17,3,CONVERT(datetime2(7),N'2026-08-30T00:00:00.0000000',126),2750000.00,N'Черновик')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (18,N'TST00000000000016',18,3,CONVERT(datetime2(7),N'2026-09-03T00:00:00.0000000',126),2400000.00,N'Черновик')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (19,N'TST00000000000017',19,3,CONVERT(datetime2(7),N'2026-09-07T00:00:00.0000000',126),2550000.00,N'Отменен')
GO
INSERT [dbo].[Deals] ([DealID],[VIN],[ClientID],[EmployeeID],[DealDate],[FinalPrice],[ContractStatus]) VALUES (20,N'TST00000000000018',20,3,CONVERT(datetime2(7),N'2026-09-11T00:00:00.0000000',126),2850000.00,N'Отменен')
GO
SET IDENTITY_INSERT [dbo].[Deals] OFF
GO
SET IDENTITY_INSERT [dbo].[Deliveries] ON
GO
INSERT [dbo].[Deliveries] ([DeliveryID],[SupplierID],[EmployeeID],[DeliveryDate],[WaybillNumber],[Status]) VALUES (1,1,4,CONVERT(datetime2(7),N'2026-06-01T09:15:00.0000000',126),N'ТТН-1045-2026',N'Проведена')
GO
INSERT [dbo].[Deliveries] ([DeliveryID],[SupplierID],[EmployeeID],[DeliveryDate],[WaybillNumber],[Status]) VALUES (2,2,4,CONVERT(datetime2(7),N'2026-06-05T11:00:00.0000000',126),N'ТТН-523-ЮГ',N'Проведена')
GO
INSERT [dbo].[Deliveries] ([DeliveryID],[SupplierID],[EmployeeID],[DeliveryDate],[WaybillNumber],[Status]) VALUES (3,3,4,CONVERT(datetime2(7),N'2026-08-06T00:00:00.0000000',126),N'DEMO-TTN-001',N'Проведена')
GO
INSERT [dbo].[Deliveries] ([DeliveryID],[SupplierID],[EmployeeID],[DeliveryDate],[WaybillNumber],[Status]) VALUES (4,4,4,CONVERT(datetime2(7),N'2026-08-11T00:00:00.0000000',126),N'DEMO-TTN-002',N'Проведена')
GO
INSERT [dbo].[Deliveries] ([DeliveryID],[SupplierID],[EmployeeID],[DeliveryDate],[WaybillNumber],[Status]) VALUES (5,5,4,CONVERT(datetime2(7),N'2026-08-16T00:00:00.0000000',126),N'DEMO-TTN-003',N'Проведена')
GO
INSERT [dbo].[Deliveries] ([DeliveryID],[SupplierID],[EmployeeID],[DeliveryDate],[WaybillNumber],[Status]) VALUES (6,3,4,CONVERT(datetime2(7),N'2026-08-21T00:00:00.0000000',126),N'DEMO-TTN-004',N'Проведена')
GO
INSERT [dbo].[Deliveries] ([DeliveryID],[SupplierID],[EmployeeID],[DeliveryDate],[WaybillNumber],[Status]) VALUES (7,4,4,CONVERT(datetime2(7),N'2026-08-26T00:00:00.0000000',126),N'DEMO-TTN-005',N'Проведена')
GO
INSERT [dbo].[Deliveries] ([DeliveryID],[SupplierID],[EmployeeID],[DeliveryDate],[WaybillNumber],[Status]) VALUES (8,5,4,CONVERT(datetime2(7),N'2026-08-31T00:00:00.0000000',126),N'DEMO-TTN-006',N'Проведена')
GO
INSERT [dbo].[Deliveries] ([DeliveryID],[SupplierID],[EmployeeID],[DeliveryDate],[WaybillNumber],[Status]) VALUES (9,3,4,CONVERT(datetime2(7),N'2026-09-05T00:00:00.0000000',126),N'DEMO-TTN-007',N'Проведена')
GO
INSERT [dbo].[Deliveries] ([DeliveryID],[SupplierID],[EmployeeID],[DeliveryDate],[WaybillNumber],[Status]) VALUES (10,4,4,CONVERT(datetime2(7),N'2026-09-10T00:00:00.0000000',126),N'DEMO-TTN-008',N'Проведена')
GO
INSERT [dbo].[Deliveries] ([DeliveryID],[SupplierID],[EmployeeID],[DeliveryDate],[WaybillNumber],[Status]) VALUES (11,5,4,CONVERT(datetime2(7),N'2026-09-15T00:00:00.0000000',126),N'DEMO-TTN-009',N'Черновик')
GO
INSERT [dbo].[Deliveries] ([DeliveryID],[SupplierID],[EmployeeID],[DeliveryDate],[WaybillNumber],[Status]) VALUES (12,3,4,CONVERT(datetime2(7),N'2026-09-20T00:00:00.0000000',126),N'DEMO-TTN-010',N'Черновик')
GO
SET IDENTITY_INSERT [dbo].[Deliveries] OFF
GO
SET IDENTITY_INSERT [dbo].[DeliveryParts] ON
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (1,1,1,20,2200.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (2,1,2,20,300.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (3,2,3,10,1500.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (4,3,7,13,5950.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (5,3,8,14,3150.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (6,3,9,15,1260.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (7,4,10,14,1120.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (8,4,11,15,525.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (9,4,12,16,840.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (10,5,13,15,385.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (11,5,14,16,4340.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (12,5,15,17,2240.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (13,6,4,16,630.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (14,6,5,17,770.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (15,6,6,18,455.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (16,7,7,17,5950.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (17,7,8,18,3150.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (18,7,9,19,1260.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (19,8,10,18,1120.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (20,8,11,19,525.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (21,8,12,20,840.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (22,9,13,19,385.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (23,9,14,20,4340.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (24,9,15,21,2240.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (25,10,4,20,630.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (26,10,5,21,770.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (27,10,6,22,455.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (28,11,7,2,5950.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (29,11,8,3,3150.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (30,11,9,4,1260.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (31,12,10,2,1120.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (32,12,11,3,525.00)
GO
INSERT [dbo].[DeliveryParts] ([DeliveryPartID],[DeliveryID],[PartID],[Quantity],[PurchasePrice]) VALUES (33,12,12,4,840.00)
GO
SET IDENTITY_INSERT [dbo].[DeliveryParts] OFF
GO
SET IDENTITY_INSERT [dbo].[Employees] ON
GO
INSERT [dbo].[Employees] ([EmployeeID],[RoleID],[FullName],[Position],[Phone],[Login],[PasswordHash],[IsActive]) VALUES (1,1,N'Михаил Волков',N'Системный администратор',N'+7(999)123-45-67',N'mvolkov',N'PBKDF2-SHA256$600000$He5MwIoS2ra8ELlwwGmQ/A==$WC1+g8X9DPo8VvTbOaVD+tsE3xDAdptYXA75H+x1wDk=',1)
GO
INSERT [dbo].[Employees] ([EmployeeID],[RoleID],[FullName],[Position],[Phone],[Login],[PasswordHash],[IsActive]) VALUES (2,2,N'Сергей Соколов',N'Старший мастер-приемщик',N'+7(999)234-56-78',N'ssokolov',N'PBKDF2-SHA256$600000$HZR643cG37VpBfuPsQe0pQ==$TbdweXu46OFm3pUY35rl0vlIaUgs3MtGgzHbqBFp7V4=',1)
GO
INSERT [dbo].[Employees] ([EmployeeID],[RoleID],[FullName],[Position],[Phone],[Login],[PasswordHash],[IsActive]) VALUES (3,3,N'Анна Кузнецова',N'Менеджер отдела продаж',N'+7(999)345-67-89',N'akuznetsova',N'PBKDF2-SHA256$600000$mWAHQTUqYZOwJM+MYa5PRQ==$bPxFHXCFT42VJx3auTozM+OnGhJP8ooynm3cxELs8H4=',1)
GO
INSERT [dbo].[Employees] ([EmployeeID],[RoleID],[FullName],[Position],[Phone],[Login],[PasswordHash],[IsActive]) VALUES (4,4,N'Дмитрий Лебедев',N'Начальник склада',N'+7(999)456-78-90',N'dlebedev',N'PBKDF2-SHA256$600000$Pw77JQ+qYQTyF5U6ZZLC4g==$Mc9leR2t5R7u5HAze5WgqtB34lvA3GLjssITFDT0uh0=',1)
GO
INSERT [dbo].[Employees] ([EmployeeID],[RoleID],[FullName],[Position],[Phone],[Login],[PasswordHash],[IsActive]) VALUES (5,5,N'Евгений Морозов',N'Слесарь-механик',N'+7(999)567-89-01',N'emorozov',N'PBKDF2-SHA256$600000$QRldqUU3ekmvYACUGeDGew==$VjSatx9bCFTcxIoQpnWt5eYEmaoelPkdrSRSTNmLewg=',1)
GO
INSERT [dbo].[Employees] ([EmployeeID],[RoleID],[FullName],[Position],[Phone],[Login],[PasswordHash],[IsActive]) VALUES (6,6,N'Тестовый пользователь',N'Наблюдатель',N'+7(900)555-00-00',N'user_demo',N'PBKDF2-SHA256$600000$wLRYsy/EC4B9Oye+Aj5p7g==$8Gki1AMErWyx65OfxaIGucETIn4FOaNziuj0d7+pGfE=',1)
GO
INSERT [dbo].[Employees] ([EmployeeID],[RoleID],[FullName],[Position],[Phone],[Login],[PasswordHash],[IsActive]) VALUES (7,7,N'Олег Викторович Орлов',N'Директор',N'+7(900)555-00-00',N'director_demo',N'PBKDF2-SHA256$600000$a4Bcmzy64QvbNOic7vGQtg==$1MMjXHtV2flpKU6ZNPQsG9kbegoSmk4YHZnzZckh0GQ=',1)
GO
INSERT [dbo].[Employees] ([EmployeeID],[RoleID],[FullName],[Position],[Phone],[Login],[PasswordHash],[IsActive]) VALUES (8,3,N'Максим Андреевич Белов',N'Менеджер отдела продаж',N'+7(900)555-00-00',N'sales_demo',N'PBKDF2-SHA256$600000$oiK398Njhx3qWzT9Euln2w==$LXdUZh5KHqd3W9AIhKD9JKpoJcJH1fro5cSuY8OAVSk=',1)
GO
INSERT [dbo].[Employees] ([EmployeeID],[RoleID],[FullName],[Position],[Phone],[Login],[PasswordHash],[IsActive]) VALUES (9,5,N'Павел Сергеевич Громов',N'Автомеханик',N'+7(900)555-00-00',N'mechanic_demo',N'PBKDF2-SHA256$600000$LmkIaVD2tUo5k8PpM8zz9w==$m+wjK7oVLTaXwcvwdWDIadHFh6sJYx7GjkX/e9KApXk=',1)
GO
SET IDENTITY_INSERT [dbo].[Employees] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderParts] ON
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (1,1,3,1,2500.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (2,2,4,1,900.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (3,3,5,1,1100.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (4,4,6,1,650.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (5,5,7,1,8500.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (6,6,8,1,4500.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (7,7,9,1,1800.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (8,8,10,1,1600.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (9,9,11,1,750.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (10,10,12,1,1200.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (11,11,13,1,550.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (12,12,14,1,6200.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (13,13,15,1,3200.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (14,14,4,1,900.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (15,15,5,1,1100.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (16,16,6,1,650.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (17,17,7,1,8500.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (18,18,8,1,4500.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (19,19,9,1,1800.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (20,20,10,1,1600.00)
GO
INSERT [dbo].[OrderParts] ([OrderPartID],[OrderID],[PartID],[Quantity],[PriceAtMoment]) VALUES (21,21,11,1,750.00)
GO
SET IDENTITY_INSERT [dbo].[OrderParts] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderWorks] ON
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (1,1,3,5,1.00,2000.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (2,2,4,5,0.30,2000.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (3,3,5,5,0.80,2200.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (4,4,6,5,0.40,2000.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (5,5,7,5,1.50,2300.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (6,6,8,5,1.00,2100.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (7,7,9,5,2.00,2400.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (8,8,10,5,0.70,2200.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (9,9,11,5,1.20,2300.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (10,10,4,5,0.30,2000.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (11,11,5,5,0.80,2200.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (12,12,6,5,0.40,2000.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (13,13,7,5,1.50,2300.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (14,14,8,5,1.00,2100.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (15,15,9,5,2.00,2400.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (16,16,10,5,0.70,2200.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (17,17,11,5,1.20,2300.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (18,18,4,5,0.30,2000.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (19,19,5,5,0.80,2200.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (20,20,6,5,0.40,2000.00)
GO
INSERT [dbo].[OrderWorks] ([OrderWorkID],[OrderID],[ServiceID],[EmployeeID],[FactHours],[CostPerHourAtMoment]) VALUES (21,21,7,5,1.50,2300.00)
GO
SET IDENTITY_INSERT [dbo].[OrderWorks] OFF
GO
SET IDENTITY_INSERT [dbo].[Parts] ON
GO
INSERT [dbo].[Parts] ([PartID],[Article],[PartName],[RetailPrice],[MinStockLevel],[CurrentStock],[IsActive]) VALUES (1,N'OIL-5W40-4L',N'Масло моторное синтетическое 5W-40 4л',3500.00,10,25,1)
GO
INSERT [dbo].[Parts] ([PartID],[Article],[PartName],[RetailPrice],[MinStockLevel],[CurrentStock],[IsActive]) VALUES (2,N'FIL-001-OIL',N'Фильтр масляный',500.00,15,30,1)
GO
INSERT [dbo].[Parts] ([PartID],[Article],[PartName],[RetailPrice],[MinStockLevel],[CurrentStock],[IsActive]) VALUES (3,N'BRK-PAD-FR',N'Колодки тормозные передние (комплект)',2500.00,5,8,1)
GO
INSERT [dbo].[Parts] ([PartID],[Article],[PartName],[RetailPrice],[MinStockLevel],[CurrentStock],[IsActive]) VALUES (4,N'DEMO-PART-001',N'Фильтр воздушный',900.00,100,35,1)
GO
INSERT [dbo].[Parts] ([PartID],[Article],[PartName],[RetailPrice],[MinStockLevel],[CurrentStock],[IsActive]) VALUES (5,N'DEMO-PART-002',N'Фильтр салонный',1100.00,100,37,1)
GO
INSERT [dbo].[Parts] ([PartID],[Article],[PartName],[RetailPrice],[MinStockLevel],[CurrentStock],[IsActive]) VALUES (6,N'DEMO-PART-003',N'Свеча зажигания',650.00,16,39,1)
GO
INSERT [dbo].[Parts] ([PartID],[Article],[PartName],[RetailPrice],[MinStockLevel],[CurrentStock],[IsActive]) VALUES (7,N'DEMO-PART-004',N'Аккумулятор 60 А·ч',8500.00,3,29,1)
GO
INSERT [dbo].[Parts] ([PartID],[Article],[PartName],[RetailPrice],[MinStockLevel],[CurrentStock],[IsActive]) VALUES (8,N'DEMO-PART-005',N'Диск тормозной передний',4500.00,4,31,1)
GO
INSERT [dbo].[Parts] ([PartID],[Article],[PartName],[RetailPrice],[MinStockLevel],[CurrentStock],[IsActive]) VALUES (9,N'DEMO-PART-006',N'Ремень приводной',1800.00,5,33,1)
GO
INSERT [dbo].[Parts] ([PartID],[Article],[PartName],[RetailPrice],[MinStockLevel],[CurrentStock],[IsActive]) VALUES (10,N'DEMO-PART-007',N'Антифриз 5 л',1600.00,6,31,1)
GO
INSERT [dbo].[Parts] ([PartID],[Article],[PartName],[RetailPrice],[MinStockLevel],[CurrentStock],[IsActive]) VALUES (11,N'DEMO-PART-008',N'Жидкость тормозная 1 л',750.00,6,33,1)
GO
INSERT [dbo].[Parts] ([PartID],[Article],[PartName],[RetailPrice],[MinStockLevel],[CurrentStock],[IsActive]) VALUES (12,N'DEMO-PART-009',N'Щетка стеклоочистителя',1200.00,8,35,1)
GO
INSERT [dbo].[Parts] ([PartID],[Article],[PartName],[RetailPrice],[MinStockLevel],[CurrentStock],[IsActive]) VALUES (13,N'DEMO-PART-010',N'Лампа ближнего света',550.00,10,33,1)
GO
INSERT [dbo].[Parts] ([PartID],[Article],[PartName],[RetailPrice],[MinStockLevel],[CurrentStock],[IsActive]) VALUES (14,N'DEMO-PART-011',N'Амортизатор передний',6200.00,4,36,1)
GO
INSERT [dbo].[Parts] ([PartID],[Article],[PartName],[RetailPrice],[MinStockLevel],[CurrentStock],[IsActive]) VALUES (15,N'DEMO-PART-012',N'Подшипник ступицы',3200.00,4,38,1)
GO
SET IDENTITY_INSERT [dbo].[Parts] OFF
GO
SET IDENTITY_INSERT [dbo].[Roles] ON
GO
INSERT [dbo].[Roles] ([RoleID],[RoleName]) VALUES (5,N'Автомеханик')
GO
INSERT [dbo].[Roles] ([RoleID],[RoleName]) VALUES (1,N'Администратор')
GO
INSERT [dbo].[Roles] ([RoleID],[RoleName]) VALUES (4,N'Кладовщик')
GO
INSERT [dbo].[Roles] ([RoleID],[RoleName]) VALUES (2,N'Мастер-приемщик')
GO
INSERT [dbo].[Roles] ([RoleID],[RoleName]) VALUES (3,N'Менеджер по продажам')
GO
INSERT [dbo].[Roles] ([RoleID],[RoleName]) VALUES (6,N'Пользователь')
GO
INSERT [dbo].[Roles] ([RoleID],[RoleName]) VALUES (7,N'Руководитель')
GO
SET IDENTITY_INSERT [dbo].[Roles] OFF
GO
INSERT [dbo].[SchemaMigrations] ([MigrationID],[AppliedAt]) VALUES (N'20261005_AutoDealer_v1',CONVERT(datetime2(7),N'2026-10-05T17:37:20.0000000',126))
GO
SET IDENTITY_INSERT [dbo].[ServiceOrders] ON
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (1,N'XTA219000H0000001',2,2,CONVERT(datetime2(7),N'2026-06-15T10:00:00.0000000',126),N'Скрип при торможении.',N'Закрыт',4500.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (2,N'TST00000000000001',3,2,CONVERT(datetime2(7),N'2026-08-04T00:00:00.0000000',126),N'Плановое техническое обслуживание.',N'Закрыт',1500.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (3,N'TST00000000000002',4,2,CONVERT(datetime2(7),N'2026-08-07T00:00:00.0000000',126),N'Шум при движении.',N'Закрыт',2860.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (4,N'TST00000000000003',5,2,CONVERT(datetime2(7),N'2026-08-10T00:00:00.0000000',126),N'Проверка перед дальней поездкой.',N'Закрыт',1450.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (5,N'TST00000000000004',6,2,CONVERT(datetime2(7),N'2026-08-13T00:00:00.0000000',126),N'Замена расходных материалов.',N'Закрыт',11950.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (6,N'TST00000000000005',7,2,CONVERT(datetime2(7),N'2026-08-16T00:00:00.0000000',126),N'Плановое техническое обслуживание.',N'Закрыт',6600.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (7,N'TST00000000000006',8,2,CONVERT(datetime2(7),N'2026-08-19T00:00:00.0000000',126),N'Шум при движении.',N'Закрыт',6600.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (8,N'TST00000000000007',9,2,CONVERT(datetime2(7),N'2026-08-22T00:00:00.0000000',126),N'Проверка перед дальней поездкой.',N'Закрыт',3140.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (9,N'TST00000000000008',10,2,CONVERT(datetime2(7),N'2026-08-25T00:00:00.0000000',126),N'Замена расходных материалов.',N'Закрыт',3510.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (10,N'TST00000000000009',11,2,CONVERT(datetime2(7),N'2026-08-28T00:00:00.0000000',126),N'Плановое техническое обслуживание.',N'Закрыт',1800.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (11,N'TST00000000000010',12,2,CONVERT(datetime2(7),N'2026-08-31T00:00:00.0000000',126),N'Шум при движении.',N'Закрыт',2310.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (12,N'TST00000000000011',13,2,CONVERT(datetime2(7),N'2026-09-03T00:00:00.0000000',126),N'Проверка перед дальней поездкой.',N'В работе',7000.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (13,N'TST00000000000012',14,2,CONVERT(datetime2(7),N'2026-09-06T00:00:00.0000000',126),N'Замена расходных материалов.',N'В работе',6650.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (14,N'TST00000000000013',15,2,CONVERT(datetime2(7),N'2026-09-09T00:00:00.0000000',126),N'Плановое техническое обслуживание.',N'В работе',3000.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (15,N'TST00000000000014',16,2,CONVERT(datetime2(7),N'2026-09-12T00:00:00.0000000',126),N'Шум при движении.',N'В работе',5900.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (16,N'TST00000000000015',17,2,CONVERT(datetime2(7),N'2026-09-15T00:00:00.0000000',126),N'Проверка перед дальней поездкой.',N'В работе',2190.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (17,N'TST00000000000016',18,2,CONVERT(datetime2(7),N'2026-09-18T00:00:00.0000000',126),N'Замена расходных материалов.',N'Открыт',11260.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (18,N'TST00000000000017',19,2,CONVERT(datetime2(7),N'2026-09-21T00:00:00.0000000',126),N'Плановое техническое обслуживание.',N'Открыт',5100.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (19,N'TST00000000000018',20,2,CONVERT(datetime2(7),N'2026-09-24T00:00:00.0000000',126),N'Шум при движении.',N'Открыт',3560.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (20,N'TST00000000000019',21,2,CONVERT(datetime2(7),N'2026-09-27T00:00:00.0000000',126),N'Проверка перед дальней поездкой.',N'Отменен',2400.00)
GO
INSERT [dbo].[ServiceOrders] ([OrderID],[VIN],[ClientID],[EmployeeID],[OrderDate],[IssueDescription],[Status],[TotalCost]) VALUES (21,N'TST00000000000020',22,2,CONVERT(datetime2(7),N'2026-09-30T00:00:00.0000000',126),N'Замена расходных материалов.',N'Отменен',4200.00)
GO
SET IDENTITY_INSERT [dbo].[ServiceOrders] OFF
GO
SET IDENTITY_INSERT [dbo].[Services] ON
GO
INSERT [dbo].[Services] ([ServiceID],[ServiceName],[StandardHours],[CostPerHour],[IsActive]) VALUES (1,N'Регламентное ТО (замена масла и фильтров)',1.50,2000.00,1)
GO
INSERT [dbo].[Services] ([ServiceID],[ServiceName],[StandardHours],[CostPerHour],[IsActive]) VALUES (2,N'Компьютерная диагностика ДВС',0.50,2500.00,1)
GO
INSERT [dbo].[Services] ([ServiceID],[ServiceName],[StandardHours],[CostPerHour],[IsActive]) VALUES (3,N'Замена передних тормозных колодок',1.00,2000.00,1)
GO
INSERT [dbo].[Services] ([ServiceID],[ServiceName],[StandardHours],[CostPerHour],[IsActive]) VALUES (4,N'Замена воздушного фильтра',0.30,2000.00,1)
GO
INSERT [dbo].[Services] ([ServiceID],[ServiceName],[StandardHours],[CostPerHour],[IsActive]) VALUES (5,N'Замена свечей зажигания',0.80,2200.00,1)
GO
INSERT [dbo].[Services] ([ServiceID],[ServiceName],[StandardHours],[CostPerHour],[IsActive]) VALUES (6,N'Замена аккумулятора',0.40,2000.00,1)
GO
INSERT [dbo].[Services] ([ServiceID],[ServiceName],[StandardHours],[CostPerHour],[IsActive]) VALUES (7,N'Замена тормозных дисков',1.50,2300.00,1)
GO
INSERT [dbo].[Services] ([ServiceID],[ServiceName],[StandardHours],[CostPerHour],[IsActive]) VALUES (8,N'Замена антифриза',1.00,2100.00,1)
GO
INSERT [dbo].[Services] ([ServiceID],[ServiceName],[StandardHours],[CostPerHour],[IsActive]) VALUES (9,N'Замена амортизаторов',2.00,2400.00,1)
GO
INSERT [dbo].[Services] ([ServiceID],[ServiceName],[StandardHours],[CostPerHour],[IsActive]) VALUES (10,N'Диагностика подвески',0.70,2200.00,1)
GO
INSERT [dbo].[Services] ([ServiceID],[ServiceName],[StandardHours],[CostPerHour],[IsActive]) VALUES (11,N'Замена приводного ремня',1.20,2300.00,1)
GO
SET IDENTITY_INSERT [dbo].[Services] OFF
GO
SET IDENTITY_INSERT [dbo].[StockMovements] ON
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (1,1,25,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'Начальный остаток',NULL)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (2,2,30,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'Начальный остаток',NULL)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (3,3,8,CONVERT(datetime2(7),N'2026-10-05T17:37:18.0000000',126),N'Начальный остаток',NULL)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (4,7,13,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',3)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (5,8,14,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',3)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (6,9,15,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',3)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (7,10,14,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',4)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (8,11,15,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',4)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (9,12,16,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',4)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (10,13,15,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',5)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (11,14,16,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',5)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (12,15,17,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',5)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (13,4,16,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',6)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (14,5,17,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',6)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (15,6,18,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',6)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (16,7,17,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',7)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (17,8,18,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',7)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (18,9,19,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',7)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (19,10,18,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',8)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (20,11,19,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',8)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (21,12,20,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',8)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (22,13,19,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',9)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (23,14,20,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',9)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (24,15,21,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',9)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (25,4,20,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',10)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (26,5,21,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',10)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (27,6,22,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Поставка',10)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (28,4,-1,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Заказ-наряд',2)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (29,5,-1,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Заказ-наряд',3)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (30,6,-1,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Заказ-наряд',4)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (31,7,-1,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Заказ-наряд',5)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (32,8,-1,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Заказ-наряд',6)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (33,9,-1,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Заказ-наряд',7)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (34,10,-1,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Заказ-наряд',8)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (35,11,-1,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Заказ-наряд',9)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (36,12,-1,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Заказ-наряд',10)
GO
INSERT [dbo].[StockMovements] ([MovementID],[PartID],[QuantityDelta],[MovementDate],[SourceType],[SourceID]) VALUES (37,13,-1,CONVERT(datetime2(7),N'2026-10-05T17:37:19.0000000',126),N'Заказ-наряд',11)
GO
SET IDENTITY_INSERT [dbo].[StockMovements] OFF
GO
SET IDENTITY_INSERT [dbo].[Suppliers] ON
GO
INSERT [dbo].[Suppliers] ([SupplierID],[SupplierName],[ContactPhone],[LegalAddress],[IsActive]) VALUES (1,N'ООО "АвтоОптСнаб"',N'+7(495)111-22-33',N'г. Москва, ул. Складская, 1',1)
GO
INSERT [dbo].[Suppliers] ([SupplierID],[SupplierName],[ContactPhone],[LegalAddress],[IsActive]) VALUES (2,N'ЗАО "Детали-ЮГ"',N'+7(861)222-33-44',N'г. Краснодар, пр-т Индустриальный, 5',1)
GO
INSERT [dbo].[Suppliers] ([SupplierID],[SupplierName],[ContactPhone],[LegalAddress],[IsActive]) VALUES (3,N'ООО «Тест АвтоКомплект»',N'+7(495)000-00-01',N'Москва, Тестовая улица, 1',1)
GO
INSERT [dbo].[Suppliers] ([SupplierID],[SupplierName],[ContactPhone],[LegalAddress],[IsActive]) VALUES (4,N'ООО «Тест МоторПартс»',N'+7(495)000-00-02',N'Москва, Тестовая улица, 2',1)
GO
INSERT [dbo].[Suppliers] ([SupplierID],[SupplierName],[ContactPhone],[LegalAddress],[IsActive]) VALUES (5,N'ООО «Тест СервисСнаб»',N'+7(495)000-00-03',N'Москва, Тестовая улица, 3',1)
GO
SET IDENTITY_INSERT [dbo].[Suppliers] OFF
GO
/****** Object:  Index [IX_AuditLog_Time]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_AuditLog_Time] ON [dbo].[AuditLog]
(
	[EventTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Cars_Search]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_Cars_Search] ON [dbo].[Cars]
(
	[Brand] ASC,
	[Model] ASC,
	[Status] ASC
)
INCLUDE([Year],[Price],[Kilomitrage]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Clients_Phone]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_Clients_Phone] ON [dbo].[Clients]
(
	[Phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Deals_Client]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_Deals_Client] ON [dbo].[Deals]
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Deals_EmployeeDate]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_Deals_EmployeeDate] ON [dbo].[Deals]
(
	[EmployeeID] ASC,
	[DealDate] ASC
)
INCLUDE([FinalPrice],[ContractStatus]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Deals_ActiveVIN]    Script Date: 17.10.2026 16:24:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Deals_ActiveVIN] ON [dbo].[Deals]
(
	[VIN] ASC
)
WHERE ([ContractStatus] IN (N'Зарезервирован', N'Исполнен'))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Deliveries_Employee]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_Deliveries_Employee] ON [dbo].[Deliveries]
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Deliveries_SupplierDate]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_Deliveries_SupplierDate] ON [dbo].[Deliveries]
(
	[SupplierID] ASC,
	[DeliveryDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_DeliveryParts_Part]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_DeliveryParts_Part] ON [dbo].[DeliveryParts]
(
	[PartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UX_DeliveryParts_Line]    Script Date: 17.10.2026 16:24:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_DeliveryParts_Line] ON [dbo].[DeliveryParts]
(
	[DeliveryID] ASC,
	[PartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Employee__5E55825BF4EE0744]    Script Date: 17.10.2026 16:24:25 ******/
ALTER TABLE [dbo].[Employees] ADD UNIQUE NONCLUSTERED 
(
	[Login] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Employees_Role]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_Employees_Role] ON [dbo].[Employees]
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrderParts_Part]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_OrderParts_Part] ON [dbo].[OrderParts]
(
	[PartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UX_OrderParts_Line]    Script Date: 17.10.2026 16:24:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_OrderParts_Line] ON [dbo].[OrderParts]
(
	[OrderID] ASC,
	[PartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrderWorks_Employee]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_OrderWorks_Employee] ON [dbo].[OrderWorks]
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrderWorks_Order]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_OrderWorks_Order] ON [dbo].[OrderWorks]
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrderWorks_Service]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_OrderWorks_Service] ON [dbo].[OrderWorks]
(
	[ServiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Parts__4943444A408E2C47]    Script Date: 17.10.2026 16:24:25 ******/
ALTER TABLE [dbo].[Parts] ADD UNIQUE NONCLUSTERED 
(
	[Article] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Roles__8A2B61602C7DD415]    Script Date: 17.10.2026 16:24:25 ******/
ALTER TABLE [dbo].[Roles] ADD UNIQUE NONCLUSTERED 
(
	[RoleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ServiceOrders_ClientDate]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_ServiceOrders_ClientDate] ON [dbo].[ServiceOrders]
(
	[ClientID] ASC,
	[OrderDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ServiceOrders_Employee]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_ServiceOrders_Employee] ON [dbo].[ServiceOrders]
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ServiceOrders_VIN]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_ServiceOrders_VIN] ON [dbo].[ServiceOrders]
(
	[VIN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_StockMovements_Part]    Script Date: 17.10.2026 16:24:25 ******/
CREATE NONCLUSTERED INDEX [IX_StockMovements_Part] ON [dbo].[StockMovements]
(
	[PartID] ASC,
	[MovementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuditLog] ADD  CONSTRAINT [DF_AuditLog_EventTime]  DEFAULT (sysdatetime()) FOR [EventTime]
GO
ALTER TABLE [dbo].[AuditLog] ADD  CONSTRAINT [DF_AuditLog_SqlLogin]  DEFAULT (original_login()) FOR [SqlLogin]
GO
ALTER TABLE [dbo].[Cars] ADD  DEFAULT ((0)) FOR [Kilomitrage]
GO
ALTER TABLE [dbo].[Clients] ADD  CONSTRAINT [DF_Clients_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Deals] ADD  DEFAULT (getdate()) FOR [DealDate]
GO
ALTER TABLE [dbo].[Deliveries] ADD  DEFAULT (getdate()) FOR [DeliveryDate]
GO
ALTER TABLE [dbo].[Deliveries] ADD  CONSTRAINT [DF_Deliveries_Status]  DEFAULT (N'Черновик') FOR [Status]
GO
ALTER TABLE [dbo].[Employees] ADD  CONSTRAINT [DF_Employees_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Parts] ADD  DEFAULT ((5)) FOR [MinStockLevel]
GO
ALTER TABLE [dbo].[Parts] ADD  DEFAULT ((0)) FOR [CurrentStock]
GO
ALTER TABLE [dbo].[Parts] ADD  CONSTRAINT [DF_Parts_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SchemaMigrations] ADD  DEFAULT (sysdatetime()) FOR [AppliedAt]
GO
ALTER TABLE [dbo].[ServiceOrders] ADD  DEFAULT (getdate()) FOR [OrderDate]
GO
ALTER TABLE [dbo].[ServiceOrders] ADD  DEFAULT ((0)) FOR [TotalCost]
GO
ALTER TABLE [dbo].[Services] ADD  CONSTRAINT [DF_Services_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[StockMovements] ADD  CONSTRAINT [DF_StockMovements_Date]  DEFAULT (sysdatetime()) FOR [MovementDate]
GO
ALTER TABLE [dbo].[Suppliers] ADD  CONSTRAINT [DF_Suppliers_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Deals]  WITH CHECK ADD FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[Deals]  WITH CHECK ADD FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employees] ([EmployeeID])
GO
ALTER TABLE [dbo].[Deals]  WITH CHECK ADD FOREIGN KEY([VIN])
REFERENCES [dbo].[Cars] ([VIN])
GO
ALTER TABLE [dbo].[Deliveries]  WITH CHECK ADD FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employees] ([EmployeeID])
GO
ALTER TABLE [dbo].[Deliveries]  WITH CHECK ADD FOREIGN KEY([SupplierID])
REFERENCES [dbo].[Suppliers] ([SupplierID])
GO
ALTER TABLE [dbo].[DeliveryParts]  WITH CHECK ADD FOREIGN KEY([DeliveryID])
REFERENCES [dbo].[Deliveries] ([DeliveryID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DeliveryParts]  WITH CHECK ADD FOREIGN KEY([PartID])
REFERENCES [dbo].[Parts] ([PartID])
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([RoleID])
GO
ALTER TABLE [dbo].[OrderParts]  WITH CHECK ADD FOREIGN KEY([OrderID])
REFERENCES [dbo].[ServiceOrders] ([OrderID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderParts]  WITH CHECK ADD FOREIGN KEY([PartID])
REFERENCES [dbo].[Parts] ([PartID])
GO
ALTER TABLE [dbo].[OrderWorks]  WITH CHECK ADD FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employees] ([EmployeeID])
GO
ALTER TABLE [dbo].[OrderWorks]  WITH CHECK ADD FOREIGN KEY([OrderID])
REFERENCES [dbo].[ServiceOrders] ([OrderID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderWorks]  WITH CHECK ADD FOREIGN KEY([ServiceID])
REFERENCES [dbo].[Services] ([ServiceID])
GO
ALTER TABLE [dbo].[ServiceOrders]  WITH CHECK ADD FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[ServiceOrders]  WITH CHECK ADD FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employees] ([EmployeeID])
GO
ALTER TABLE [dbo].[ServiceOrders]  WITH CHECK ADD FOREIGN KEY([VIN])
REFERENCES [dbo].[Cars] ([VIN])
GO
ALTER TABLE [dbo].[StockMovements]  WITH CHECK ADD  CONSTRAINT [FK_StockMovements_Parts] FOREIGN KEY([PartID])
REFERENCES [dbo].[Parts] ([PartID])
GO
ALTER TABLE [dbo].[StockMovements] CHECK CONSTRAINT [FK_StockMovements_Parts]
GO
ALTER TABLE [dbo].[Cars]  WITH CHECK ADD  CONSTRAINT [CK_Cars_Kilomitrage] CHECK  (([Kilomitrage]>=(0)))
GO
ALTER TABLE [dbo].[Cars] CHECK CONSTRAINT [CK_Cars_Kilomitrage]
GO
ALTER TABLE [dbo].[Cars]  WITH CHECK ADD  CONSTRAINT [CK_Cars_Names] CHECK  ((len(ltrim(rtrim([Brand])))>(0) AND len(ltrim(rtrim([Model])))>(0)))
GO
ALTER TABLE [dbo].[Cars] CHECK CONSTRAINT [CK_Cars_Names]
GO
ALTER TABLE [dbo].[Cars]  WITH CHECK ADD  CONSTRAINT [CK_Cars_Price] CHECK  (([Price]>(0)))
GO
ALTER TABLE [dbo].[Cars] CHECK CONSTRAINT [CK_Cars_Price]
GO
ALTER TABLE [dbo].[Cars]  WITH CHECK ADD  CONSTRAINT [CK_Cars_Status] CHECK  (([Status]=N'На диагностике' OR [Status]=N'Продан' OR [Status]=N'Зарезервирован' OR [Status]=N'В пути' OR [Status]=N'На складе'))
GO
ALTER TABLE [dbo].[Cars] CHECK CONSTRAINT [CK_Cars_Status]
GO
ALTER TABLE [dbo].[Cars]  WITH CHECK ADD  CONSTRAINT [CK_Cars_VIN] CHECK  ((len([VIN])=(17) AND datalength([VIN])=(34) AND NOT ([VIN]) collate Latin1_General_100_BIN2 like N'%[^0-9A-HJ-NPR-Z]%'))
GO
ALTER TABLE [dbo].[Cars] CHECK CONSTRAINT [CK_Cars_VIN]
GO
ALTER TABLE [dbo].[Cars]  WITH CHECK ADD  CONSTRAINT [CK_Cars_Year] CHECK  (([Year]>=(1886) AND [Year]<=(2100)))
GO
ALTER TABLE [dbo].[Cars] CHECK CONSTRAINT [CK_Cars_Year]
GO
ALTER TABLE [dbo].[Clients]  WITH CHECK ADD  CONSTRAINT [CK_Clients_Required] CHECK  ((len(ltrim(rtrim([FullName])))>(0) AND len(ltrim(rtrim([Phone])))>(0)))
GO
ALTER TABLE [dbo].[Clients] CHECK CONSTRAINT [CK_Clients_Required]
GO
ALTER TABLE [dbo].[Deals]  WITH CHECK ADD  CONSTRAINT [CK_Deals_Price] CHECK  (([FinalPrice]>(0)))
GO
ALTER TABLE [dbo].[Deals] CHECK CONSTRAINT [CK_Deals_Price]
GO
ALTER TABLE [dbo].[Deals]  WITH CHECK ADD  CONSTRAINT [CK_Deals_Status] CHECK  (([ContractStatus]=N'Отменен' OR [ContractStatus]=N'Исполнен' OR [ContractStatus]=N'Зарезервирован' OR [ContractStatus]=N'Черновик'))
GO
ALTER TABLE [dbo].[Deals] CHECK CONSTRAINT [CK_Deals_Status]
GO
ALTER TABLE [dbo].[Deliveries]  WITH CHECK ADD  CONSTRAINT [CK_Deliveries_Number] CHECK  ((len(ltrim(rtrim([WaybillNumber])))>(0)))
GO
ALTER TABLE [dbo].[Deliveries] CHECK CONSTRAINT [CK_Deliveries_Number]
GO
ALTER TABLE [dbo].[Deliveries]  WITH CHECK ADD  CONSTRAINT [CK_Deliveries_Status] CHECK  (([Status]=N'Отменена' OR [Status]=N'Проведена' OR [Status]=N'Черновик'))
GO
ALTER TABLE [dbo].[Deliveries] CHECK CONSTRAINT [CK_Deliveries_Status]
GO
ALTER TABLE [dbo].[DeliveryParts]  WITH CHECK ADD CHECK  (([Quantity]>(0)))
GO
ALTER TABLE [dbo].[DeliveryParts]  WITH CHECK ADD  CONSTRAINT [CK_DeliveryParts_Price] CHECK  (([PurchasePrice]>(0)))
GO
ALTER TABLE [dbo].[DeliveryParts] CHECK CONSTRAINT [CK_DeliveryParts_Price]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [CK_Employees_PasswordHash] CHECK  (([PasswordHash] like N'PBKDF2-SHA256$%$%$%' AND len([PasswordHash])>=(80)))
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [CK_Employees_PasswordHash]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [CK_Employees_Required] CHECK  ((len(ltrim(rtrim([FullName])))>(0) AND len(ltrim(rtrim([Login])))>(0) AND len(ltrim(rtrim([Position])))>(0)))
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [CK_Employees_Required]
GO
ALTER TABLE [dbo].[OrderParts]  WITH CHECK ADD CHECK  (([Quantity]>(0)))
GO
ALTER TABLE [dbo].[OrderParts]  WITH CHECK ADD  CONSTRAINT [CK_OrderParts_Price] CHECK  (([PriceAtMoment]>(0)))
GO
ALTER TABLE [dbo].[OrderParts] CHECK CONSTRAINT [CK_OrderParts_Price]
GO
ALTER TABLE [dbo].[OrderWorks]  WITH CHECK ADD  CONSTRAINT [CK_OrderWorks_Values] CHECK  (([FactHours]>(0) AND [CostPerHourAtMoment]>(0)))
GO
ALTER TABLE [dbo].[OrderWorks] CHECK CONSTRAINT [CK_OrderWorks_Values]
GO
ALTER TABLE [dbo].[Parts]  WITH CHECK ADD  CONSTRAINT [CK_Parts_Required] CHECK  ((len(ltrim(rtrim([Article])))>(0) AND len(ltrim(rtrim([PartName])))>(0)))
GO
ALTER TABLE [dbo].[Parts] CHECK CONSTRAINT [CK_Parts_Required]
GO
ALTER TABLE [dbo].[Parts]  WITH CHECK ADD  CONSTRAINT [CK_Parts_Values] CHECK  (([RetailPrice]>(0) AND [CurrentStock]>=(0) AND [MinStockLevel]>=(0)))
GO
ALTER TABLE [dbo].[Parts] CHECK CONSTRAINT [CK_Parts_Values]
GO
ALTER TABLE [dbo].[Roles]  WITH CHECK ADD  CONSTRAINT [CK_Roles_Name] CHECK  ((len(ltrim(rtrim([RoleName])))>(0)))
GO
ALTER TABLE [dbo].[Roles] CHECK CONSTRAINT [CK_Roles_Name]
GO
ALTER TABLE [dbo].[ServiceOrders]  WITH CHECK ADD  CONSTRAINT [CK_ServiceOrders_Cost] CHECK  (([TotalCost]>=(0)))
GO
ALTER TABLE [dbo].[ServiceOrders] CHECK CONSTRAINT [CK_ServiceOrders_Cost]
GO
ALTER TABLE [dbo].[ServiceOrders]  WITH CHECK ADD  CONSTRAINT [CK_ServiceOrders_Status] CHECK  (([Status]=N'Отменен' OR [Status]=N'Закрыт' OR [Status]=N'В работе' OR [Status]=N'Открыт'))
GO
ALTER TABLE [dbo].[ServiceOrders] CHECK CONSTRAINT [CK_ServiceOrders_Status]
GO
ALTER TABLE [dbo].[Services]  WITH CHECK ADD  CONSTRAINT [CK_Services_Values] CHECK  (([StandardHours]>(0) AND [CostPerHour]>(0) AND len(ltrim(rtrim([ServiceName])))>(0)))
GO
ALTER TABLE [dbo].[Services] CHECK CONSTRAINT [CK_Services_Values]
GO
ALTER TABLE [dbo].[StockMovements]  WITH CHECK ADD  CONSTRAINT [CK_StockMovements_Delta] CHECK  (([QuantityDelta]<>(0)))
GO
ALTER TABLE [dbo].[StockMovements] CHECK CONSTRAINT [CK_StockMovements_Delta]
GO
ALTER TABLE [dbo].[Suppliers]  WITH CHECK ADD  CONSTRAINT [CK_Suppliers_Name] CHECK  ((len(ltrim(rtrim([SupplierName])))>(0)))
GO
ALTER TABLE [dbo].[Suppliers] CHECK CONSTRAINT [CK_Suppliers_Name]
GO
/****** Object:  StoredProcedure [dbo].[CancelDeal]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[CancelDeal] @DealID int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    UPDATE dbo.Deals SET ContractStatus=N'Отменен' WHERE DealID=@DealID AND ContractStatus IN(N'Черновик',N'Зарезервирован');
    IF @@ROWCOUNT=0 THROW 51200,N'Документ не найден или имеет неподходящий статус.',1;
END;
GO
/****** Object:  StoredProcedure [dbo].[CloseServiceOrder]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[CloseServiceOrder] @OrderID int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    UPDATE dbo.ServiceOrders SET Status=N'Закрыт' WHERE OrderID=@OrderID AND Status IN(N'Открыт',N'В работе');
    IF @@ROWCOUNT=0 THROW 51200,N'Документ не найден или имеет неподходящий статус.',1;
END;
GO
/****** Object:  StoredProcedure [dbo].[CompleteDeal]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[CompleteDeal] @DealID int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    UPDATE dbo.Deals SET ContractStatus=N'Исполнен' WHERE DealID=@DealID AND ContractStatus IN(N'Черновик',N'Зарезервирован');
    IF @@ROWCOUNT=0 THROW 51200,N'Документ не найден или имеет неподходящий статус.',1;
END;
GO
/****** Object:  StoredProcedure [dbo].[PostDelivery]    Script Date: 17.10.2026 16:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[PostDelivery] @DeliveryID int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    UPDATE dbo.Deliveries SET Status=N'Проведена' WHERE DeliveryID=@DeliveryID AND Status=N'Черновик';
    IF @@ROWCOUNT=0 THROW 51200,N'Документ не найден или имеет неподходящий статус.',1;
END;
GO
USE [master]
GO
ALTER DATABASE [DB_Zhurikhin_AutoDealerManagement] SET  READ_WRITE 
GO

USE [DB_Zhurikhin_AutoDealerManagement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.CancelDeal @DealID int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    UPDATE dbo.Deals SET ContractStatus=N'Отменен' WHERE DealID=@DealID AND ContractStatus IN(N'Черновик',N'Зарезервирован');
    IF @@ROWCOUNT=0 THROW 51200,N'Документ не найден или имеет неподходящий статус.',1;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.CloseServiceOrder @OrderID int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    UPDATE dbo.ServiceOrders SET Status=N'Закрыт' WHERE OrderID=@OrderID AND Status IN(N'Открыт',N'В работе');
    IF @@ROWCOUNT=0 THROW 51200,N'Документ не найден или имеет неподходящий статус.',1;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.CompleteDeal @DealID int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    UPDATE dbo.Deals SET ContractStatus=N'Исполнен' WHERE DealID=@DealID AND ContractStatus IN(N'Черновик',N'Зарезервирован');
    IF @@ROWCOUNT=0 THROW 51200,N'Документ не найден или имеет неподходящий статус.',1;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER FUNCTION dbo.fn_diagramobjects() 
	RETURNS int
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		declare @id_upgraddiagrams		int
		declare @id_sysdiagrams			int
		declare @id_helpdiagrams		int
		declare @id_helpdiagramdefinition	int
		declare @id_creatediagram	int
		declare @id_renamediagram	int
		declare @id_alterdiagram 	int 
		declare @id_dropdiagram		int
		declare @InstalledObjects	int

		select @InstalledObjects = 0

		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')

		if @id_upgraddiagrams is not null
			select @InstalledObjects = @InstalledObjects + 1
		if @id_sysdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 2
		if @id_helpdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 4
		if @id_helpdiagramdefinition is not null
			select @InstalledObjects = @InstalledObjects + 8
		if @id_creatediagram is not null
			select @InstalledObjects = @InstalledObjects + 16
		if @id_renamediagram is not null
			select @InstalledObjects = @InstalledObjects + 32
		if @id_alterdiagram  is not null
			select @InstalledObjects = @InstalledObjects + 64
		if @id_dropdiagram is not null
			select @InstalledObjects = @InstalledObjects + 128
		
		return @InstalledObjects 
	END
	
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.PostDelivery @DeliveryID int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    UPDATE dbo.Deliveries SET Status=N'Проведена' WHERE DeliveryID=@DeliveryID AND Status=N'Черновик';
    IF @@ROWCOUNT=0 THROW 51200,N'Документ не найден или имеет неподходящий статус.',1;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.sp_alterdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null,
		@version 	int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId 			int
		declare @retval 		int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @ShouldChangeUID	int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();	 
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		revert;
	
		select @ShouldChangeUID = 0
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		
		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(@IsDbo <> 0)
		begin
			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
			begin
				select @ShouldChangeUID = 1 ;
			end
		end

		-- update dds data			
		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;

		-- change owner
		if(@ShouldChangeUID = 1)
			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;

		-- update dds version
		if(@version is not null)
			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;

		return 0
	END
	
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.sp_creatediagram
	(
		@diagramname 	sysname,
		@owner_id		int	= null, 	
		@version 		int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId int
		declare @retval int
		declare @IsDbo	int
		declare @userName sysname
		if(@version is null or @diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID(); 
		select @IsDbo = IS_MEMBER(N'db_owner');
		revert; 
		
		if @owner_id is null
		begin
			select @owner_id = @theId;
		end
		else
		begin
			if @theId <> @owner_id
			begin
				if @IsDbo = 0
				begin
					RAISERROR (N'E_INVALIDARG', 16, 1);
					return -1
				end
				select @theId = @owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into dbo.sysdiagrams(name, principal_id , version, definition)
				VALUES(@diagramname, @theId, @version, @definition) ;
		
		select @retval = @@IDENTITY 
		return @retval
	END
	
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.sp_dropdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT; 
		
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from dbo.sysdiagrams where diagram_id = @DiagId;
	
		return 0;
	END
	
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.sp_helpdiagramdefinition
	(
		@diagramname 	sysname,
		@owner_id	int	= null 		
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		set nocount on

		declare @theId 		int
		declare @IsDbo 		int
		declare @DiagId		int
		declare @UIDFound	int
	
		if(@diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner');
		if(@owner_id is null)
			select @owner_id = @theId;
		revert; 
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end

		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
		return 0
	END
	
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.sp_helpdiagrams
	(
		@diagramname sysname = NULL,
		@owner_id int = NULL
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		DECLARE @user sysname
		DECLARE @dboLogin bit
		EXECUTE AS CALLER;
			SET @user = USER_NAME();
			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		SELECT
			[Database] = DB_NAME(),
			[Name] = name,
			[ID] = diagram_id,
			[Owner] = USER_NAME(principal_id),
			[OwnerID] = principal_id
		FROM
			sysdiagrams
		WHERE
			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
			(@diagramname IS NULL OR name = @diagramname) AND
			(@owner_id IS NULL OR principal_id = @owner_id)
		ORDER BY
			4, 5, 1
	END
	
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.sp_renamediagram
	(
		@diagramname 		sysname,
		@owner_id		int	= null,
		@new_diagramname	sysname
	
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @DiagIdTarg		int
		declare @u_name			sysname
		if((@diagramname is null) or (@new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT;
	
		select @u_name = USER_NAME(@owner_id)
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
		--	return 0;
	
		if(@u_name is null)
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
		else
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
	
		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(@u_name is null)
			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
		else
			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
		return 0
	END
	
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.sp_upgraddiagrams
	AS
	BEGIN
		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
			return 0;
	
		CREATE TABLE dbo.sysdiagrams
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);


		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
		BEGIN
			CREATE TABLE dbo.sysdiagram_properties
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END
		*/

		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
		begin
			insert into dbo.sysdiagrams
			(
				[name],
				[principal_id],
				[version],
				[definition]
			)
			select	 
				convert(sysname, dgnm.[uvalue]),
				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.[version],
				dgdef.[lvalue]
			from dbo.[dtproperties] dgnm
				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
				
			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		end
		return 1;
	END
	
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW dbo.v_EmployeeSales
AS
SELECT e.EmployeeID,e.FullName,CAST(d.DealDate AS date) AS SaleDate,COUNT_BIG(*) AS DealsCount,SUM(d.FinalPrice) AS Revenue
FROM dbo.Deals d JOIN dbo.Employees e ON e.EmployeeID=d.EmployeeID
WHERE d.ContractStatus=N'Исполнен'
GROUP BY e.EmployeeID,e.FullName,CAST(d.DealDate AS date);
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW dbo.v_LowStockParts
AS
SELECT PartID,Article,PartName,CurrentStock,MinStockLevel,RetailPrice
FROM dbo.Parts WHERE CurrentStock<=MinStockLevel AND IsActive=1;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_Cars_Audit ON dbo.Cars
AFTER INSERT,UPDATE,DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.AuditLog(ActorEmployeeID,TableName,RecordID,ActionName,OldData,NewData)
    SELECT TRY_CONVERT(int,SESSION_CONTEXT(N'EmployeeID')),N'Cars',CONVERT(nvarchar(50),COALESCE(i.VIN,d.VIN)),
        CASE WHEN d.VIN IS NULL THEN N'INSERT' WHEN i.VIN IS NULL THEN N'DELETE' ELSE N'UPDATE' END,
        CASE WHEN d.VIN IS NULL THEN NULL ELSE (SELECT d.* FOR JSON PATH,WITHOUT_ARRAY_WRAPPER) END,
        CASE WHEN i.VIN IS NULL THEN NULL ELSE (SELECT i.* FOR JSON PATH,WITHOUT_ARRAY_WRAPPER) END
    FROM inserted i FULL JOIN deleted d ON d.VIN=i.VIN;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_Cars_DealStatus ON dbo.Cars
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM inserted i JOIN dbo.Deals d WITH(HOLDLOCK) ON d.VIN=i.VIN
        WHERE (d.ContractStatus=N'Исполнен' AND i.Status<>N'Продан') OR (d.ContractStatus=N'Зарезервирован' AND i.Status<>N'Зарезервирован'))
        THROW 51124,N'Статус автомобиля должен соответствовать активному договору.',1;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_Deals_Audit ON dbo.Deals
AFTER INSERT,UPDATE,DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.AuditLog(ActorEmployeeID,TableName,RecordID,ActionName,OldData,NewData)
    SELECT TRY_CONVERT(int,SESSION_CONTEXT(N'EmployeeID')),N'Deals',CONVERT(nvarchar(50),COALESCE(i.DealID,d.DealID)),
        CASE WHEN d.DealID IS NULL THEN N'INSERT' WHEN i.DealID IS NULL THEN N'DELETE' ELSE N'UPDATE' END,
        CASE WHEN d.DealID IS NULL THEN NULL ELSE (SELECT d.* FOR JSON PATH,WITHOUT_ARRAY_WRAPPER) END,
        CASE WHEN i.DealID IS NULL THEN NULL ELSE (SELECT i.* FOR JSON PATH,WITHOUT_ARRAY_WRAPPER) END
    FROM inserted i FULL JOIN deleted d ON d.DealID=i.DealID;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_Deals_Process ON dbo.Deals
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM deleted d LEFT JOIN inserted i ON i.DealID=d.DealID WHERE i.DealID IS NULL AND d.ContractStatus<>N'Черновик')
        THROW 51120,N'Удалять можно только черновики договоров.',1;
    IF EXISTS(SELECT 1 FROM inserted i JOIN deleted d ON d.DealID=i.DealID WHERE d.ContractStatus IN(N'Исполнен',N'Отменен') AND EXISTS(SELECT i.VIN,i.ClientID,i.EmployeeID,i.DealDate,i.FinalPrice,i.ContractStatus EXCEPT SELECT d.VIN,d.ClientID,d.EmployeeID,d.DealDate,d.FinalPrice,d.ContractStatus))
        THROW 51121,N'Исполненный или отмененный договор изменять нельзя.',1;
    IF EXISTS(SELECT 1 FROM inserted i JOIN deleted d ON d.DealID=i.DealID WHERE d.ContractStatus=N'Зарезервирован' AND i.VIN<>d.VIN)
        THROW 51122,N'Для замены автомобиля отмените резерв и создайте новый договор.',1;
    IF EXISTS(
        SELECT 1 FROM inserted i LEFT JOIN deleted d ON d.DealID=i.DealID
        JOIN dbo.Cars c WITH(UPDLOCK,HOLDLOCK) ON c.VIN=i.VIN
        WHERE i.ContractStatus IN(N'Зарезервирован',N'Исполнен')
        AND (d.DealID IS NULL OR d.ContractStatus<>i.ContractStatus)
        AND NOT ((c.Status=N'На складе' AND (d.DealID IS NULL OR d.ContractStatus=N'Черновик'))
            OR (c.Status=N'Зарезервирован' AND d.ContractStatus=N'Зарезервирован' AND i.ContractStatus=N'Исполнен'))
    ) THROW 51123,N'Автомобиль недоступен для резервирования или продажи.',1;
    UPDATE c SET Status=CASE WHEN a.ContractStatus=N'Исполнен' THEN N'Продан' WHEN a.ContractStatus=N'Зарезервирован' THEN N'Зарезервирован' ELSE N'На складе' END
    FROM dbo.Cars c
    JOIN (SELECT VIN FROM inserted WHERE ContractStatus IN(N'Зарезервирован',N'Исполнен') UNION SELECT VIN FROM deleted WHERE ContractStatus=N'Зарезервирован') x ON x.VIN=c.VIN
    OUTER APPLY(SELECT TOP(1) ContractStatus FROM dbo.Deals WHERE VIN=c.VIN AND ContractStatus IN(N'Зарезервирован',N'Исполнен')) a;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_Deliveries_Audit ON dbo.Deliveries
AFTER INSERT,UPDATE,DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.AuditLog(ActorEmployeeID,TableName,RecordID,ActionName,OldData,NewData)
    SELECT TRY_CONVERT(int,SESSION_CONTEXT(N'EmployeeID')),N'Deliveries',CONVERT(nvarchar(50),COALESCE(i.DeliveryID,d.DeliveryID)),
        CASE WHEN d.DeliveryID IS NULL THEN N'INSERT' WHEN i.DeliveryID IS NULL THEN N'DELETE' ELSE N'UPDATE' END,
        CASE WHEN d.DeliveryID IS NULL THEN NULL ELSE (SELECT d.* FOR JSON PATH,WITHOUT_ARRAY_WRAPPER) END,
        CASE WHEN i.DeliveryID IS NULL THEN NULL ELSE (SELECT i.* FOR JSON PATH,WITHOUT_ARRAY_WRAPPER) END
    FROM inserted i FULL JOIN deleted d ON d.DeliveryID=i.DeliveryID;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_Deliveries_Process ON dbo.Deliveries
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM inserted i LEFT JOIN deleted d ON d.DeliveryID=i.DeliveryID WHERE d.DeliveryID IS NULL AND i.Status<>N'Черновик')
        THROW 51110,N'Новая поставка должна быть черновиком.',1;
    IF EXISTS(SELECT 1 FROM deleted d LEFT JOIN inserted i ON i.DeliveryID=d.DeliveryID WHERE i.DeliveryID IS NULL AND d.Status<>N'Черновик')
        THROW 51111,N'Проведенные и отмененные поставки нельзя удалять.',1;
    IF EXISTS(SELECT 1 FROM inserted i JOIN deleted d ON d.DeliveryID=i.DeliveryID WHERE d.Status<>N'Черновик' AND EXISTS(SELECT i.SupplierID,i.EmployeeID,i.DeliveryDate,i.WaybillNumber,i.Status EXCEPT SELECT d.SupplierID,d.EmployeeID,d.DeliveryDate,d.WaybillNumber,d.Status))
        THROW 51112,N'Проведенную или отмененную поставку изменять нельзя.',1;
    IF EXISTS(SELECT 1 FROM inserted i JOIN deleted d ON d.DeliveryID=i.DeliveryID WHERE i.Status=N'Проведена' AND d.Status=N'Черновик' AND NOT EXISTS(SELECT 1 FROM dbo.DeliveryParts p WITH (UPDLOCK,HOLDLOCK) WHERE p.DeliveryID=i.DeliveryID))
        THROW 51113,N'Нельзя провести поставку без строк.',1;
    DECLARE @receipt TABLE(PartID int PRIMARY KEY,Quantity int NOT NULL);
    INSERT @receipt SELECT p.PartID,SUM(p.Quantity)
    FROM inserted i JOIN deleted d ON d.DeliveryID=i.DeliveryID
    JOIN dbo.DeliveryParts p WITH (UPDLOCK,HOLDLOCK) ON p.DeliveryID=i.DeliveryID
    WHERE i.Status=N'Проведена' AND d.Status=N'Черновик' GROUP BY p.PartID;
    INSERT dbo.StockMovements(PartID,QuantityDelta,SourceType,SourceID)
    SELECT p.PartID,p.Quantity,N'Поставка',i.DeliveryID
    FROM inserted i JOIN deleted d ON d.DeliveryID=i.DeliveryID JOIN dbo.DeliveryParts p ON p.DeliveryID=i.DeliveryID
    WHERE i.Status=N'Проведена' AND d.Status=N'Черновик';
    UPDATE p WITH (UPDLOCK) SET CurrentStock=CurrentStock+r.Quantity
    FROM dbo.Parts p JOIN @receipt r ON r.PartID=p.PartID;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_DeliveryParts_Protect ON dbo.DeliveryParts
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM dbo.Deliveries p WITH (UPDLOCK,HOLDLOCK)
        JOIN (SELECT DeliveryID FROM inserted UNION SELECT DeliveryID FROM deleted) x ON x.DeliveryID=p.DeliveryID
        WHERE p.Status IN (N'Проведена',N'Отменен',N'Отменена')
    ) THROW 51100,N'Строки проведенного или отмененного документа изменять нельзя.',1;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_Employees_Audit ON dbo.Employees
AFTER INSERT,UPDATE,DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.AuditLog(ActorEmployeeID,TableName,RecordID,ActionName,OldData,NewData)
    SELECT TRY_CONVERT(int,SESSION_CONTEXT(N'EmployeeID')),N'Employees',CONVERT(nvarchar(50),COALESCE(i.EmployeeID,d.EmployeeID)),
        CASE WHEN d.EmployeeID IS NULL THEN N'INSERT' WHEN i.EmployeeID IS NULL THEN N'DELETE' ELSE N'UPDATE' END,
        CASE WHEN d.EmployeeID IS NULL THEN NULL ELSE (SELECT d.EmployeeID,d.RoleID,d.FullName,d.Position,d.Phone,d.Login,d.IsActive FOR JSON PATH,WITHOUT_ARRAY_WRAPPER) END,
        CASE WHEN i.EmployeeID IS NULL THEN NULL ELSE (SELECT i.EmployeeID,i.RoleID,i.FullName,i.Position,i.Phone,i.Login,i.IsActive FOR JSON PATH,WITHOUT_ARRAY_WRAPPER) END
    FROM inserted i FULL JOIN deleted d ON d.EmployeeID=i.EmployeeID;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_OrderParts_Protect ON dbo.OrderParts
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM dbo.ServiceOrders p WITH (UPDLOCK,HOLDLOCK)
        JOIN (SELECT OrderID FROM inserted UNION SELECT OrderID FROM deleted) x ON x.OrderID=p.OrderID
        WHERE p.Status IN (N'Закрыт',N'Отменен',N'Отменена')
    ) THROW 51100,N'Строки проведенного или отмененного документа изменять нельзя.',1;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_OrderParts_Recalculate ON dbo.OrderParts
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE o SET TotalCost=
        COALESCE((SELECT SUM(CAST(p.Quantity AS decimal(12,2))*p.PriceAtMoment) FROM dbo.OrderParts p WHERE p.OrderID=o.OrderID),0)
        +COALESCE((SELECT SUM(w.FactHours*w.CostPerHourAtMoment) FROM dbo.OrderWorks w WHERE w.OrderID=o.OrderID),0)
    FROM dbo.ServiceOrders o
    WHERE o.OrderID IN (SELECT OrderID FROM inserted UNION SELECT OrderID FROM deleted);
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_OrderWorks_Protect ON dbo.OrderWorks
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM dbo.ServiceOrders p WITH (UPDLOCK,HOLDLOCK)
        JOIN (SELECT OrderID FROM inserted UNION SELECT OrderID FROM deleted) x ON x.OrderID=p.OrderID
        WHERE p.Status IN (N'Закрыт',N'Отменен',N'Отменена')
    ) THROW 51100,N'Строки проведенного или отмененного документа изменять нельзя.',1;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_OrderWorks_Recalculate ON dbo.OrderWorks
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE o SET TotalCost=
        COALESCE((SELECT SUM(CAST(p.Quantity AS decimal(12,2))*p.PriceAtMoment) FROM dbo.OrderParts p WHERE p.OrderID=o.OrderID),0)
        +COALESCE((SELECT SUM(w.FactHours*w.CostPerHourAtMoment) FROM dbo.OrderWorks w WHERE w.OrderID=o.OrderID),0)
    FROM dbo.ServiceOrders o
    WHERE o.OrderID IN (SELECT OrderID FROM inserted UNION SELECT OrderID FROM deleted);
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_Parts_StockGuard ON dbo.Parts
AFTER INSERT,UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM inserted i WHERE i.CurrentStock<>COALESCE((SELECT SUM(m.QuantityDelta) FROM dbo.StockMovements m WHERE m.PartID=i.PartID),0))
        THROW 51130,N'Остаток должен совпадать с журналом движений. Используйте проведение документов.',1;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_ServiceOrders_Audit ON dbo.ServiceOrders
AFTER INSERT,UPDATE,DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.AuditLog(ActorEmployeeID,TableName,RecordID,ActionName,OldData,NewData)
    SELECT TRY_CONVERT(int,SESSION_CONTEXT(N'EmployeeID')),N'ServiceOrders',CONVERT(nvarchar(50),COALESCE(i.OrderID,d.OrderID)),
        CASE WHEN d.OrderID IS NULL THEN N'INSERT' WHEN i.OrderID IS NULL THEN N'DELETE' ELSE N'UPDATE' END,
        CASE WHEN d.OrderID IS NULL THEN NULL ELSE (SELECT d.* FOR JSON PATH,WITHOUT_ARRAY_WRAPPER) END,
        CASE WHEN i.OrderID IS NULL THEN NULL ELSE (SELECT i.* FOR JSON PATH,WITHOUT_ARRAY_WRAPPER) END
    FROM inserted i FULL JOIN deleted d ON d.OrderID=i.OrderID;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_ServiceOrders_Process ON dbo.ServiceOrders
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM deleted d LEFT JOIN inserted i ON i.OrderID=d.OrderID WHERE i.OrderID IS NULL AND d.Status IN (N'Закрыт',N'Отменен'))
        THROW 51101,N'Закрытые и отмененные заказ-наряды нельзя удалять.',1;
    IF EXISTS (SELECT 1 FROM inserted i LEFT JOIN deleted d ON d.OrderID=i.OrderID WHERE d.OrderID IS NULL AND i.Status NOT IN (N'Открыт',N'В работе'))
        THROW 51102,N'Новый заказ-наряд должен быть открыт или находиться в работе.',1;
    IF EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON d.OrderID=i.OrderID WHERE d.Status IN (N'Закрыт',N'Отменен') AND EXISTS(SELECT i.VIN,i.ClientID,i.EmployeeID,i.OrderDate,i.IssueDescription,i.Status,i.TotalCost EXCEPT SELECT d.VIN,d.ClientID,d.EmployeeID,d.OrderDate,d.IssueDescription,d.Status,d.TotalCost))
        THROW 51103,N'Закрытый или отмененный заказ-наряд изменять нельзя.',1;
    IF EXISTS (SELECT 1 FROM inserted i WHERE i.TotalCost <>
        COALESCE((SELECT SUM(CAST(p.Quantity AS decimal(12,2))*p.PriceAtMoment) FROM dbo.OrderParts p WHERE p.OrderID=i.OrderID),0)
        +COALESCE((SELECT SUM(w.FactHours*w.CostPerHourAtMoment) FROM dbo.OrderWorks w WHERE w.OrderID=i.OrderID),0))
        THROW 51104,N'Итог заказ-наряда должен совпадать с суммой его строк.',1;
    IF EXISTS(SELECT 1 FROM inserted i JOIN deleted d ON d.OrderID=i.OrderID
        WHERE i.Status=N'Закрыт' AND d.Status<>N'Закрыт'
        AND NOT EXISTS(SELECT 1 FROM dbo.OrderParts p WITH(UPDLOCK,HOLDLOCK) WHERE p.OrderID=i.OrderID)
        AND NOT EXISTS(SELECT 1 FROM dbo.OrderWorks w WITH(UPDLOCK,HOLDLOCK) WHERE w.OrderID=i.OrderID))
        THROW 51106,N'Нельзя закрыть пустой заказ-наряд.',1;
    DECLARE @usage TABLE(PartID int PRIMARY KEY, Quantity int NOT NULL);
    INSERT @usage SELECT p.PartID,SUM(p.Quantity)
    FROM inserted i JOIN deleted d ON d.OrderID=i.OrderID
    JOIN dbo.OrderParts p WITH (UPDLOCK,HOLDLOCK) ON p.OrderID=i.OrderID
    WHERE i.Status=N'Закрыт' AND d.Status<>N'Закрыт' GROUP BY p.PartID;
    INSERT dbo.StockMovements(PartID,QuantityDelta,SourceType,SourceID)
    SELECT p.PartID,-p.Quantity,N'Заказ-наряд',i.OrderID
    FROM inserted i JOIN deleted d ON d.OrderID=i.OrderID JOIN dbo.OrderParts p ON p.OrderID=i.OrderID
    WHERE i.Status=N'Закрыт' AND d.Status<>N'Закрыт';
    UPDATE p WITH (UPDLOCK) SET CurrentStock=CurrentStock-u.Quantity
    FROM dbo.Parts p JOIN @usage u ON u.PartID=p.PartID WHERE p.CurrentStock>=u.Quantity;
    IF @@ROWCOUNT<>(SELECT COUNT(*) FROM @usage) THROW 51105,N'Недостаточно запчастей на складе для закрытия заказ-наряда.',1;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.TR_StockMovements_Immutable ON dbo.StockMovements
AFTER UPDATE,DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM deleted) THROW 51131,N'Проведенные складские движения изменять или удалять нельзя.',1;
END;
GO
