USE [DB2021FinalProjectG-39]
GO
/****** Object:  Table [dbo].[Delivery]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Delivery](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VehicleId] [int] NULL,
	[DeliveryType] [int] NULL,
	[SourceId] [int] NULL,
	[DestinationId] [int] NULL,
	[ProductId] [int] NULL,
	[CurrentStatus] [int] NULL,
	[ManagerId] [int] NULL,
 CONSTRAINT [PK_Delivery] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lookup]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lookup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [varchar](52) NOT NULL,
	[Category] [varchar](52) NOT NULL,
 CONSTRAINT [PK_Lookup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Field]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Field](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FarmerId] [int] NULL,
	[RegionId] [int] NULL,
	[Address] [varchar](255) NULL,
	[Status] [int] NULL,
	[ManagerId] [int] NULL,
 CONSTRAINT [PK_Field] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Organization]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organization](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationName] [varchar](52) NOT NULL,
	[Address] [varchar](255) NULL,
	[RegionId] [int] NULL,
	[WalletId] [int] NULL,
	[CredentailId] [int] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_Organization] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Warehouse]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Warehouse](
	[Id] [int] NOT NULL,
	[MaxCapacity] [int] NOT NULL,
	[Address] [varchar](255) NULL,
 CONSTRAINT [PK_Warehouse] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Delivery_DriverView]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[Delivery_DriverView] as 
SELECT D.Id, D.SourceId, 
	CASE 
		WHEN L.Value='FieldToWarehouse' THEN (SELECT F.Address FROM Field F WHERE F.Id=D.SourceId)
		WHEN L.Value='WarehouseToOrganization' THEN (SELECT W.Address FROM Warehouse W WHERE W.Id=D.SourceId)
		WHEN L.Value='WarehouseToWarehouse' THEN (SELECT W.Address FROM Warehouse W WHERE W.Id=D.SourceId)
END AS 'SourceAddress'
, D.DestinationId,
CASE 
		WHEN L.Value='FieldToWarehouse' THEN (SELECT W.Address FROM Warehouse W WHERE W.Id=D.DestinationId)
		WHEN L.Value='WarehouseToOrganization' THEN (SELECT O.Address FROM Organization O WHERE O.Id=D.DestinationId)
		WHEN L.Value='WarehouseToWarehouse' THEN (SELECT W.Address FROM Warehouse W WHERE W.Id=D.DestinationId)
END AS 'DestinationAddress'
FROM Delivery D
JOIN Lookup L ON L.Id=D.DeliveryType
JOIN Lookup L_ ON L_.Id=D.CurrentStatus
WHERE L_.Category='DeliveryStatus' AND L_.Value='Assigned'

GO
/****** Object:  Table [dbo].[WarehouseProduct]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WarehouseProduct](
	[WarehouseId] [int] NOT NULL,
	[ProductId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](52) NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [int] NOT NULL,
	[RemaningUnits] [int] NULL,
	[ManagerId] [int] NULL,
	[Status] [int] NULL,
	[CategoryId] [int] NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[WarehouseProduct_FarmerManager]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WarehouseProduct_FarmerManager]
as
SELECT P.Id,P.Name, P.Quantity, P.UnitPrice, P.RemaningUnits, W.Address
FROM Product P
JOIN WarehouseProduct WP ON WP.ProductId=P.Id
JOIN Warehouse W ON W.Id=WP.WarehouseId
JOIN Lookup L ON L.Id=P.Status
WHERE L.Category='ProductStatus' AND L.Value='Available'
GO
/****** Object:  Table [dbo].[Region]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Region](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RegionName] [varchar](52) NOT NULL,
 CONSTRAINT [PK_Region] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](52) NOT NULL,
	[LastName] [varchar](52) NULL,
	[PhoneNo] [varchar](15) NULL,
	[CNIC] [int] NOT NULL,
	[RegionId] [int] NULL,
	[RegDate] [datetime] NOT NULL,
	[Gender] [int] NULL,
	[WalletId] [int] NULL,
	[CredentailId] [int] NULL,
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Farmer]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Farmer](
	[FarmerId] [int] NOT NULL,
	[Status] [int] NULL,
	[Address] [varchar](255) NULL,
	[ManagerId] [int] NULL,
	[AcountType] [int] NULL,
 CONSTRAINT [PK_Farmer] PRIMARY KEY CLUSTERED 
(
	[FarmerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[FarmerFields_FarmerManager]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FarmerFields_FarmerManager]
as 
SELECT F.FarmerId, CONCAT(P.FirstName , ' ', P.LastName) Name, FE.Address 'FieldAddress', R.RegionName 'Region',L.Value 'Status'
FROM Farmer F
JOIN Field FE ON FE.FarmerId=F.FarmerId
JOIN Person P ON P.Id=F.FarmerId
JOIN Region R ON R.Id=FE.RegionId 
JOIN Lookup L ON L.Id=FE.Status
GO
/****** Object:  Table [dbo].[Credentails]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credentails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [int] NULL,
	[Email] [varchar](255) NOT NULL,
	[Password] [varchar](255) NOT NULL,
 CONSTRAINT [PK_Credentails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[OrganizationDetails_OrgManager]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[OrganizationDetails_OrgManager]
as
SELECT O.Id, O.OrganizationName, O.Address, C.Email,R.RegionName 'Region', L.Value 'Status'
FROM Organization O
JOIN Credentails C ON C.Id=O.CredentailId
JOIN Region R ON R.Id=O.RegionId
JOIN Lookup L ON L.Id=O.Status
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeId] [int] NOT NULL,
	[Salary] [int] NULL,
	[Status] [int] NULL,
	[Designation] [int] NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ManagerDetails_RegionHead]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ManagerDetails_RegionHead]
as
SELECT E.EmployeeId, CONCAT(P.FirstName,' ', P.LastName) Name, C.Email,L2.Value 'Designation', L.Value 'Status',L1.Value 'Gender', E.Salary
FROM Employee E
JOIN Person P ON P.Id=E.EmployeeId
JOIN Lookup L ON L.Id=E.Status
JOIN Lookup L1 ON L1.Id=P.Gender
JOIN Lookup L2 ON L2.Id=E.Designation
JOIN Credentails C ON C.Id=P.CredentailId
GO
/****** Object:  View [dbo].[RegionHeadDetails_CEO]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RegionHeadDetails_CEO]
as
SELECT E.EmployeeId, CONCAT(P.FirstName,' ', P.LastName) Name, C.Email, L.Value 'Status',R.RegionName 'Region',P.RegDate 'Registered',L1.Value 'Gender', E.Salary
FROM Employee E
JOIN Person P ON P.Id=E.EmployeeId
JOIN Lookup L ON L.Id=E.Status
JOIN Lookup L1 ON L1.Id=P.Gender
JOIN Lookup L2 ON L2.Id=E.Designation
JOIN Credentails C ON C.Id=P.CredentailId
JOIN Region R ON R.Id=P.RegionId

WHERE L2.Value='RegionHead'
GO
/****** Object:  Table [dbo].[DeliveryDetails]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryDetails](
	[DeliveryId] [int] NULL,
	[Status] [int] NULL,
	[TimeStamp] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Driver]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Driver](
	[DriverId] [int] NOT NULL,
	[Status] [int] NULL,
	[Address] [varchar](255) NULL,
	[DrivingLicence] [varchar](255) NOT NULL,
	[ManagerId] [int] NULL,
	[AccountType] [int] NULL,
 CONSTRAINT [PK_Driver] PRIMARY KEY CLUSTERED 
(
	[DriverId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Office]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Office](
	[Id] [int] NOT NULL,
	[Address] [varchar](255) NULL,
	[WalletId] [int] NULL,
 CONSTRAINT [PK_Office] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RequestedUnits] [int] NOT NULL,
	[PricePerUnit] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[Status] [int] NULL,
	[ProductId] [int] NULL,
	[OrganizationId] [int] NULL,
	[ManagerId] [int] NULL,
	[DeliveryId] [int] NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubCharges]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubCharges](
	[AccountType] [int] NULL,
	[Charges] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubscribtionDetail]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubscribtionDetail](
	[PersonId] [int] NOT NULL,
	[SubscribtionDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SubscribtionDetail] PRIMARY KEY CLUSTERED 
(
	[PersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TransactionDetails]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TransactionDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SenderId] [int] NULL,
	[ReceiverId] [int] NULL,
	[Amount] [int] NOT NULL,
	[TransactionType] [int] NULL,
	[TimeStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_TransactionDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vehicle]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RegNo] [varchar](11) NOT NULL,
	[SystemRegDate] [datetime] NOT NULL,
	[DriverId] [int] NULL,
	[VehicleStatus] [int] NULL,
	[ManagerId] [int] NULL,
 CONSTRAINT [PK_Vehicle] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Wallet]    Script Date: 30/04/2023 5:18:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Wallet](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [int] NULL,
	[TotalAmount] [int] NULL,
 CONSTRAINT [PK_Wallet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Credentails] ON 

INSERT [dbo].[Credentails] ([Id], [Type], [Email], [Password]) VALUES (1, 64, N'dummy@abc.com', N'1234')
SET IDENTITY_INSERT [dbo].[Credentails] OFF
GO
SET IDENTITY_INSERT [dbo].[Lookup] ON 

INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (1, N'Vegetable', N'ProductCategory')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (2, N'Fruit', N'ProductCategory')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (3, N'OilCrop', N'ProductCategory')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (4, N'IndustryCrop', N'ProductCategory')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (5, N'Other', N'ProductCategory')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (6, N'FieldToWarehouse', N'DeliveryType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (7, N'WarehouseToOrganization', N'DeliveryType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (8, N'WarehouseToWarehouse', N'DeliveryType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (9, N'Assigned', N'DeliveryStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (10, N'PickedUp', N'DeliveryStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (11, N'Dropped', N'DeliveryStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (12, N'Request', N'ProductStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (13, N'Approved', N'ProductStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (14, N'Rejected', N'ProductStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (15, N'TransportationProcess', N'ProductStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (16, N'Available', N'ProductStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (17, N'Sold', N'ProductStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (18, N'Active', N'FarmerStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (19, N'Inactive', N'FarmerStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (20, N'Pending', N'FarmerStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (21, N'Deleted', N'FarmerStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (22, N'Online', N'DriverStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (23, N'Offline', N'DriverStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (24, N'Pending', N'DriverStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (25, N'Deleted', N'DriverStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (26, N'CEO', N'EmployeeDesignation')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (27, N'RegionHead', N'EmployeeDesignation')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (28, N'FarmerManager', N'EmployeeDesignation')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (29, N'TransportManager', N'EmployeeDesignation')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (30, N'MarketplaceManager', N'EmployeeDesignation')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (31, N'Farmer', N'WalletType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (32, N'Driver', N'WalletType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (33, N'Employee', N'WalletType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (34, N'Organization', N'WalletType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (35, N'Office', N'WalletType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (36, N'Company', N'WalletType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (37, N'Active', N'VehicleStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (38, N'InActive', N'VehicleStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (39, N'Deleted', N'VehicleStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (40, N'OfficeToFarmer', N'TransactionType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (41, N'OfficeToDriver', N'TransactionType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (42, N'OfficeToOffice', N'TransactionType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (43, N'OfficeToCompany', N'TransactionType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (44, N'CompanyToOffice', N'TransactionType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (45, N'OrganizationToOffice', N'TransactionType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (46, N'Active', N'FieldStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (47, N'InActive', N'FieldStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (48, N'Pending', N'FieldStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (49, N'Deleted', N'FieldStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (50, N'Active', N'EmployeeStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (51, N'InActive', N'EmployeeStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (52, N'Pending', N'EmployeeStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (53, N'Deleted', N'EmployeeStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (54, N'Active', N'OrganizationStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (55, N'InActive', N'OrganizationStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (56, N'Pending', N'OrganizationStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (57, N'Deleted', N'OrganizationStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (58, N'Free', N'AccountType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (59, N'Premium', N'AccountType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (60, N'Employee', N'EmployeeDesignation')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (61, N'Accepted', N'OrderStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (62, N'Rejected', N'OrderStatus')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (63, N'Driver', N'UserTpye')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (64, N'Farmer', N'UserTpye')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (65, N'CEO', N'UserTpye')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (66, N'Organization', N'UserType')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (67, N'RegionHead', N'UserTpye')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (68, N'TransportManager', N'UserTpye')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (69, N'FarmerManager', N'UserTpye')
INSERT [dbo].[Lookup] ([Id], [Value], [Category]) VALUES (70, N'MarketplaceManager', N'UserTpye')
SET IDENTITY_INSERT [dbo].[Lookup] OFF
GO
SET IDENTITY_INSERT [dbo].[Region] ON 

INSERT [dbo].[Region] ([Id], [RegionName]) VALUES (1, N'Lahore')
INSERT [dbo].[Region] ([Id], [RegionName]) VALUES (2, N'Islamabad')
INSERT [dbo].[Region] ([Id], [RegionName]) VALUES (3, N'Karachi')
SET IDENTITY_INSERT [dbo].[Region] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [email_unique]    Script Date: 30/04/2023 5:18:36 pm ******/
ALTER TABLE [dbo].[Credentails] ADD  CONSTRAINT [email_unique] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Wallet] ADD  DEFAULT ((0)) FOR [TotalAmount]
GO
ALTER TABLE [dbo].[Credentails]  WITH CHECK ADD  CONSTRAINT [FK_Credentails_Lookup] FOREIGN KEY([Type])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[Credentails] CHECK CONSTRAINT [FK_Credentails_Lookup]
GO
ALTER TABLE [dbo].[Delivery]  WITH CHECK ADD  CONSTRAINT [FK_Delivery_Employee] FOREIGN KEY([ManagerId])
REFERENCES [dbo].[Employee] ([EmployeeId])
GO
ALTER TABLE [dbo].[Delivery] CHECK CONSTRAINT [FK_Delivery_Employee]
GO
ALTER TABLE [dbo].[Delivery]  WITH CHECK ADD  CONSTRAINT [FK_Delivery_Lookup_CurrentStatus] FOREIGN KEY([CurrentStatus])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[Delivery] CHECK CONSTRAINT [FK_Delivery_Lookup_CurrentStatus]
GO
ALTER TABLE [dbo].[Delivery]  WITH CHECK ADD  CONSTRAINT [FK_Delivery_Lookup_DeliveryType] FOREIGN KEY([DeliveryType])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[Delivery] CHECK CONSTRAINT [FK_Delivery_Lookup_DeliveryType]
GO
ALTER TABLE [dbo].[Delivery]  WITH CHECK ADD  CONSTRAINT [FK_Delivery_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
GO
ALTER TABLE [dbo].[Delivery] CHECK CONSTRAINT [FK_Delivery_Product]
GO
ALTER TABLE [dbo].[Delivery]  WITH CHECK ADD  CONSTRAINT [FK_Delivery_Vehicle] FOREIGN KEY([VehicleId])
REFERENCES [dbo].[Vehicle] ([Id])
GO
ALTER TABLE [dbo].[Delivery] CHECK CONSTRAINT [FK_Delivery_Vehicle]
GO
ALTER TABLE [dbo].[DeliveryDetails]  WITH CHECK ADD  CONSTRAINT [FK_DeliveryDetails_Delivery] FOREIGN KEY([DeliveryId])
REFERENCES [dbo].[Delivery] ([Id])
GO
ALTER TABLE [dbo].[DeliveryDetails] CHECK CONSTRAINT [FK_DeliveryDetails_Delivery]
GO
ALTER TABLE [dbo].[DeliveryDetails]  WITH CHECK ADD  CONSTRAINT [FK_DeliveryDetails_Lookup] FOREIGN KEY([Status])
REFERENCES [dbo].[Region] ([Id])
GO
ALTER TABLE [dbo].[DeliveryDetails] CHECK CONSTRAINT [FK_DeliveryDetails_Lookup]
GO
ALTER TABLE [dbo].[Driver]  WITH CHECK ADD  CONSTRAINT [FK_Driver_Employee] FOREIGN KEY([ManagerId])
REFERENCES [dbo].[Employee] ([EmployeeId])
GO
ALTER TABLE [dbo].[Driver] CHECK CONSTRAINT [FK_Driver_Employee]
GO
ALTER TABLE [dbo].[Driver]  WITH CHECK ADD  CONSTRAINT [FK_Driver_Lookup] FOREIGN KEY([Status])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[Driver] CHECK CONSTRAINT [FK_Driver_Lookup]
GO
ALTER TABLE [dbo].[Driver]  WITH CHECK ADD  CONSTRAINT [FK_Driver_Person] FOREIGN KEY([DriverId])
REFERENCES [dbo].[Person] ([Id])
GO
ALTER TABLE [dbo].[Driver] CHECK CONSTRAINT [FK_Driver_Person]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Lookup_Designation] FOREIGN KEY([Designation])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Lookup_Designation]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Lookup_Status] FOREIGN KEY([Status])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Lookup_Status]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Person] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Person] ([Id])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Person]
GO
ALTER TABLE [dbo].[Farmer]  WITH CHECK ADD  CONSTRAINT [FK_Farmer_Employee] FOREIGN KEY([ManagerId])
REFERENCES [dbo].[Employee] ([EmployeeId])
GO
ALTER TABLE [dbo].[Farmer] CHECK CONSTRAINT [FK_Farmer_Employee]
GO
ALTER TABLE [dbo].[Farmer]  WITH CHECK ADD  CONSTRAINT [FK_Farmer_Lookup] FOREIGN KEY([Status])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[Farmer] CHECK CONSTRAINT [FK_Farmer_Lookup]
GO
ALTER TABLE [dbo].[Farmer]  WITH CHECK ADD  CONSTRAINT [FK_Farmer_Person] FOREIGN KEY([FarmerId])
REFERENCES [dbo].[Person] ([Id])
GO
ALTER TABLE [dbo].[Farmer] CHECK CONSTRAINT [FK_Farmer_Person]
GO
ALTER TABLE [dbo].[Field]  WITH CHECK ADD  CONSTRAINT [FK_Field_Employee] FOREIGN KEY([ManagerId])
REFERENCES [dbo].[Employee] ([EmployeeId])
GO
ALTER TABLE [dbo].[Field] CHECK CONSTRAINT [FK_Field_Employee]
GO
ALTER TABLE [dbo].[Field]  WITH CHECK ADD  CONSTRAINT [FK_Field_Farmer] FOREIGN KEY([FarmerId])
REFERENCES [dbo].[Farmer] ([FarmerId])
GO
ALTER TABLE [dbo].[Field] CHECK CONSTRAINT [FK_Field_Farmer]
GO
ALTER TABLE [dbo].[Field]  WITH CHECK ADD  CONSTRAINT [FK_Field_Lookup] FOREIGN KEY([Status])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[Field] CHECK CONSTRAINT [FK_Field_Lookup]
GO
ALTER TABLE [dbo].[Field]  WITH CHECK ADD  CONSTRAINT [FK_Field_Region] FOREIGN KEY([RegionId])
REFERENCES [dbo].[Region] ([Id])
GO
ALTER TABLE [dbo].[Field] CHECK CONSTRAINT [FK_Field_Region]
GO
ALTER TABLE [dbo].[Office]  WITH CHECK ADD  CONSTRAINT [FK_Office_Region] FOREIGN KEY([Id])
REFERENCES [dbo].[Region] ([Id])
GO
ALTER TABLE [dbo].[Office] CHECK CONSTRAINT [FK_Office_Region]
GO
ALTER TABLE [dbo].[Office]  WITH CHECK ADD  CONSTRAINT [FK_Office_Wallet] FOREIGN KEY([WalletId])
REFERENCES [dbo].[Wallet] ([Id])
GO
ALTER TABLE [dbo].[Office] CHECK CONSTRAINT [FK_Office_Wallet]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Employee] FOREIGN KEY([ManagerId])
REFERENCES [dbo].[Employee] ([EmployeeId])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Employee]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Lookup] FOREIGN KEY([Status])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Lookup]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Organization] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Organization]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Product]
GO
ALTER TABLE [dbo].[Organization]  WITH CHECK ADD  CONSTRAINT [FK_Organization_Credentails] FOREIGN KEY([CredentailId])
REFERENCES [dbo].[Credentails] ([Id])
GO
ALTER TABLE [dbo].[Organization] CHECK CONSTRAINT [FK_Organization_Credentails]
GO
ALTER TABLE [dbo].[Organization]  WITH CHECK ADD  CONSTRAINT [FK_Organization_Lookup] FOREIGN KEY([Status])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[Organization] CHECK CONSTRAINT [FK_Organization_Lookup]
GO
ALTER TABLE [dbo].[Organization]  WITH CHECK ADD  CONSTRAINT [FK_Organization_Region] FOREIGN KEY([RegionId])
REFERENCES [dbo].[Region] ([Id])
GO
ALTER TABLE [dbo].[Organization] CHECK CONSTRAINT [FK_Organization_Region]
GO
ALTER TABLE [dbo].[Organization]  WITH CHECK ADD  CONSTRAINT [FK_Organization_Wallet] FOREIGN KEY([WalletId])
REFERENCES [dbo].[Wallet] ([Id])
GO
ALTER TABLE [dbo].[Organization] CHECK CONSTRAINT [FK_Organization_Wallet]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD FOREIGN KEY([CredentailId])
REFERENCES [dbo].[Credentails] ([Id])
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD FOREIGN KEY([WalletId])
REFERENCES [dbo].[Wallet] ([Id])
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_Credentails] FOREIGN KEY([CredentailId])
REFERENCES [dbo].[Credentails] ([Id])
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_Credentails]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_Lookup] FOREIGN KEY([Gender])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_Lookup]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_Region] FOREIGN KEY([RegionId])
REFERENCES [dbo].[Region] ([Id])
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_Region]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_Wallet] FOREIGN KEY([WalletId])
REFERENCES [dbo].[Wallet] ([Id])
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_Wallet]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_Employee] FOREIGN KEY([ManagerId])
REFERENCES [dbo].[Employee] ([EmployeeId])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_Employee]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_Lookup_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_Lookup_Category]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_Lookup_Status] FOREIGN KEY([Status])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_Lookup_Status]
GO
ALTER TABLE [dbo].[TransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_TransactionDetails_Type] FOREIGN KEY([TransactionType])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[TransactionDetails] CHECK CONSTRAINT [FK_TransactionDetails_Type]
GO
ALTER TABLE [dbo].[TransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_TransactionDetails_Wallet_Receiver] FOREIGN KEY([ReceiverId])
REFERENCES [dbo].[Wallet] ([Id])
GO
ALTER TABLE [dbo].[TransactionDetails] CHECK CONSTRAINT [FK_TransactionDetails_Wallet_Receiver]
GO
ALTER TABLE [dbo].[TransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_TransactionDetails_Wallet_Sender] FOREIGN KEY([SenderId])
REFERENCES [dbo].[Wallet] ([Id])
GO
ALTER TABLE [dbo].[TransactionDetails] CHECK CONSTRAINT [FK_TransactionDetails_Wallet_Sender]
GO
ALTER TABLE [dbo].[Vehicle]  WITH CHECK ADD  CONSTRAINT [FK_Vehicle_Driver] FOREIGN KEY([DriverId])
REFERENCES [dbo].[Driver] ([DriverId])
GO
ALTER TABLE [dbo].[Vehicle] CHECK CONSTRAINT [FK_Vehicle_Driver]
GO
ALTER TABLE [dbo].[Vehicle]  WITH CHECK ADD  CONSTRAINT [FK_Vehicle_Employee] FOREIGN KEY([ManagerId])
REFERENCES [dbo].[Employee] ([EmployeeId])
GO
ALTER TABLE [dbo].[Vehicle] CHECK CONSTRAINT [FK_Vehicle_Employee]
GO
ALTER TABLE [dbo].[Vehicle]  WITH CHECK ADD  CONSTRAINT [FK_Vehicle_Lookup] FOREIGN KEY([VehicleStatus])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[Vehicle] CHECK CONSTRAINT [FK_Vehicle_Lookup]
GO
ALTER TABLE [dbo].[Wallet]  WITH CHECK ADD  CONSTRAINT [FK_Wallet_Lookup] FOREIGN KEY([Type])
REFERENCES [dbo].[Lookup] ([Id])
GO
ALTER TABLE [dbo].[Wallet] CHECK CONSTRAINT [FK_Wallet_Lookup]
GO
ALTER TABLE [dbo].[Warehouse]  WITH CHECK ADD  CONSTRAINT [FK_Warehouse_Region] FOREIGN KEY([Id])
REFERENCES [dbo].[Region] ([Id])
GO
ALTER TABLE [dbo].[Warehouse] CHECK CONSTRAINT [FK_Warehouse_Region]
GO
ALTER TABLE [dbo].[WarehouseProduct]  WITH CHECK ADD  CONSTRAINT [FK_Warehoueproduct_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
GO
ALTER TABLE [dbo].[WarehouseProduct] CHECK CONSTRAINT [FK_Warehoueproduct_Product]
GO
ALTER TABLE [dbo].[WarehouseProduct]  WITH CHECK ADD  CONSTRAINT [FK_Warehouseproduct_Warehouse] FOREIGN KEY([WarehouseId])
REFERENCES [dbo].[Warehouse] ([Id])
GO
ALTER TABLE [dbo].[WarehouseProduct] CHECK CONSTRAINT [FK_Warehouseproduct_Warehouse]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [CHK_OrderPricePerUnit] CHECK  (([PricePerUnit]>(0)))
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [CHK_OrderPricePerUnit]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [CHK_OrderUnits] CHECK  (([RequestedUnits]>(0)))
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [CHK_OrderUnits]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [CHK_ProductQuantity] CHECK  (([Quantity]>(0)))
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [CHK_ProductQuantity]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [CHK_ProductRemainingUnits] CHECK  (([RemaningUnits]>=(0)))
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [CHK_ProductRemainingUnits]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [CHK_ProductUnitPrice] CHECK  (([UnitPrice]>(0)))
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [CHK_ProductUnitPrice]
GO
ALTER TABLE [dbo].[TransactionDetails]  WITH CHECK ADD  CONSTRAINT [CHK_TransactionAmount] CHECK  (([Amount]>(0)))
GO
ALTER TABLE [dbo].[TransactionDetails] CHECK CONSTRAINT [CHK_TransactionAmount]
GO
ALTER TABLE [dbo].[Warehouse]  WITH CHECK ADD  CONSTRAINT [CHK_WarehouseCapacity] CHECK  (([MaxCapacity]>(0)))
GO
ALTER TABLE [dbo].[Warehouse] CHECK CONSTRAINT [CHK_WarehouseCapacity]
GO
/****** Object:  StoredProcedure [dbo].[stpGetFieldsofFarmer]    Script Date: 30/04/2023 5:18:36 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetFieldsofFarmer]
	@FarmerId int
 AS
 BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

 -- Select statements for procedure here
 Select * from Field where FarmerId=@FarmerId
END
GO
/****** Object:  StoredProcedure [dbo].[stpGetPendingRequests_Drivers]    Script Date: 30/04/2023 5:18:36 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetPendingRequests_Drivers]
 AS
 BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

 -- Select statements for procedure here
 Select D.DriverId, CONCAT(P.FirstName,' ', P.LastName) Name,P.RegDate, R.RegionName,D.Address
 from Driver D 
 JOIN Lookup L ON L.Id=D.Status 
 JOIN Person P ON D.DriverId=P.Id
 JOIN Region R ON R.Id=P.RegionId
 where L.Category='DriverStatus' AND L.Value='PENDING'
END
GO
/****** Object:  StoredProcedure [dbo].[stpGetPendingRequests_Farmers]    Script Date: 30/04/2023 5:18:36 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetPendingRequests_Farmers]
 AS
 BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

 -- Select statements for procedure here
 Select F.FarmerId, CONCAT(P.FirstName,' ', P.LastName) Name,P.RegDate, R.RegionName,F.Address
 from Farmer F 
 JOIN Lookup L ON L.Id=F.Status 
 JOIN Person P ON F.FarmerId=P.Id
 JOIN Region R ON R.Id=P.RegionId
 where L.Category='FarmerStatus' AND L.Value='PENDING'
END
GO
/****** Object:  StoredProcedure [dbo].[stpGetPendingRequests_Fields]    Script Date: 30/04/2023 5:18:36 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stpGetPendingRequests_Fields]
 AS
 BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

 -- Select statements for procedure here
 Select F.Id,F.FarmerId, F.Address, R.RegionName
 from Field F 
 JOIN Lookup L ON L.Id=F.Status 
 JOIN Region R ON R.Id=F.RegionId
 where L.Category='FieldStatus' AND L.Value='PENDING'
END
GO
/****** Object:  StoredProcedure [dbo].[stpGetPendingRequests_Organizations]    Script Date: 30/04/2023 5:18:36 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetPendingRequests_Organizations]
 AS
 BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

 -- Select statements for procedure here
 Select O.Id, O.OrganizationName,R.RegionName,O.Address
 from Organization O
 JOIN Lookup L ON L.Id=O.Status 
 JOIN Region R ON R.Id=O.RegionId
 where L.Category='OrganizationStatus' AND L.Value='PENDING'
END
GO
/****** Object:  StoredProcedure [dbo].[stpGetPendingRequests_Products]    Script Date: 30/04/2023 5:18:36 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetPendingRequests_Products]
 AS
 BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

 -- Select statements for procedure here
 Select P.Id, P.Name, P.Quantity, P.UnitPrice, L.Value Category
 from Product P
 JOIN Lookup L ON L.Id=P.CategoryId

 where L.Category='ProductStatus' AND L.Value='REQUEST'
END
GO
