USE [DATANWO]
GO
/****** Object:  StoredProcedure [dbo].[SYNC_APP_DETALLE_USUARIOS]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SYNC_APP_DETALLE_USUARIOS]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE [dbo].[app_detalle_usuarios] AS target
    USING (
        SELECT 
            T0.[USERID],
            T0.[USER_CODE] COLLATE SQL_Latin1_General_CP850_CI_AS AS USER_CODE,
            T0.[U_NAME] COLLATE SQL_Latin1_General_CP850_CI_AS AS U_NAME,
            T0.[E_Mail] COLLATE SQL_Latin1_General_CP850_CI_AS AS E_Mail,
            T0.[Branch],
            T1.[Name] COLLATE SQL_Latin1_General_CP850_CI_AS AS BranchName,
            T0.[Department],
            T2.[Name] COLLATE SQL_Latin1_General_CP850_CI_AS AS DepartmentName
        FROM [serv-sap].anwo_produccion.dbo.OUSR T0  
        INNER JOIN [serv-sap].anwo_produccion.dbo.OUBR T1 ON T0.[Branch] = T1.[Code]
        INNER JOIN [serv-sap].anwo_produccion.dbo.OUDP T2 ON T0.[Department] = T2.[Code]
        WHERE T0.[Locked] = 'N'
		AND T0.[E_Mail] IS NOT NULL
		AND LTRIM(RTRIM(T0.[E_Mail])) <> ''

    ) AS source
    ON target.[USERID] = source.[USERID]

    WHEN MATCHED AND (
        ISNULL(NULLIF(LTRIM(RTRIM(target.[USER_CODE])), ''), '') 
            <> ISNULL(NULLIF(LTRIM(RTRIM(source.[USER_CODE])), ''), '') OR
        ISNULL(NULLIF(LTRIM(RTRIM(target.[U_NAME])), ''), '') 
            <> ISNULL(NULLIF(LTRIM(RTRIM(source.[U_NAME])), ''), '') OR
        ISNULL(NULLIF(LTRIM(RTRIM(target.[E_Mail])), ''), '') 
            <> ISNULL(NULLIF(LTRIM(RTRIM(source.[E_Mail])), ''), '') OR
        ISNULL(target.[Branch], -1) <> ISNULL(source.[Branch], -1) OR
        ISNULL(NULLIF(LTRIM(RTRIM(target.[BranchName])), ''), '') 
            <> ISNULL(NULLIF(LTRIM(RTRIM(source.[BranchName])), ''), '') OR
        ISNULL(target.[Department], -1) <> ISNULL(source.[Department], -1) OR
        ISNULL(NULLIF(LTRIM(RTRIM(target.[DepartmentName])), ''), '') 
            <> ISNULL(NULLIF(LTRIM(RTRIM(source.[DepartmentName])), ''), '')
    )
    THEN
        UPDATE SET 
            target.[USER_CODE] = source.[USER_CODE],
            target.[U_NAME] = source.[U_NAME],
            target.[E_Mail] = source.[E_Mail],
            target.[Branch] = source.[Branch],
            target.[BranchName] = source.[BranchName],
            target.[Department] = source.[Department],
            target.[DepartmentName] = source.[DepartmentName]

    WHEN NOT MATCHED BY TARGET THEN
        INSERT (
            [USERID], [USER_CODE], [U_NAME], [E_Mail], 
            [Branch], [BranchName], [Department], [DepartmentName]
        )
        VALUES (
            source.[USERID], source.[USER_CODE], source.[U_NAME], source.[E_Mail],
            source.[Branch], source.[BranchName], source.[Department], source.[DepartmentName]
        );

    PRINT 'Sincronización de APP_USUARIOS completada exitosamente.';
END;
GO
/****** Object:  StoredProcedure [dbo].[SYNC_APP_USUARIOS]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SYNC_APP_USUARIOS]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE DATANWO.dbo.app_usuarios AS target
    USING (
        SELECT 
            USERID,
            USER_CODE COLLATE SQL_Latin1_General_CP1_CI_AS AS USER_CODE,
            Branch,
            BranchName COLLATE SQL_Latin1_General_CP1_CI_AS AS BranchName,
            Department,
            DepartmentName COLLATE SQL_Latin1_General_CP1_CI_AS AS DepartmentName
        FROM DATANWO.dbo.app_detalle_usuarios
    ) AS source
    ON target.USERID = source.USERID
    WHEN MATCHED AND (
        -- USER_CODE
        target.USER_CODE <> source.USER_CODE OR 
        (target.USER_CODE IS NULL AND source.USER_CODE IS NOT NULL) OR 
        (target.USER_CODE IS NOT NULL AND source.USER_CODE IS NULL) OR
        (LTRIM(RTRIM(target.USER_CODE)) = '' AND LTRIM(RTRIM(source.USER_CODE)) <> '') OR 
        (LTRIM(RTRIM(target.USER_CODE)) <> '' AND LTRIM(RTRIM(source.USER_CODE)) = '') OR

        -- Branch
        target.Branch <> source.Branch OR 
        (target.Branch IS NULL AND source.Branch IS NOT NULL) OR 
        (target.Branch IS NOT NULL AND source.Branch IS NULL) OR

        -- BranchName
        target.BranchName <> source.BranchName OR 
        (target.BranchName IS NULL AND source.BranchName IS NOT NULL) OR 
        (target.BranchName IS NOT NULL AND source.BranchName IS NULL) OR
        (LTRIM(RTRIM(target.BranchName)) = '' AND LTRIM(RTRIM(source.BranchName)) <> '') OR 
        (LTRIM(RTRIM(target.BranchName)) <> '' AND LTRIM(RTRIM(source.BranchName)) = '') OR

        -- Department
        target.Department <> source.Department OR 
        (target.Department IS NULL AND source.Department IS NOT NULL) OR 
        (target.Department IS NOT NULL AND source.Department IS NULL) OR

        -- DepartmentName
        target.DepartmentName <> source.DepartmentName OR 
        (target.DepartmentName IS NULL AND source.DepartmentName IS NOT NULL) OR 
        (target.DepartmentName IS NOT NULL AND source.DepartmentName IS NULL) OR
        (LTRIM(RTRIM(target.DepartmentName)) = '' AND LTRIM(RTRIM(source.DepartmentName)) <> '') OR 
        (LTRIM(RTRIM(target.DepartmentName)) <> '' AND LTRIM(RTRIM(source.DepartmentName)) = '')
    )
    THEN UPDATE SET
        target.USER_CODE = source.USER_CODE,
        target.Branch = source.Branch,
        target.BranchName = source.BranchName,
        target.Department = source.Department,
        target.DepartmentName = source.DepartmentName

    WHEN NOT MATCHED THEN
    INSERT (USERID, USER_CODE, Branch, BranchName, Department, DepartmentName)
    VALUES (source.USERID, source.USER_CODE, source.Branch, source.BranchName, source.Department, source.DepartmentName);
END;
GO
/****** Object:  StoredProcedure [dbo].[SYNC_AUTH_USER]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[SYNC_AUTH_USER]
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO auth_user (
        username,
        email,
        password,
        is_active,
        is_staff,
        is_superuser,
        date_joined,
        first_name,
        last_name
    )
    SELECT 
	-- username: directamente U_NAME
	U_NAME COLLATE SQL_Latin1_General_CP1_CI_AS AS username,

	-- email: directamente E_Mail
	E_Mail COLLATE SQL_Latin1_General_CP1_CI_AS AS email,

        -- contraseña inválida por seguridad
        '!' AS password,

        -- flags por defecto
        1 AS is_active,
        0 AS is_staff,
        0 AS is_superuser,

        -- fecha de creación
        GETDATE() AS date_joined,

        -- first_name y last_name ficticios si están vacíos
        ISNULL(NULLIF(LTRIM(RTRIM(U_NAME)), ''), 'Nombre_' + CAST(USERID AS VARCHAR)) COLLATE SQL_Latin1_General_CP1_CI_AS AS first_name,
        'No_Aplica' AS last_name  -- valor fijo por defecto
    FROM DATANWO.dbo.app_detalle_usuarios du
    WHERE NOT EXISTS (
        SELECT 1 
        FROM auth_user au
        WHERE au.username = ISNULL(NULLIF(LTRIM(RTRIM(du.U_NAME)), ''), 'sin_nombre_' + CAST(du.USERID AS VARCHAR)) COLLATE SQL_Latin1_General_CP1_CI_AS
           OR au.email = ISNULL(NULLIF(LTRIM(RTRIM(du.E_Mail)), ''), 'sin_email_' + CAST(du.USERID AS VARCHAR) + '@correo.com') COLLATE SQL_Latin1_General_CP1_CI_AS
    );
END;
GO
/****** Object:  StoredProcedure [dbo].[SYNC_HLD1]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SYNC_HLD1]
AS
BEGIN
    DECLARE @periodo INT = YEAR(DATEADD(YEAR, -5, GETDATE()));
    SET NOCOUNT ON;

    -- *** Sincronización de HLD1 (Feriados) ***
    MERGE INTO DATANWO.dbo.app_hld1 AS target
    USING (
        SELECT 
            h.StrDate, 
            ISNULL(h.Rmrks, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS Rmrks
        FROM [serv-sap].anwo_produccion.dbo.HLD1 h
        WHERE h.HldCode >= @periodo
    ) AS source
    ON target.StrDate = source.StrDate

    WHEN MATCHED AND (
        target.Rmrks <> source.Rmrks OR
        (target.Rmrks IS NULL AND source.Rmrks IS NOT NULL) OR
        (target.Rmrks IS NOT NULL AND source.Rmrks IS NULL)
    )
    THEN UPDATE SET
        target.Rmrks = source.Rmrks

    WHEN NOT MATCHED THEN 
    INSERT (StrDate, Rmrks)
    VALUES (source.StrDate, source.Rmrks);

    PRINT 'Sincronización de HLD1 completada exitosamente';
END;
GO
/****** Object:  StoredProcedure [dbo].[SYNC_INV1]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SYNC_INV1]
AS
BEGIN

 	DECLARE @periodo INT = YEAR(DATEADD(YEAR, -5, GETDATE()));
    SET NOCOUNT ON;

    MERGE DATANWO.dbo.app_inv1 AS target
    USING (
        SELECT
		TRY_CAST(inv1.DocEntry AS BIGINT) AS DocEntry,
		TRY_CAST(inv1.LineNum AS INT) AS LineNum,
		TRY_CAST(inv1.TargetType AS INT) AS TargetType,
		TRY_CAST(inv1.TrgetEntry AS BIGINT) AS TrgetEntry,
		ISNULL(inv1.BaseRef, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS BaseRef,
		TRY_CAST(inv1.BaseType AS INT) AS BaseType,
		TRY_CAST(inv1.BaseEntry AS BIGINT) AS BaseEntry,
		TRY_CAST(inv1.BaseLine AS INT) AS BaseLine,
		ISNULL(inv1.LineStatus, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS LineStatus,
		ISNULL(inv1.Dscription, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS Dscription,
		TRY_CAST(inv1.Quantity AS DECIMAL(19,6)) AS Quantity,
		inv1.ShipDate AS ShipDate,
		TRY_CAST(inv1.OpenQty AS DECIMAL(19,6)) AS OpenQty,
		TRY_CAST(inv1.Price AS DECIMAL(19,6)) AS Price,
		ISNULL(inv1.Currency, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS Currency,
		TRY_CAST(inv1.Rate AS DECIMAL(19,6)) AS Rate,
		TRY_CAST(inv1.DiscPrcnt AS DECIMAL(19,6)) AS DiscPrcnt,
		TRY_CAST(inv1.LineTotal AS DECIMAL(19,6)) AS LineTotal,
		TRY_CAST(inv1.TotalFrgn AS DECIMAL(19,6)) AS TotalFrgn,
		TRY_CAST(inv1.OpenSum AS DECIMAL(19,6)) AS OpenSum,
		TRY_CAST(inv1.OpenSumFC AS DECIMAL(19,6)) AS OpenSumFC,
		ISNULL(inv1.VendorNum, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS VendorNum,
		ISNULL(inv1.SerialNum, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS SerialNum,
		ISNULL(inv1.WhsCode, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS WhsCode,
		TRY_CAST(inv1.SlpCode AS INT) AS SlpCode,
		TRY_CAST(inv1.Commission AS DECIMAL(19,6)) AS Commission,
		ISNULL(inv1.TreeType, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS TreeType,
		ISNULL(inv1.AcctCode, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS AcctCode,
		ISNULL(inv1.TaxStatus, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS TaxStatus,
		TRY_CAST(inv1.GrossBuyPr AS DECIMAL(19,6)) AS GrossBuyPr,
		TRY_CAST(inv1.PriceBefDi AS DECIMAL(19,6)) AS PriceBefDi,
		inv1.DocDate AS DocDate,
		TRY_CAST(inv1.Flags AS INT) AS Flags,
		TRY_CAST(inv1.OpenCreQty AS DECIMAL(19,6)) AS OpenCreQty,
		ISNULL(inv1.UseBaseUn, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS UseBaseUn,
		TRY_CAST(inv1.SubCatNum AS INT) AS SubCatNum,
		ISNULL(inv1.BaseCard, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS BaseCard,
		TRY_CAST(inv1.TotalSumSy AS DECIMAL(19,6)) AS TotalSumSy,
		TRY_CAST(inv1.OpenSumSys AS DECIMAL(19,6)) AS OpenSumSys,
		ISNULL(inv1.InvntSttus, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS InvntSttus,
		ISNULL(inv1.OcrCode, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS OcrCode,
		ISNULL(inv1.Project, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS Project,
		ISNULL(inv1.CodeBars, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS CodeBars,
		TRY_CAST(inv1.VatPrcnt AS DECIMAL(19,6)) AS VatPrcnt,
		ISNULL(inv1.VatGroup, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS VatGroup

		FROM [serv-sap].anwo_produccion.dbo.INV1 inv1
	    INNER JOIN DATANWO.dbo.app_oinv oinv ON inv1.DocEntry = oinv.DocEntry
		
        WHERE year(inv1.DocDate) >= @periodo
    ) AS source
    ON target.DocEntry = source.DocEntry AND target.LineNum = source.LineNum

    WHEN MATCHED AND (
        (target.DocEntry <> source.DocEntry OR target.DocEntry IS NULL AND source.DocEntry IS NOT NULL OR target.DocEntry IS NOT NULL AND source.DocEntry IS NULL) OR 
        (target.LineNum <> source.LineNum OR target.LineNum IS NULL AND source.LineNum IS NOT NULL OR target.LineNum IS NOT NULL AND source.LineNum IS NULL) OR 
        (target.TargetType <> source.TargetType OR target.TargetType IS NULL AND source.TargetType IS NOT NULL OR target.TargetType IS NOT NULL AND source.TargetType IS NULL) OR 
        (target.TrgetEntry <> source.TrgetEntry OR target.TrgetEntry IS NULL AND source.TrgetEntry IS NOT NULL OR target.TrgetEntry IS NOT NULL AND source.TrgetEntry IS NULL) OR 
        (target.BaseRef <> source.BaseRef OR target.BaseRef IS NULL AND source.BaseRef IS NOT NULL OR target.BaseRef IS NOT NULL AND source.BaseRef IS NULL) OR 
        (target.BaseType <> source.BaseType OR target.BaseType IS NULL AND source.BaseType IS NOT NULL OR target.BaseType IS NOT NULL AND source.BaseType IS NULL) OR 
        (target.BaseEntry <> source.BaseEntry OR target.BaseEntry IS NULL AND source.BaseEntry IS NOT NULL OR target.BaseEntry IS NOT NULL AND source.BaseEntry IS NULL) OR 
        (target.BaseLine <> source.BaseLine OR target.BaseLine IS NULL AND source.BaseLine IS NOT NULL OR target.BaseLine IS NOT NULL AND source.BaseLine IS NULL) OR 
        (target.LineStatus <> source.LineStatus OR target.LineStatus IS NULL AND source.LineStatus IS NOT NULL OR target.LineStatus IS NOT NULL AND source.LineStatus IS NULL) OR 
        --(target.ItemCode <> source.ItemCode OR target.ItemCode IS NULL AND source.ItemCode IS NOT NULL OR target.ItemCode IS NOT NULL AND source.ItemCode IS NULL) OR 
        (target.Dscription <> source.Dscription OR target.Dscription IS NULL AND source.Dscription IS NOT NULL OR target.Dscription IS NOT NULL AND source.Dscription IS NULL) OR 
        (target.Quantity <> source.Quantity OR target.Quantity IS NULL AND source.Quantity IS NOT NULL OR target.Quantity IS NOT NULL AND source.Quantity IS NULL) OR 
        (target.ShipDate <> source.ShipDate OR target.ShipDate IS NULL AND source.ShipDate IS NOT NULL OR target.ShipDate IS NOT NULL AND source.ShipDate IS NULL) OR 
        (target.OpenQty <> source.OpenQty OR target.OpenQty IS NULL AND source.OpenQty IS NOT NULL OR target.OpenQty IS NOT NULL AND source.OpenQty IS NULL) OR 
        (target.Price <> source.Price OR target.Price IS NULL AND source.Price IS NOT NULL OR target.Price IS NOT NULL AND source.Price IS NULL) OR 
        (target.Currency <> source.Currency OR target.Currency IS NULL AND source.Currency IS NOT NULL OR target.Currency IS NOT NULL AND source.Currency IS NULL) OR 
        (target.Rate <> source.Rate OR target.Rate IS NULL AND source.Rate IS NOT NULL OR target.Rate IS NOT NULL AND source.Rate IS NULL) OR 
        (target.DiscPrcnt <> source.DiscPrcnt OR target.DiscPrcnt IS NULL AND source.DiscPrcnt IS NOT NULL OR target.DiscPrcnt IS NOT NULL AND source.DiscPrcnt IS NULL) OR 
        (target.LineTotal <> source.LineTotal OR target.LineTotal IS NULL AND source.LineTotal IS NOT NULL OR target.LineTotal IS NOT NULL AND source.LineTotal IS NULL) OR 
        (target.TotalFrgn <> source.TotalFrgn OR target.TotalFrgn IS NULL AND source.TotalFrgn IS NOT NULL OR target.TotalFrgn IS NOT NULL AND source.TotalFrgn IS NULL) OR 
        (target.OpenSum <> source.OpenSum OR target.OpenSum IS NULL AND source.OpenSum IS NOT NULL OR target.OpenSum IS NOT NULL AND source.OpenSum IS NULL) OR 
        (target.OpenSumFC <> source.OpenSumFC OR target.OpenSumFC IS NULL AND source.OpenSumFC IS NOT NULL OR target.OpenSumFC IS NOT NULL AND source.OpenSumFC IS NULL) OR 
        (target.VendorNum <> source.VendorNum OR target.VendorNum IS NULL AND source.VendorNum IS NOT NULL OR target.VendorNum IS NOT NULL AND source.VendorNum IS NULL) OR 
        (target.SerialNum <> source.SerialNum OR target.SerialNum IS NULL AND source.SerialNum IS NOT NULL OR target.SerialNum IS NOT NULL AND source.SerialNum IS NULL) OR 
        (target.WhsCode <> source.WhsCode OR target.WhsCode IS NULL AND source.WhsCode IS NOT NULL OR target.WhsCode IS NOT NULL AND source.WhsCode IS NULL) OR 
        (target.SlpCode <> source.SlpCode OR target.SlpCode IS NULL AND source.SlpCode IS NOT NULL OR target.SlpCode IS NOT NULL AND source.SlpCode IS NULL) OR 
        (target.Commission <> source.Commission OR target.Commission IS NULL AND source.Commission IS NOT NULL OR target.Commission IS NOT NULL AND source.Commission IS NULL) OR 
        (target.TreeType <> source.TreeType OR target.TreeType IS NULL AND source.TreeType IS NOT NULL OR target.TreeType IS NOT NULL AND source.TreeType IS NULL) OR 
        (target.AcctCode <> source.AcctCode OR target.AcctCode IS NULL AND source.AcctCode IS NOT NULL OR target.AcctCode IS NOT NULL AND source.AcctCode IS NULL) OR 
        (target.TaxStatus <> source.TaxStatus OR target.TaxStatus IS NULL AND source.TaxStatus IS NOT NULL OR target.TaxStatus IS NOT NULL AND source.TaxStatus IS NULL) OR 
        (target.GrossBuyPr <> source.GrossBuyPr OR target.GrossBuyPr IS NULL AND source.GrossBuyPr IS NOT NULL OR target.GrossBuyPr IS NOT NULL AND source.GrossBuyPr IS NULL) OR 
        (target.PriceBefDi <> source.PriceBefDi OR target.PriceBefDi IS NULL AND source.PriceBefDi IS NOT NULL OR target.PriceBefDi IS NOT NULL AND source.PriceBefDi IS NULL) OR 
        (target.DocDate <> source.DocDate OR target.DocDate IS NULL AND source.DocDate IS NOT NULL OR target.DocDate IS NOT NULL AND source.DocDate IS NULL) OR 
        (target.Flags <> source.Flags OR target.Flags IS NULL AND source.Flags IS NOT NULL OR target.Flags IS NOT NULL AND source.Flags IS NULL) OR 
        (target.OpenCreQty <> source.OpenCreQty OR target.OpenCreQty IS NULL AND source.OpenCreQty IS NOT NULL OR target.OpenCreQty IS NOT NULL AND source.OpenCreQty IS NULL) OR 
        (target.UseBaseUn <> source.UseBaseUn OR target.UseBaseUn IS NULL AND source.UseBaseUn IS NOT NULL OR target.UseBaseUn IS NOT NULL AND source.UseBaseUn IS NULL) OR 
        (target.SubCatNum <> source.SubCatNum OR target.SubCatNum IS NULL AND source.SubCatNum IS NOT NULL OR target.SubCatNum IS NOT NULL AND source.SubCatNum IS NULL) OR 
        (target.BaseCard <> source.BaseCard OR target.BaseCard IS NULL AND source.BaseCard IS NOT NULL OR target.BaseCard IS NOT NULL AND source.BaseCard IS NULL) OR 
        (target.TotalSumSy <> source.TotalSumSy OR target.TotalSumSy IS NULL AND source.TotalSumSy IS NOT NULL OR target.TotalSumSy IS NOT NULL AND source.TotalSumSy IS NULL) OR 
        (target.OpenSumSys <> source.OpenSumSys OR target.OpenSumSys IS NULL AND source.OpenSumSys IS NOT NULL OR target.OpenSumSys IS NOT NULL AND source.OpenSumSys IS NULL) OR 
        (target.InvntSttus <> source.InvntSttus OR target.InvntSttus IS NULL AND source.InvntSttus IS NOT NULL OR target.InvntSttus IS NOT NULL AND source.InvntSttus IS NULL) OR 
        (target.OcrCode <> source.OcrCode OR target.OcrCode IS NULL AND source.OcrCode IS NOT NULL OR target.OcrCode IS NOT NULL AND source.OcrCode IS NULL) OR 
        (target.Project <> source.Project OR target.Project IS NULL AND source.Project IS NOT NULL OR target.Project IS NOT NULL AND source.Project IS NULL) OR 
        (target.CodeBars <> source.CodeBars OR target.CodeBars IS NULL AND source.CodeBars IS NOT NULL OR target.CodeBars IS NOT NULL AND source.CodeBars IS NULL) OR 
        (target.VatPrcnt <> source.VatPrcnt OR target.VatPrcnt IS NULL AND source.VatPrcnt IS NOT NULL OR target.VatPrcnt IS NOT NULL AND source.VatPrcnt IS NULL) OR 
        (target.VatGroup <> source.VatGroup OR target.VatGroup IS NULL AND source.VatGroup IS NOT NULL OR target.VatGroup IS NOT NULL AND source.VatGroup IS NULL)
    )
    THEN UPDATE SET
        target.DocEntry = source.DocEntry,
        target.LineNum = source.LineNum,
        target.TargetType = source.TargetType,
        target.TrgetEntry = source.TrgetEntry,
        target.BaseRef = source.BaseRef,
        target.BaseType = source.BaseType,
        target.BaseEntry = source.BaseEntry,
        target.BaseLine = source.BaseLine,
        target.LineStatus = source.LineStatus,
        --target.ItemCode = source.ItemCode,
        target.Dscription = source.Dscription,
        target.Quantity = source.Quantity,
        target.ShipDate = source.ShipDate,
        target.OpenQty = source.OpenQty,
        target.Price = source.Price,
        target.Currency = source.Currency,
        target.Rate = source.Rate,
        target.DiscPrcnt = source.DiscPrcnt,
        target.LineTotal = source.LineTotal,
        target.TotalFrgn = source.TotalFrgn,
        target.OpenSum = source.OpenSum,
        target.OpenSumFC = source.OpenSumFC,
        target.VendorNum = source.VendorNum,
        target.SerialNum = source.SerialNum,
        target.WhsCode = source.WhsCode,
        target.SlpCode = source.SlpCode,
        target.Commission = source.Commission,
        target.TreeType = source.TreeType,
        target.AcctCode = source.AcctCode,
        target.TaxStatus = source.TaxStatus,
        target.GrossBuyPr = source.GrossBuyPr,
        target.PriceBefDi = source.PriceBefDi,
        target.DocDate = source.DocDate,
        target.Flags = source.Flags,
        target.OpenCreQty = source.OpenCreQty,
        target.UseBaseUn = source.UseBaseUn,
        target.SubCatNum = source.SubCatNum,
        target.BaseCard = source.BaseCard,
        target.TotalSumSy = source.TotalSumSy,
        target.OpenSumSys = source.OpenSumSys,
        target.InvntSttus = source.InvntSttus,
        target.OcrCode = source.OcrCode,
        target.Project = source.Project,
        target.CodeBars = source.CodeBars,
        target.VatPrcnt = source.VatPrcnt,
        target.VatGroup = source.VatGroup

    WHEN NOT MATCHED THEN
    INSERT (DocEntry, LineNum, TargetType, TrgetEntry, BaseRef, BaseType, BaseEntry, BaseLine, LineStatus, Dscription, Quantity, ShipDate, OpenQty, Price, Currency, Rate, DiscPrcnt, LineTotal, TotalFrgn, OpenSum, OpenSumFC, VendorNum, SerialNum, WhsCode, SlpCode, Commission, TreeType, AcctCode, TaxStatus, GrossBuyPr, PriceBefDi, DocDate, Flags, OpenCreQty, UseBaseUn, SubCatNum, BaseCard, TotalSumSy, OpenSumSys, InvntSttus, OcrCode, Project, CodeBars, VatPrcnt, VatGroup)
    VALUES (source.DocEntry, source.LineNum, source.TargetType, source.TrgetEntry, source.BaseRef, source.BaseType, source.BaseEntry, source.BaseLine, source.LineStatus, source.Dscription, source.Quantity, source.ShipDate, source.OpenQty, source.Price, source.Currency, source.Rate, source.DiscPrcnt, source.LineTotal, source.TotalFrgn, source.OpenSum, source.OpenSumFC, source.VendorNum, source.SerialNum, source.WhsCode, source.SlpCode, source.Commission, source.TreeType, source.AcctCode, source.TaxStatus, source.GrossBuyPr, source.PriceBefDi, source.DocDate, source.Flags, source.OpenCreQty, source.UseBaseUn, source.SubCatNum, source.BaseCard, source.TotalSumSy, source.OpenSumSys, source.InvntSttus, source.OcrCode, source.Project, source.CodeBars, source.VatPrcnt, source.VatGroup);

    PRINT 'Sincronización de app_inv1 completada exitosamente';
END;

GO
/****** Object:  StoredProcedure [dbo].[SYNC_OCRD]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SYNC_OCRD]
AS
BEGIN
    SET NOCOUNT ON;

    -- Sincronización de OCRD (Maestro de Socios de Negocios)
    MERGE INTO DATANWO.dbo.app_ocrd AS target
    USING (
        SELECT DISTINCT 
            CardCode COLLATE SQL_Latin1_General_CP1_CI_AS AS CardCode, 
            CardName COLLATE SQL_Latin1_General_CP1_CI_AS AS CardName, 
            ISNULL(CardType, 'No especifico') COLLATE SQL_Latin1_General_CP1_CI_AS AS CardType, 
            ISNULL(validFor, 'N') COLLATE SQL_Latin1_General_CP1_CI_AS AS validFor, 
            ISNULL(GroupCode, 0) AS GroupCode,
            ISNULL(LicTradNum, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS LicTradNum,  
            ISNULL(E_Mail, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS E_Mail         
        FROM [serv-sap].anwo_produccion.dbo.OCRD
    ) AS source
    ON target.CardCode = source.CardCode
    WHEN MATCHED AND (
        target.CardName <> source.CardName OR
        target.CardType <> source.CardType OR
        target.validFor <> source.validFor OR
        target.GroupCode <> source.GroupCode OR
        target.LicTradNum <> source.LicTradNum 
		 OR target.LicTradNum IS NULL AND source.LicTradNum  IS NOT NULL
		 OR target.LicTradNum IS NOT NULL AND source.LicTradNum  IS NULL
		 OR target.E_Mail <> source.E_Mail
		 OR target.E_Mail IS NULL AND source.E_Mail  IS NOT NULL
		 OR target.E_Mail IS NOT NULL AND source.E_Mail  IS NULL
       
    )
    THEN UPDATE SET
        target.CardName = source.CardName,
        target.CardType = source.CardType,
        target.validFor = source.validFor,
        target.GroupCode = source.GroupCode,
        target.LicTradNum = source.LicTradNum,   
        target.E_Mail = source.E_Mail         

    WHEN NOT MATCHED THEN 
        INSERT (CardCode, CardName, CardType, validFor, GroupCode, LicTradNum, E_Mail)
        VALUES (source.CardCode, source.CardName, source.CardType, source.validFor, source.GroupCode, source.LicTradNum, source.E_Mail);

    PRINT 'Sincronización de OCRD completada exitosamente';
END;
GO
/****** Object:  StoredProcedure [dbo].[SYNC_OINV]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SYNC_OINV]
AS
BEGIN
	
	DECLARE @periodo INT = YEAR(DATEADD(YEAR, -5, GETDATE()));

    SET NOCOUNT ON;

    MERGE DATANWO.dbo.app_oinv AS target
    USING (
        SELECT
            DocEntry,
            DocNum,
            DocType COLLATE SQL_Latin1_General_CP1_CI_AS AS DocType,
            DocDueDate,
            DocTotal,
            VatSum,
            CardCode COLLATE SQL_Latin1_General_CP1_CI_AS AS CardCode,
            DocDate,
            DiscPrcnt,
            ObjType COLLATE SQL_Latin1_General_CP1_CI_AS AS ObjType,
            Series
        FROM [serv-sap].anwo_produccion.dbo.OINV
		      
        WHERE year(DocDate) >= @periodo 
    ) AS source
    ON target.DocEntry = source.DocEntry

    WHEN MATCHED AND (
        target.DocNum <> source.DocNum OR
        target.DocType <> source.DocType OR target.DocType IS NULL AND source.DocType IS NOT NULL OR target.DocType IS NOT NULL AND source.DocType IS NULL OR
        target.DocDueDate <> source.DocDueDate OR target.DocDueDate IS NULL AND source.DocDueDate IS NOT NULL OR target.DocDueDate IS NOT NULL AND source.DocDueDate IS NULL OR
        target.DocTotal <> source.DocTotal OR
        target.VatSum <> source.VatSum OR target.VatSum IS NULL AND source.VatSum IS NOT NULL OR target.VatSum IS NOT NULL AND source.VatSum IS NULL OR
        target.CardCode <> source.CardCode OR target.CardCode IS NULL AND source.CardCode IS NOT NULL OR target.CardCode IS NOT NULL AND source.CardCode IS NULL OR
        target.DocDate <> source.DocDate OR target.DocDate IS NULL AND source.DocDate IS NOT NULL OR target.DocDate IS NOT NULL AND source.DocDate IS NULL OR
        target.DiscPrcnt <> source.DiscPrcnt OR target.DiscPrcnt IS NULL AND source.DiscPrcnt IS NOT NULL OR target.DiscPrcnt IS NOT NULL AND source.DiscPrcnt IS NULL OR
        target.ObjType <> source.ObjType OR target.ObjType IS NULL AND source.ObjType IS NOT NULL OR target.ObjType IS NOT NULL AND source.ObjType IS NULL OR
        target.Series <> source.Series OR target.Series IS NULL AND source.Series IS NOT NULL OR target.Series IS NOT NULL AND source.Series IS NULL
    )
    THEN UPDATE SET
        target.DocNum = source.DocNum,
        target.DocType = source.DocType,
        target.DocDueDate = source.DocDueDate,
        target.DocTotal = source.DocTotal,
        target.VatSum = source.VatSum,
        target.CardCode = source.CardCode,
        target.DocDate = source.DocDate,
        target.DiscPrcnt = source.DiscPrcnt,
        target.ObjType = source.ObjType,
        target.Series = source.Series

    WHEN NOT MATCHED THEN
    INSERT (DocEntry, DocNum, DocType, DocDueDate, DocTotal, VatSum, CardCode, DocDate, DiscPrcnt, ObjType, Series)
    VALUES (source.DocEntry, source.DocNum, source.DocType, source.DocDueDate, source.DocTotal, source.VatSum, source.CardCode, source.DocDate, source.DiscPrcnt, source.ObjType, source.Series);

    PRINT 'Sincronización de OINV completada exitosamente.';
END;
GO
/****** Object:  StoredProcedure [dbo].[SYNC_OITM]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------OITM----------------
--EXEC  [dbo].[SYNC_OITM]

CREATE PROCEDURE    [dbo].[SYNC_OITM]
AS
BEGIN
    SET NOCOUNT ON;

     -- *** 1? OITM (Maestro de Artículos) ***
    MERGE DATANWO.dbo.app_oitm AS target
    USING (
        SELECT 
            ItemCode COLLATE SQL_Latin1_General_CP1_CI_AS AS ItemCode, 
            ItemName COLLATE SQL_Latin1_General_CP1_CI_AS AS ItemName, 
            FrgnName COLLATE SQL_Latin1_General_CP1_CI_AS AS FrgnName,
            ItmsGrpCod, 
            CstGrpCode,
            VatGourpSa COLLATE SQL_Latin1_General_CP1_CI_AS AS VatGourpSa,
            CodeBars COLLATE SQL_Latin1_General_CP1_CI_AS AS CodeBars,
            VATLiable COLLATE SQL_Latin1_General_CP1_CI_AS AS VATLiable,
            PrchseItem COLLATE SQL_Latin1_General_CP1_CI_AS AS PrchseItem,
            SellItem COLLATE SQL_Latin1_General_CP1_CI_AS AS SellItem,
            InvntItem COLLATE SQL_Latin1_General_CP1_CI_AS AS InvntItem,
            CardCode COLLATE SQL_Latin1_General_CP1_CI_AS AS CardCode,
            DscountCod,
            SLen2Unit,
            SVolume, SVolUnit, SWeight1, SWght1Unit, SWeight2, SWght2Unit,
            BHeight1, BHght1Unit, BHeight2, BHght2Unit,
            BWidth1, BWdth1Unit, BWidth2, BWdth2Unit,
            BLength1, BLen1Unit, Blength2, BLen2Unit,
            FixCurrCms COLLATE SQL_Latin1_General_CP1_CI_AS AS FixCurrCms,
            FirmCode,
            LstSalDate, CreateDate, UpdateDate,
            validFor COLLATE SQL_Latin1_General_CP1_CI_AS AS validFor,
            validFrom, validTo, frozenFor COLLATE SQL_Latin1_General_CP1_CI_AS AS frozenFor,
            frozenFrom, frozenTo, BlockOut COLLATE SQL_Latin1_General_CP1_CI_AS AS BlockOut,
			QryGroup1 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup1,
			QryGroup2 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup2,
			QryGroup3 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup3,
			QryGroup4 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup4,
			QryGroup5 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup5,
			QryGroup6 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup6,
			QryGroup7 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup7,
			QryGroup8 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup8,
			QryGroup9 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup9,
			QryGroup10 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup10,
			QryGroup11 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup11,
			QryGroup12 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup12,
			QryGroup13 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup13,
			QryGroup14 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup14,
			QryGroup15 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup15,
			QryGroup16 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup16,
			QryGroup17 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup17,
			QryGroup18 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup18,
			QryGroup19 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup19,
			QryGroup20 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup20,
			QryGroup21 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup21,
			QryGroup22 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup22,
			QryGroup23 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup23,
			QryGroup24 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup24,
			QryGroup25 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup25,
			QryGroup26 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup26,
			QryGroup27 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup27,
			QryGroup28 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup28,
			QryGroup29 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup29,
			QryGroup30 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup30,
			QryGroup31 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup31,
			QryGroup32 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup32,
			QryGroup33 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup33,
			QryGroup34 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup34,
			QryGroup35 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup35,
			QryGroup36 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup36,
			QryGroup37 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup37,
			QryGroup38 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup38,
			QryGroup39 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup39,
			QryGroup40 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup40,
			QryGroup41 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup41,
			QryGroup42 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup42,
			QryGroup43 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup43,
			QryGroup44 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup44,
			QryGroup45 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup45,
			QryGroup46 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup46,
			QryGroup47 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup47,
			QryGroup48 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup48,
			QryGroup49 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup49,
			QryGroup50 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup50,
			QryGroup51 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup51,
			QryGroup52 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup52,
			QryGroup53 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup53,
			QryGroup54 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup54,
			QryGroup55 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup55,
			QryGroup56 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup56,
			QryGroup57 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup57,
			QryGroup58 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup58,
			QryGroup59 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup59,
			QryGroup60 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup60,
			QryGroup61 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup61,
			QryGroup62 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup62,
			QryGroup63 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup63,
			QryGroup64 COLLATE SQL_Latin1_General_CP850_CI_AS AS QryGroup64,
            EnAstSeri COLLATE SQL_Latin1_General_CP1_CI_AS AS EnAstSeri,
            U_Masivo COLLATE SQL_Latin1_General_CP1_CI_AS AS U_Masivo,
            U_NumEtiq, U_Currency COLLATE SQL_Latin1_General_CP1_CI_AS AS U_Currency,
            U_Origin COLLATE SQL_Latin1_General_CP1_CI_AS AS U_Origin,
            U_FUCOSTO, U_VCOSTO, U_VcostoA, U_TCostos COLLATE SQL_Latin1_General_CP1_CI_AS AS U_TCostos,
            U_FULTCOSTO, U_TamEtiq COLLATE SQL_Latin1_General_CP1_CI_AS AS U_TamEtiq,
            U_Glosa COLLATE SQL_Latin1_General_CP1_CI_AS AS U_Glosa,
            U_Tproducto COLLATE SQL_Latin1_General_CP1_CI_AS AS U_Tproducto,
            U_Ubi_Primaria COLLATE SQL_Latin1_General_CP1_CI_AS AS U_Ubi_Primaria,
            U_Ubi_secundaria COLLATE SQL_Latin1_General_CP1_CI_AS AS U_Ubi_secundaria,
            U_Ubi_terciaria COLLATE SQL_Latin1_General_CP1_CI_AS AS U_Ubi_terciaria,
            U_REV COLLATE SQL_Latin1_General_CP1_CI_AS AS U_REV,
			OnHand 

        FROM [serv-sap].anwo_produccion.dbo.oitm
    ) AS source
    ON target.ItemCode = source.ItemCode
WHEN MATCHED AND (
    (target.ItemName <> source.ItemName OR target.ItemName IS NULL AND source.ItemName IS NOT NULL OR target.ItemName IS NOT NULL AND source.ItemName IS NULL)
    OR (target.FrgnName <> source.FrgnName OR target.FrgnName IS NULL AND source.FrgnName IS NOT NULL OR target.FrgnName IS NOT NULL AND source.FrgnName IS NULL)
    OR (target.ItmsGrpCod <> source.ItmsGrpCod OR target.ItmsGrpCod IS NULL AND source.ItmsGrpCod IS NOT NULL OR target.ItmsGrpCod IS NOT NULL AND source.ItmsGrpCod IS NULL)
    OR (target.CstGrpCode <> source.CstGrpCode OR target.CstGrpCode IS NULL AND source.CstGrpCode IS NOT NULL OR target.CstGrpCode IS NOT NULL AND source.CstGrpCode IS NULL)
    OR (target.VatGourpSa <> source.VatGourpSa OR target.VatGourpSa IS NULL AND source.VatGourpSa IS NOT NULL OR target.VatGourpSa IS NOT NULL AND source.VatGourpSa IS NULL)
    OR (target.CodeBars <> source.CodeBars OR target.CodeBars IS NULL AND source.CodeBars IS NOT NULL OR target.CodeBars IS NOT NULL AND source.CodeBars IS NULL)
    OR (target.VATLiable <> source.VATLiable OR target.VATLiable IS NULL AND source.VATLiable IS NOT NULL OR target.VATLiable IS NOT NULL AND source.VATLiable IS NULL)
    OR (target.PrchseItem <> source.PrchseItem OR target.PrchseItem IS NULL AND source.PrchseItem IS NOT NULL OR target.PrchseItem IS NOT NULL AND source.PrchseItem IS NULL)
    OR (target.SellItem <> source.SellItem OR target.SellItem IS NULL AND source.SellItem IS NOT NULL OR target.SellItem IS NOT NULL AND source.SellItem IS NULL)
    OR (target.InvntItem <> source.InvntItem OR target.InvntItem IS NULL AND source.InvntItem IS NOT NULL OR target.InvntItem IS NOT NULL AND source.InvntItem IS NULL)
    OR (target.CardCode <> source.CardCode OR target.CardCode IS NULL AND source.CardCode IS NOT NULL OR target.CardCode IS NOT NULL AND source.CardCode IS NULL)
    OR (target.DscountCod <> source.DscountCod OR target.DscountCod IS NULL AND source.DscountCod IS NOT NULL OR target.DscountCod IS NOT NULL AND source.DscountCod IS NULL)
    OR (target.SLen2Unit <> source.SLen2Unit OR target.SLen2Unit IS NULL AND source.SLen2Unit IS NOT NULL OR target.SLen2Unit IS NOT NULL AND source.SLen2Unit IS NULL)
    OR (target.SVolume <> source.SVolume OR target.SVolume IS NULL AND source.SVolume IS NOT NULL OR target.SVolume IS NOT NULL AND source.SVolume IS NULL)
    OR (target.SVolUnit <> source.SVolUnit OR target.SVolUnit IS NULL AND source.SVolUnit IS NOT NULL OR target.SVolUnit IS NOT NULL AND source.SVolUnit IS NULL)
    OR (target.SWeight1 <> source.SWeight1 OR target.SWeight1 IS NULL AND source.SWeight1 IS NOT NULL OR target.SWeight1 IS NOT NULL AND source.SWeight1 IS NULL)
    OR (target.SWght1Unit <> source.SWght1Unit OR target.SWght1Unit IS NULL AND source.SWght1Unit IS NOT NULL OR target.SWght1Unit IS NOT NULL AND source.SWght1Unit IS NULL)
    OR (target.SWeight2 <> source.SWeight2 OR target.SWeight2 IS NULL AND source.SWeight2 IS NOT NULL OR target.SWeight2 IS NOT NULL AND source.SWeight2 IS NULL)
    OR (target.SWght2Unit <> source.SWght2Unit OR target.SWght2Unit IS NULL AND source.SWght2Unit IS NOT NULL OR target.SWght2Unit IS NOT NULL AND source.SWght2Unit IS NULL)
    OR (target.BHeight1 <> source.BHeight1 OR target.BHeight1 IS NULL AND source.BHeight1 IS NOT NULL OR target.BHeight1 IS NOT NULL AND source.BHeight1 IS NULL)
    OR (target.BHght1Unit <> source.BHght1Unit OR target.BHght1Unit IS NULL AND source.BHght1Unit IS NOT NULL OR target.BHght1Unit IS NOT NULL AND source.BHght1Unit IS NULL)
    OR (target.BHeight2 <> source.BHeight2 OR target.BHeight2 IS NULL AND source.BHeight2 IS NOT NULL OR target.BHeight2 IS NOT NULL AND source.BHeight2 IS NULL)
    OR (target.BHght2Unit <> source.BHght2Unit OR target.BHght2Unit IS NULL AND source.BHght2Unit IS NOT NULL OR target.BHght2Unit IS NOT NULL AND source.BHght2Unit IS NULL)
    OR (target.BWidth1 <> source.BWidth1 OR target.BWidth1 IS NULL AND source.BWidth1 IS NOT NULL OR target.BWidth1 IS NOT NULL AND source.BWidth1 IS NULL)
    OR (target.BWdth1Unit <> source.BWdth1Unit OR target.BWdth1Unit IS NULL AND source.BWdth1Unit IS NOT NULL OR target.BWdth1Unit IS NOT NULL AND source.BWdth1Unit IS NULL)
    OR (target.BWidth2 <> source.BWidth2 OR target.BWidth2 IS NULL AND source.BWidth2 IS NOT NULL OR target.BWidth2 IS NOT NULL AND source.BWidth2 IS NULL)
    OR (target.BWdth2Unit <> source.BWdth2Unit OR target.BWdth2Unit IS NULL AND source.BWdth2Unit IS NOT NULL OR target.BWdth2Unit IS NOT NULL AND source.BWdth2Unit IS NULL)
    OR (target.BLength1 <> source.BLength1 OR target.BLength1 IS NULL AND source.BLength1 IS NOT NULL OR target.BLength1 IS NOT NULL AND source.BLength1 IS NULL)
    OR (target.BLen1Unit <> source.BLen1Unit OR target.BLen1Unit IS NULL AND source.BLen1Unit IS NOT NULL OR target.BLen1Unit IS NOT NULL AND source.BLen1Unit IS NULL)
    OR (target.Blength2 <> source.Blength2 OR target.Blength2 IS NULL AND source.Blength2 IS NOT NULL OR target.Blength2 IS NOT NULL AND source.Blength2 IS NULL)
    OR (target.BLen2Unit <> source.BLen2Unit OR target.BLen2Unit IS NULL AND source.BLen2Unit IS NOT NULL OR target.BLen2Unit IS NOT NULL AND source.BLen2Unit IS NULL)
    OR (target.FixCurrCms <> source.FixCurrCms OR target.FixCurrCms IS NULL AND source.FixCurrCms IS NOT NULL OR target.FixCurrCms IS NOT NULL AND source.FixCurrCms IS NULL)
    OR (target.FirmCode <> source.FirmCode OR target.FirmCode IS NULL AND source.FirmCode IS NOT NULL OR target.FirmCode IS NOT NULL AND source.FirmCode IS NULL)
    OR (target.LstSalDate <> source.LstSalDate OR target.LstSalDate IS NULL AND source.LstSalDate IS NOT NULL OR target.LstSalDate IS NOT NULL AND source.LstSalDate IS NULL)
    OR (target.CreateDate <> source.CreateDate OR target.CreateDate IS NULL AND source.CreateDate IS NOT NULL OR target.CreateDate IS NOT NULL AND source.CreateDate IS NULL)
    OR (target.UpdateDate <> source.UpdateDate OR target.UpdateDate IS NULL AND source.UpdateDate IS NOT NULL OR target.UpdateDate IS NOT NULL AND source.UpdateDate IS NULL)
    OR (target.validFor <> source.validFor OR target.validFor IS NULL AND source.validFor IS NOT NULL OR target.validFor IS NOT NULL AND source.validFor IS NULL)
    OR (target.validFrom <> source.validFrom OR target.validFrom IS NULL AND source.validFrom IS NOT NULL OR target.validFrom IS NOT NULL AND source.validFrom IS NULL)
    OR (target.validTo <> source.validTo OR target.validTo IS NULL AND source.validTo IS NOT NULL OR target.validTo IS NOT NULL AND source.validTo IS NULL)
    OR (target.frozenFor <> source.frozenFor OR target.frozenFor IS NULL AND source.frozenFor IS NOT NULL OR target.frozenFor IS NOT NULL AND source.frozenFor IS NULL)
    OR (target.frozenFrom <> source.frozenFrom OR target.frozenFrom IS NULL AND source.frozenFrom IS NOT NULL OR target.frozenFrom IS NOT NULL AND source.frozenFrom IS NULL)
    OR (target.frozenTo <> source.frozenTo OR target.frozenTo IS NULL AND source.frozenTo IS NOT NULL OR target.frozenTo IS NOT NULL AND source.frozenTo IS NULL)
    OR (target.BlockOut <> source.BlockOut OR target.BlockOut IS NULL AND source.BlockOut IS NOT NULL OR target.BlockOut IS NOT NULL AND source.BlockOut IS NULL)
    OR  target.QryGroup1 <> source.QryGroup1 OR target.QryGroup1 IS NULL AND source.QryGroup1 IS NOT NULL OR target.QryGroup1 IS NOT NULL AND source.QryGroup1 IS NULL OR
    target.QryGroup2 <> source.QryGroup2 OR target.QryGroup2 IS NULL AND source.QryGroup2 IS NOT NULL OR target.QryGroup2 IS NOT NULL AND source.QryGroup2 IS NULL OR
    target.QryGroup3 <> source.QryGroup3 OR target.QryGroup3 IS NULL AND source.QryGroup3 IS NOT NULL OR target.QryGroup3 IS NOT NULL AND source.QryGroup3 IS NULL OR
    target.QryGroup4 <> source.QryGroup4 OR target.QryGroup4 IS NULL AND source.QryGroup4 IS NOT NULL OR target.QryGroup4 IS NOT NULL AND source.QryGroup4 IS NULL OR
    target.QryGroup5 <> source.QryGroup5 OR target.QryGroup5 IS NULL AND source.QryGroup5 IS NOT NULL OR target.QryGroup5 IS NOT NULL AND source.QryGroup5 IS NULL OR
    target.QryGroup6 <> source.QryGroup6 OR target.QryGroup6 IS NULL AND source.QryGroup6 IS NOT NULL OR target.QryGroup6 IS NOT NULL AND source.QryGroup6 IS NULL OR
    target.QryGroup7 <> source.QryGroup7 OR target.QryGroup7 IS NULL AND source.QryGroup7 IS NOT NULL OR target.QryGroup7 IS NOT NULL AND source.QryGroup7 IS NULL OR
    target.QryGroup8 <> source.QryGroup8 OR target.QryGroup8 IS NULL AND source.QryGroup8 IS NOT NULL OR target.QryGroup8 IS NOT NULL AND source.QryGroup8 IS NULL OR
    target.QryGroup9 <> source.QryGroup9 OR target.QryGroup9 IS NULL AND source.QryGroup9 IS NOT NULL OR target.QryGroup9 IS NOT NULL AND source.QryGroup9 IS NULL OR
    target.QryGroup10 <> source.QryGroup10 OR target.QryGroup10 IS NULL AND source.QryGroup10 IS NOT NULL OR target.QryGroup10 IS NOT NULL AND source.QryGroup10 IS NULL OR
    target.QryGroup11 <> source.QryGroup11 OR target.QryGroup11 IS NULL AND source.QryGroup11 IS NOT NULL OR target.QryGroup11 IS NOT NULL AND source.QryGroup11 IS NULL OR
    target.QryGroup12 <> source.QryGroup12 OR target.QryGroup12 IS NULL AND source.QryGroup12 IS NOT NULL OR target.QryGroup12 IS NOT NULL AND source.QryGroup12 IS NULL OR
    target.QryGroup13 <> source.QryGroup13 OR target.QryGroup13 IS NULL AND source.QryGroup13 IS NOT NULL OR target.QryGroup13 IS NOT NULL AND source.QryGroup13 IS NULL OR
    target.QryGroup14 <> source.QryGroup14 OR target.QryGroup14 IS NULL AND source.QryGroup14 IS NOT NULL OR target.QryGroup14 IS NOT NULL AND source.QryGroup14 IS NULL OR
    target.QryGroup15 <> source.QryGroup15 OR target.QryGroup15 IS NULL AND source.QryGroup15 IS NOT NULL OR target.QryGroup15 IS NOT NULL AND source.QryGroup15 IS NULL OR
    target.QryGroup16 <> source.QryGroup16 OR target.QryGroup16 IS NULL AND source.QryGroup16 IS NOT NULL OR target.QryGroup16 IS NOT NULL AND source.QryGroup16 IS NULL OR
    target.QryGroup17 <> source.QryGroup17 OR target.QryGroup17 IS NULL AND source.QryGroup17 IS NOT NULL OR target.QryGroup17 IS NOT NULL AND source.QryGroup17 IS NULL OR
    target.QryGroup18 <> source.QryGroup18 OR target.QryGroup18 IS NULL AND source.QryGroup18 IS NOT NULL OR target.QryGroup18 IS NOT NULL AND source.QryGroup18 IS NULL OR
    target.QryGroup19 <> source.QryGroup19 OR target.QryGroup19 IS NULL AND source.QryGroup19 IS NOT NULL OR target.QryGroup19 IS NOT NULL AND source.QryGroup19 IS NULL OR
    target.QryGroup20 <> source.QryGroup20 OR target.QryGroup20 IS NULL AND source.QryGroup20 IS NOT NULL OR target.QryGroup20 IS NOT NULL AND source.QryGroup20 IS NULL OR
    target.QryGroup21 <> source.QryGroup21 OR target.QryGroup21 IS NULL AND source.QryGroup21 IS NOT NULL OR target.QryGroup21 IS NOT NULL AND source.QryGroup21 IS NULL OR
    target.QryGroup22 <> source.QryGroup22 OR target.QryGroup22 IS NULL AND source.QryGroup22 IS NOT NULL OR target.QryGroup22 IS NOT NULL AND source.QryGroup22 IS NULL OR
    target.QryGroup23 <> source.QryGroup23 OR target.QryGroup23 IS NULL AND source.QryGroup23 IS NOT NULL OR target.QryGroup23 IS NOT NULL AND source.QryGroup23 IS NULL OR
    target.QryGroup24 <> source.QryGroup24 OR target.QryGroup24 IS NULL AND source.QryGroup24 IS NOT NULL OR target.QryGroup24 IS NOT NULL AND source.QryGroup24 IS NULL OR
    target.QryGroup25 <> source.QryGroup25 OR target.QryGroup25 IS NULL AND source.QryGroup25 IS NOT NULL OR target.QryGroup25 IS NOT NULL AND source.QryGroup25 IS NULL OR
    target.QryGroup26 <> source.QryGroup26 OR target.QryGroup26 IS NULL AND source.QryGroup26 IS NOT NULL OR target.QryGroup26 IS NOT NULL AND source.QryGroup26 IS NULL OR
    target.QryGroup27 <> source.QryGroup27 OR target.QryGroup27 IS NULL AND source.QryGroup27 IS NOT NULL OR target.QryGroup27 IS NOT NULL AND source.QryGroup27 IS NULL OR
    target.QryGroup28 <> source.QryGroup28 OR target.QryGroup28 IS NULL AND source.QryGroup28 IS NOT NULL OR target.QryGroup28 IS NOT NULL AND source.QryGroup28 IS NULL OR
    target.QryGroup29 <> source.QryGroup29 OR target.QryGroup29 IS NULL AND source.QryGroup29 IS NOT NULL OR target.QryGroup29 IS NOT NULL AND source.QryGroup29 IS NULL OR
    target.QryGroup30 <> source.QryGroup30 OR target.QryGroup30 IS NULL AND source.QryGroup30 IS NOT NULL OR target.QryGroup30 IS NOT NULL AND source.QryGroup30 IS NULL OR
    target.QryGroup31 <> source.QryGroup31 OR target.QryGroup31 IS NULL AND source.QryGroup31 IS NOT NULL OR target.QryGroup31 IS NOT NULL AND source.QryGroup31 IS NULL OR
    target.QryGroup32 <> source.QryGroup32 OR target.QryGroup32 IS NULL AND source.QryGroup32 IS NOT NULL OR target.QryGroup32 IS NOT NULL AND source.QryGroup32 IS NULL OR
    target.QryGroup33 <> source.QryGroup33 OR target.QryGroup33 IS NULL AND source.QryGroup33 IS NOT NULL OR target.QryGroup33 IS NOT NULL AND source.QryGroup33 IS NULL OR
    target.QryGroup34 <> source.QryGroup34 OR target.QryGroup34 IS NULL AND source.QryGroup34 IS NOT NULL OR target.QryGroup34 IS NOT NULL AND source.QryGroup34 IS NULL OR
    target.QryGroup35 <> source.QryGroup35 OR target.QryGroup35 IS NULL AND source.QryGroup35 IS NOT NULL OR target.QryGroup35 IS NOT NULL AND source.QryGroup35 IS NULL OR
    target.QryGroup36 <> source.QryGroup36 OR target.QryGroup36 IS NULL AND source.QryGroup36 IS NOT NULL OR target.QryGroup36 IS NOT NULL AND source.QryGroup36 IS NULL OR
    target.QryGroup37 <> source.QryGroup37 OR target.QryGroup37 IS NULL AND source.QryGroup37 IS NOT NULL OR target.QryGroup37 IS NOT NULL AND source.QryGroup37 IS NULL OR
    target.QryGroup38 <> source.QryGroup38 OR target.QryGroup38 IS NULL AND source.QryGroup38 IS NOT NULL OR target.QryGroup38 IS NOT NULL AND source.QryGroup38 IS NULL OR
    target.QryGroup39 <> source.QryGroup39 OR target.QryGroup39 IS NULL AND source.QryGroup39 IS NOT NULL OR target.QryGroup39 IS NOT NULL AND source.QryGroup39 IS NULL OR
    target.QryGroup40 <> source.QryGroup40 OR target.QryGroup40 IS NULL AND source.QryGroup40 IS NOT NULL OR target.QryGroup40 IS NOT NULL AND source.QryGroup40 IS NULL OR
    target.QryGroup41 <> source.QryGroup41 OR target.QryGroup41 IS NULL AND source.QryGroup41 IS NOT NULL OR target.QryGroup41 IS NOT NULL AND source.QryGroup41 IS NULL OR
    target.QryGroup42 <> source.QryGroup42 OR target.QryGroup42 IS NULL AND source.QryGroup42 IS NOT NULL OR target.QryGroup42 IS NOT NULL AND source.QryGroup42 IS NULL OR
    target.QryGroup43 <> source.QryGroup43 OR target.QryGroup43 IS NULL AND source.QryGroup43 IS NOT NULL OR target.QryGroup43 IS NOT NULL AND source.QryGroup43 IS NULL OR
    target.QryGroup44 <> source.QryGroup44 OR target.QryGroup44 IS NULL AND source.QryGroup44 IS NOT NULL OR target.QryGroup44 IS NOT NULL AND source.QryGroup44 IS NULL OR
    target.QryGroup45 <> source.QryGroup45 OR target.QryGroup45 IS NULL AND source.QryGroup45 IS NOT NULL OR target.QryGroup45 IS NOT NULL AND source.QryGroup45 IS NULL OR
    target.QryGroup46 <> source.QryGroup46 OR target.QryGroup46 IS NULL AND source.QryGroup46 IS NOT NULL OR target.QryGroup46 IS NOT NULL AND source.QryGroup46 IS NULL OR
    target.QryGroup47 <> source.QryGroup47 OR target.QryGroup47 IS NULL AND source.QryGroup47 IS NOT NULL OR target.QryGroup47 IS NOT NULL AND source.QryGroup47 IS NULL OR
    target.QryGroup48 <> source.QryGroup48 OR target.QryGroup48 IS NULL AND source.QryGroup48 IS NOT NULL OR target.QryGroup48 IS NOT NULL AND source.QryGroup48 IS NULL OR
    target.QryGroup49 <> source.QryGroup49 OR target.QryGroup49 IS NULL AND source.QryGroup49 IS NOT NULL OR target.QryGroup49 IS NOT NULL AND source.QryGroup49 IS NULL OR
    target.QryGroup50 <> source.QryGroup50 OR target.QryGroup50 IS NULL AND source.QryGroup50 IS NOT NULL OR target.QryGroup50 IS NOT NULL AND source.QryGroup50 IS NULL OR
    target.QryGroup51 <> source.QryGroup51 OR target.QryGroup51 IS NULL AND source.QryGroup51 IS NOT NULL OR target.QryGroup51 IS NOT NULL AND source.QryGroup51 IS NULL OR
    target.QryGroup52 <> source.QryGroup52 OR target.QryGroup52 IS NULL AND source.QryGroup52 IS NOT NULL OR target.QryGroup52 IS NOT NULL AND source.QryGroup52 IS NULL OR
    target.QryGroup53 <> source.QryGroup53 OR target.QryGroup53 IS NULL AND source.QryGroup53 IS NOT NULL OR target.QryGroup53 IS NOT NULL AND source.QryGroup53 IS NULL OR
    target.QryGroup54 <> source.QryGroup54 OR target.QryGroup54 IS NULL AND source.QryGroup54 IS NOT NULL OR target.QryGroup54 IS NOT NULL AND source.QryGroup54 IS NULL OR
    target.QryGroup55 <> source.QryGroup55 OR target.QryGroup55 IS NULL AND source.QryGroup55 IS NOT NULL OR target.QryGroup55 IS NOT NULL AND source.QryGroup55 IS NULL OR
    target.QryGroup56 <> source.QryGroup56 OR target.QryGroup56 IS NULL AND source.QryGroup56 IS NOT NULL OR target.QryGroup56 IS NOT NULL AND source.QryGroup56 IS NULL OR
    target.QryGroup57 <> source.QryGroup57 OR target.QryGroup57 IS NULL AND source.QryGroup57 IS NOT NULL OR target.QryGroup57 IS NOT NULL AND source.QryGroup57 IS NULL OR
    target.QryGroup58 <> source.QryGroup58 OR target.QryGroup58 IS NULL AND source.QryGroup58 IS NOT NULL OR target.QryGroup58 IS NOT NULL AND source.QryGroup58 IS NULL OR
    target.QryGroup59 <> source.QryGroup59 OR target.QryGroup59 IS NULL AND source.QryGroup59 IS NOT NULL OR target.QryGroup59 IS NOT NULL AND source.QryGroup59 IS NULL OR
    target.QryGroup60 <> source.QryGroup60 OR target.QryGroup60 IS NULL AND source.QryGroup60 IS NOT NULL OR target.QryGroup60 IS NOT NULL AND source.QryGroup60 IS NULL OR
    target.QryGroup61 <> source.QryGroup61 OR target.QryGroup61 IS NULL AND source.QryGroup61 IS NOT NULL OR target.QryGroup61 IS NOT NULL AND source.QryGroup61 IS NULL OR
    target.QryGroup62 <> source.QryGroup62 OR target.QryGroup62 IS NULL AND source.QryGroup62 IS NOT NULL OR target.QryGroup62 IS NOT NULL AND source.QryGroup62 IS NULL OR
    target.QryGroup63 <> source.QryGroup63 OR target.QryGroup63 IS NULL AND source.QryGroup63 IS NOT NULL OR target.QryGroup63 IS NOT NULL AND source.QryGroup63 IS NULL OR
    target.QryGroup64 <> source.QryGroup64 OR target.QryGroup64 IS NULL AND source.QryGroup64 IS NOT NULL OR target.QryGroup64 IS NOT NULL AND source.QryGroup64 IS NULL
	OR (target.EnAstSeri <> source.EnAstSeri OR target.EnAstSeri IS NULL AND source.EnAstSeri IS NOT NULL OR target.EnAstSeri IS NOT NULL AND source.EnAstSeri IS NULL)
    OR (target.U_Masivo <> source.U_Masivo OR target.U_Masivo IS NULL AND source.U_Masivo IS NOT NULL OR target.U_Masivo IS NOT NULL AND source.U_Masivo IS NULL)
    OR (target.U_NumEtiq <> source.U_NumEtiq OR target.U_NumEtiq IS NULL AND source.U_NumEtiq IS NOT NULL OR target.U_NumEtiq IS NOT NULL AND source.U_NumEtiq IS NULL)
    OR (target.U_Currency <> source.U_Currency OR target.U_Currency IS NULL AND source.U_Currency IS NOT NULL OR target.U_Currency IS NOT NULL AND source.U_Currency IS NULL)
    OR (target.U_Origin <> source.U_Origin OR target.U_Origin IS NULL AND source.U_Origin IS NOT NULL OR target.U_Origin IS NOT NULL AND source.U_Origin IS NULL)
    OR (target.U_FUCOSTO <> source.U_FUCOSTO OR target.U_FUCOSTO IS NULL AND source.U_FUCOSTO IS NOT NULL OR target.U_FUCOSTO IS NOT NULL AND source.U_FUCOSTO IS NULL)
    OR (target.U_VCOSTO <> source.U_VCOSTO OR target.U_VCOSTO IS NULL AND source.U_VCOSTO IS NOT NULL OR target.U_VCOSTO IS NOT NULL AND source.U_VCOSTO IS NULL)
    OR (target.U_VcostoA <> source.U_VcostoA OR target.U_VcostoA IS NULL AND source.U_VcostoA IS NOT NULL OR target.U_VcostoA IS NOT NULL AND source.U_VcostoA IS NULL)
    OR (target.U_TCostos <> source.U_TCostos OR target.U_TCostos IS NULL AND source.U_TCostos IS NOT NULL OR target.U_TCostos IS NOT NULL AND source.U_TCostos IS NULL)
    OR (target.U_FULTCOSTO <> source.U_FULTCOSTO OR target.U_FULTCOSTO IS NULL AND source.U_FULTCOSTO IS NOT NULL OR target.U_FULTCOSTO IS NOT NULL AND source.U_FULTCOSTO IS NULL)
    OR (target.U_TamEtiq <> source.U_TamEtiq OR target.U_TamEtiq IS NULL AND source.U_TamEtiq IS NOT NULL OR target.U_TamEtiq IS NOT NULL AND source.U_TamEtiq IS NULL)
    OR (target.U_Glosa <> source.U_Glosa OR target.U_Glosa IS NULL AND source.U_Glosa IS NOT NULL OR target.U_Glosa IS NOT NULL AND source.U_Glosa IS NULL)
    OR (target.U_Tproducto <> source.U_Tproducto OR target.U_Tproducto IS NULL AND source.U_Tproducto IS NOT NULL OR target.U_Tproducto IS NOT NULL AND source.U_Tproducto IS NULL)
    OR (target.U_Ubi_Primaria <> source.U_Ubi_Primaria OR target.U_Ubi_Primaria IS NULL AND source.U_Ubi_Primaria IS NOT NULL OR target.U_Ubi_Primaria IS NOT NULL AND source.U_Ubi_Primaria IS NULL)
    OR (target.U_Ubi_secundaria <> source.U_Ubi_secundaria OR target.U_Ubi_secundaria IS NULL AND source.U_Ubi_secundaria IS NOT NULL OR target.U_Ubi_secundaria IS NOT NULL AND source.U_Ubi_secundaria IS NULL)
    OR (target.U_Ubi_terciaria <> source.U_Ubi_terciaria OR target.U_Ubi_terciaria IS NULL AND source.U_Ubi_terciaria IS NOT NULL OR target.U_Ubi_terciaria IS NOT NULL AND source.U_Ubi_terciaria IS NULL)
    OR (target.U_REV <> source.U_REV OR target.U_REV IS NULL AND source.U_REV IS NOT NULL OR target.U_REV IS NOT NULL AND source.U_REV IS NULL)
    OR (target.OnHand <> source.OnHand OR target.OnHand IS NULL AND source.OnHand IS NOT NULL OR target.OnHand IS NOT NULL AND source.OnHand IS NULL)
)
   THEN UPDATE SET
    target.ItemName = source.ItemName,
    target.FrgnName = source.FrgnName,
    target.ItmsGrpCod = source.ItmsGrpCod,
    target.CstGrpCode = source.CstGrpCode,
    target.VatGourpSa = source.VatGourpSa,
    target.CodeBars = source.CodeBars,
    target.VATLiable = source.VATLiable,
    target.PrchseItem = source.PrchseItem,
    target.SellItem = source.SellItem,
    target.InvntItem = source.InvntItem,
    target.CardCode = source.CardCode,
    target.DscountCod = source.DscountCod,
    target.SLen2Unit = source.SLen2Unit,
    target.SVolume = source.SVolume,
    target.SVolUnit = source.SVolUnit,
    target.SWeight1 = source.SWeight1,
    target.SWght1Unit = source.SWght1Unit,
    target.SWeight2 = source.SWeight2,
    target.SWght2Unit = source.SWght2Unit,
    target.BHeight1 = source.BHeight1,
    target.BHght1Unit = source.BHght1Unit,
    target.BHeight2 = source.BHeight2,
    target.BHght2Unit = source.BHght2Unit,
    target.BWidth1 = source.BWidth1,
    target.BWdth1Unit = source.BWdth1Unit,
    target.BWidth2 = source.BWidth2,
    target.BWdth2Unit = source.BWdth2Unit,
    target.BLength1 = source.BLength1,
    target.BLen1Unit = source.BLen1Unit,
    target.Blength2 = source.Blength2,
    target.BLen2Unit = source.BLen2Unit,
    target.FixCurrCms = source.FixCurrCms,
    target.FirmCode = source.FirmCode,
    target.LstSalDate = source.LstSalDate,
    target.CreateDate = source.CreateDate,
    target.UpdateDate = source.UpdateDate,
    target.validFor = source.validFor,
    target.validFrom = source.validFrom,
    target.validTo = source.validTo,
    target.frozenFor = source.frozenFor,
    target.frozenFrom = source.frozenFrom,
    target.frozenTo = source.frozenTo,
    target.BlockOut = source.BlockOut,
    target.QryGroup1 = source.QryGroup1,
    target.QryGroup2 = source.QryGroup2,
    target.QryGroup3 = source.QryGroup3,
    target.QryGroup4 = source.QryGroup4,
    target.QryGroup5 = source.QryGroup5,
    target.QryGroup6 = source.QryGroup6,
    target.QryGroup7 = source.QryGroup7,
    target.QryGroup8 = source.QryGroup8,
    target.QryGroup9 = source.QryGroup9,
    target.QryGroup10 = source.QryGroup10,
    target.QryGroup11 = source.QryGroup11,
    target.QryGroup12 = source.QryGroup12,
    target.QryGroup13 = source.QryGroup13,
    target.QryGroup14 = source.QryGroup14,
    target.QryGroup15 = source.QryGroup15,
    target.QryGroup16 = source.QryGroup16,
    target.QryGroup17 = source.QryGroup17,
    target.QryGroup18 = source.QryGroup18,
    target.QryGroup19 = source.QryGroup19,
    target.QryGroup20 = source.QryGroup20,
    target.QryGroup21 = source.QryGroup21,
    target.QryGroup22 = source.QryGroup22,
    target.QryGroup23 = source.QryGroup23,
    target.QryGroup24 = source.QryGroup24,
    target.QryGroup25 = source.QryGroup25,
    target.QryGroup26 = source.QryGroup26,
    target.QryGroup27 = source.QryGroup27,
    target.QryGroup28 = source.QryGroup28,
    target.QryGroup29 = source.QryGroup29,
    target.QryGroup30 = source.QryGroup30,
    target.QryGroup31 = source.QryGroup31,
    target.QryGroup32 = source.QryGroup32,
    target.QryGroup33 = source.QryGroup33,
    target.QryGroup34 = source.QryGroup34,
    target.QryGroup35 = source.QryGroup35,
    target.QryGroup36 = source.QryGroup36,
    target.QryGroup37 = source.QryGroup37,
    target.QryGroup38 = source.QryGroup38,
    target.QryGroup39 = source.QryGroup39,
    target.QryGroup40 = source.QryGroup40,
    target.QryGroup41 = source.QryGroup41,
    target.QryGroup42 = source.QryGroup42,
    target.QryGroup43 = source.QryGroup43,
    target.QryGroup44 = source.QryGroup44,
    target.QryGroup45 = source.QryGroup45,
    target.QryGroup46 = source.QryGroup46,
    target.QryGroup47 = source.QryGroup47,
    target.QryGroup48 = source.QryGroup48,
    target.QryGroup49 = source.QryGroup49,
    target.QryGroup50 = source.QryGroup50,
    target.QryGroup51 = source.QryGroup51,
    target.QryGroup52 = source.QryGroup52,
    target.QryGroup53 = source.QryGroup53,
    target.QryGroup54 = source.QryGroup54,
    target.QryGroup55 = source.QryGroup55,
    target.QryGroup56 = source.QryGroup56,
    target.QryGroup57 = source.QryGroup57,
    target.QryGroup58 = source.QryGroup58,
    target.QryGroup59 = source.QryGroup59,
    target.QryGroup60 = source.QryGroup60,
    target.QryGroup61 = source.QryGroup61,
    target.QryGroup62 = source.QryGroup62,
    target.QryGroup63 = source.QryGroup63,
    target.QryGroup64 = source.QryGroup64,
    target.EnAstSeri = source.EnAstSeri,
    target.U_Masivo = source.U_Masivo,
    target.U_NumEtiq = source.U_NumEtiq,
    target.U_Currency = source.U_Currency,
    target.U_Origin = source.U_Origin,
    target.U_FUCOSTO = source.U_FUCOSTO,
    target.U_VCOSTO = source.U_VCOSTO,
    target.U_VcostoA = source.U_VcostoA,
    target.U_TCostos = source.U_TCostos,
    target.U_FULTCOSTO = source.U_FULTCOSTO,
    target.U_TamEtiq = source.U_TamEtiq,
    target.U_Glosa = source.U_Glosa,
    target.U_Tproducto = source.U_Tproducto,
    target.U_Ubi_Primaria = source.U_Ubi_Primaria,
    target.U_Ubi_secundaria = source.U_Ubi_secundaria,
    target.U_Ubi_terciaria = source.U_Ubi_terciaria,
    target.U_REV = source.U_REV,
    target.OnHand = source.OnHand

		
    WHEN NOT MATCHED THEN 
   INSERT (
    ItemCode, ItemName, FrgnName, ItmsGrpCod, CstGrpCode, VatGourpSa, CodeBars, VATLiable,
    PrchseItem, SellItem, InvntItem, CardCode, DscountCod, SLen2Unit, SVolume, SVolUnit,
    SWeight1, SWght1Unit, SWeight2, SWght2Unit, BHeight1, BHght1Unit, BHeight2, BHght2Unit,
    BWidth1, BWdth1Unit, BWidth2, BWdth2Unit, BLength1, BLen1Unit, Blength2, BLen2Unit,
    FixCurrCms, FirmCode, LstSalDate, CreateDate, UpdateDate, validFor, validFrom, validTo,
    frozenFor, frozenFrom, frozenTo,QryGroup1, QryGroup2, QryGroup3, QryGroup4, QryGroup5, 
	QryGroup6, QryGroup7, QryGroup8, QryGroup9, QryGroup10, QryGroup11, QryGroup12, QryGroup13,
	QryGroup14, QryGroup15, QryGroup16, QryGroup17, QryGroup18, QryGroup19, QryGroup20, QryGroup21,
	QryGroup22, QryGroup23, QryGroup24, QryGroup25, QryGroup26, QryGroup27, QryGroup28, QryGroup29,
	QryGroup30, QryGroup31, QryGroup32, QryGroup33, QryGroup34, QryGroup35, QryGroup36, QryGroup37,
	QryGroup38, QryGroup39, QryGroup40, QryGroup41, QryGroup42, QryGroup43, QryGroup44, QryGroup45, 
	QryGroup46, QryGroup47, QryGroup48, QryGroup49, QryGroup50, QryGroup51, QryGroup52, QryGroup53, 
	QryGroup54, QryGroup55, QryGroup56, QryGroup57, QryGroup58, QryGroup59, QryGroup60, QryGroup61, 
	QryGroup62, QryGroup63, QryGroup64,
	BlockOut, EnAstSeri, U_Masivo, U_NumEtiq, U_Currency,
    U_Origin, U_FUCOSTO, U_VCOSTO, U_VcostoA, U_TCostos, U_FULTCOSTO, U_TamEtiq, U_Glosa,
    U_Tproducto, U_Ubi_Primaria, U_Ubi_secundaria, U_Ubi_terciaria, U_REV, OnHand
)
VALUES (
    source.ItemCode, source.ItemName, source.FrgnName, source.ItmsGrpCod, source.CstGrpCode, source.VatGourpSa, source.CodeBars, source.VATLiable,
    source.PrchseItem, source.SellItem, source.InvntItem, source.CardCode, source.DscountCod, source.SLen2Unit, source.SVolume, source.SVolUnit,
    source.SWeight1, source.SWght1Unit, source.SWeight2, source.SWght2Unit, source.BHeight1, source.BHght1Unit, source.BHeight2, source.BHght2Unit,
    source.BWidth1, source.BWdth1Unit, source.BWidth2, source.BWdth2Unit, source.BLength1, source.BLen1Unit, source.Blength2, source.BLen2Unit,
    source.FixCurrCms, source.FirmCode, source.LstSalDate, source.CreateDate, source.UpdateDate, source.validFor, source.validFrom, source.validTo,
    source.frozenFor, source.frozenFrom, source.frozenTo, source.BlockOut,  source.QryGroup1, source.QryGroup2, source.QryGroup3, source.QryGroup4, 
	source.QryGroup5, source.QryGroup6, source.QryGroup7, source.QryGroup8, source.QryGroup9, source.QryGroup10, source.QryGroup11, source.QryGroup12,
	source.QryGroup13, source.QryGroup14, source.QryGroup15, source.QryGroup16, source.QryGroup17, source.QryGroup18, source.QryGroup19, source.QryGroup20, 
	
	source.QryGroup21, source.QryGroup22, source.QryGroup23, source.QryGroup24, source.QryGroup25, source.QryGroup26, source.QryGroup27, source.QryGroup28, 
	source.QryGroup29, source.QryGroup30, source.QryGroup31, source.QryGroup32, source.QryGroup33, source.QryGroup34, source.QryGroup35, source.QryGroup36, 
	source.QryGroup37, source.QryGroup38, source.QryGroup39, source.QryGroup40, source.QryGroup41, source.QryGroup42, source.QryGroup43, source.QryGroup44, 
	source.QryGroup45, source.QryGroup46, source.QryGroup47, source.QryGroup48, source.QryGroup49, source.QryGroup50, source.QryGroup51, source.QryGroup52, 
	source.QryGroup53, source.QryGroup54, source.QryGroup55, source.QryGroup56, source.QryGroup57, source.QryGroup58, source.QryGroup59, source.QryGroup60, 
	source.QryGroup61, source.QryGroup62, source.QryGroup63, source.QryGroup64,
	source.EnAstSeri, source.U_Masivo, source.U_NumEtiq, source.U_Currency,
    source.U_Origin, source.U_FUCOSTO, source.U_VCOSTO, source.U_VcostoA, source.U_TCostos, source.U_FULTCOSTO, source.U_TamEtiq, source.U_Glosa,
    source.U_Tproducto, source.U_Ubi_Primaria, source.U_Ubi_secundaria, source.U_Ubi_terciaria, source.U_REV, source.OnHand
);

    PRINT 'Sincronización de OITM completada exitosamente';

END;
GO
/****** Object:  StoredProcedure [dbo].[SYNC_OITW]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SYNC_OITW]
AS
BEGIN
    SET NOCOUNT ON;

    -- *** Sincronización de OITW (Stock por Bodega) ***
    MERGE INTO DATANWO.dbo.app_oitw AS target
    USING (
        SELECT 
            ItemCode COLLATE SQL_Latin1_General_CP1_CI_AS AS ItemCode, 
            WhsCode COLLATE SQL_Latin1_General_CP1_CI_AS AS WhsCode, 
            ISNULL(OnHand, 0) AS OnHand,  -- Asegurar que no haya valores NULL
            CAST(ISNULL(AvgPrice, 0) AS NUMERIC(19,6)) AS AvgPrice -- Asegurar conversión segura
        FROM [serv-sap].anwo_produccion.dbo.OITW
    ) AS source
    ON target.ItemCode = source.ItemCode 
       AND target.WhsCode = source.WhsCode
    WHEN MATCHED AND (
        target.OnHand <> source.OnHand OR
        target.AvgPrice <> source.AvgPrice
    )
    THEN UPDATE SET
        target.OnHand = source.OnHand,
        target.AvgPrice = source.AvgPrice
    WHEN NOT MATCHED THEN 
    INSERT (ItemCode, WhsCode, OnHand, AvgPrice)
    VALUES (source.ItemCode, source.WhsCode, source.OnHand, source.AvgPrice);

    PRINT 'Sincronización de OITW completada exitosamente';

END;
GO
/****** Object:  StoredProcedure [dbo].[SYNC_OQUT]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SYNC_OQUT]
AS
BEGIN
    DECLARE @periodo INT = YEAR(DATEADD(YEAR, -5, GETDATE()));
    SET NOCOUNT ON;

    MERGE INTO DATANWO.dbo.app_oqut AS target
    USING (
        SELECT
            oqut.DocEntry AS DocEntry,
            oqut.DocNum AS DocNum,
            ISNULL(oqut.DocType, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS DocType,
            oqut.DocDueDate AS DocDueDate,
            oqut.DocTotal AS DocTotal,
            oqut.VatSum AS VatSum,
            oqut.CardCode AS CardCode,
            oqut.DocDate AS DocDate,
            oqut.DiscPrcnt AS DiscPrcnt,
            ISNULL(oqut.ObjType, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS ObjType,
            oqut.Series AS Series
        FROM [serv-sap].anwo_produccion.dbo.OQUT oqut
            WHERE 
            YEAR(oqut.DocDate) >= @periodo
            AND EXISTS (
                SELECT 1 
                FROM DATANWO.dbo.app_ocrd ocrd
                WHERE ocrd.CardCode COLLATE SQL_Latin1_General_CP1_CI_AS = oqut.CardCode
            )

    ) AS source
    ON target.DocEntry = source.DocEntry

	WHEN MATCHED AND (
		target.DocNum <> source.DocNum OR
		target.DocType COLLATE SQL_Latin1_General_CP1_CI_AS <> source.DocType OR
		target.DocDueDate <> source.DocDueDate OR
		target.DocTotal <> source.DocTotal OR
		target.VatSum <> source.VatSum OR
		target.CardCode COLLATE SQL_Latin1_General_CP1_CI_AS <> source.CardCode OR
		target.DocDate <> source.DocDate OR
		target.DiscPrcnt <> source.DiscPrcnt OR
		target.ObjType COLLATE SQL_Latin1_General_CP1_CI_AS <> source.ObjType OR
		target.Series <> source.Series OR

		(target.DocType IS NULL AND source.DocType IS NOT NULL) OR
		(target.DocType IS NOT NULL AND source.DocType IS NULL) OR
		(target.ObjType IS NULL AND source.ObjType IS NOT NULL) OR
		(target.ObjType IS NOT NULL AND source.ObjType IS NULL) OR
		(target.CardCode IS NULL AND source.CardCode IS NOT NULL) OR
		(target.CardCode IS NOT NULL AND source.CardCode IS NULL)
	)

    THEN UPDATE SET
        target.DocNum = source.DocNum,
        target.DocType = source.DocType,
        target.DocDueDate = source.DocDueDate,
        target.DocTotal = source.DocTotal,
        target.VatSum = source.VatSum,
        target.CardCode = source.CardCode,
        target.DocDate = source.DocDate,
        target.DiscPrcnt = source.DiscPrcnt,
        target.ObjType = source.ObjType,
        target.Series = source.Series

    WHEN NOT MATCHED THEN
    INSERT (DocEntry, DocNum, DocType, DocDueDate, DocTotal, VatSum, CardCode, DocDate, DiscPrcnt, ObjType, Series)
    VALUES (source.DocEntry, source.DocNum, source.DocType, source.DocDueDate, source.DocTotal, source.VatSum, source.CardCode, source.DocDate, source.DiscPrcnt, source.ObjType, source.Series);

    PRINT 'Sincronización de OQUT completada exitosamente';
END;
GO
/****** Object:  StoredProcedure [dbo].[SYNC_ORDR]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SYNC_ORDR]
AS
BEGIN
    DECLARE @periodo INT = YEAR(DATEADD(YEAR, -5, GETDATE()));
    SET NOCOUNT ON;

    MERGE INTO DATANWO.dbo.app_ordr AS target
    USING (
        SELECT
            ordr.DocEntry AS DocEntry,
            ordr.DocNum AS DocNum,
            ISNULL(ordr.DocType, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS DocType,
            ordr.DocDueDate AS DocDueDate,
            ordr.DocTotal AS DocTotal,
            ordr.VatSum AS VatSum,
            ordr.CardCode COLLATE SQL_Latin1_General_CP1_CI_AS AS CardCode,
            ordr.DocDate AS DocDate,
            ordr.DiscPrcnt AS DiscPrcnt,
            ISNULL(ordr.ObjType, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS ObjType,
            ordr.Series AS Series
        FROM [serv-sap].anwo_produccion.dbo.ORDR ordr
        WHERE
            YEAR(ordr.DocDate) >= @periodo AND
            EXISTS (
                SELECT 1
                FROM DATANWO.dbo.app_ocrd ocrd
                WHERE ocrd.CardCode COLLATE SQL_Latin1_General_CP1_CI_AS = ordr.CardCode COLLATE SQL_Latin1_General_CP1_CI_AS
            )
    ) AS source
    ON target.DocEntry = source.DocEntry

    WHEN MATCHED AND (
        target.DocNum <> source.DocNum OR
        target.DocType <> source.DocType OR
        target.DocDueDate <> source.DocDueDate OR
        target.DocTotal <> source.DocTotal OR
        target.VatSum <> source.VatSum OR
        target.CardCode COLLATE SQL_Latin1_General_CP1_CI_AS <> source.CardCode COLLATE SQL_Latin1_General_CP1_CI_AS OR
        target.DocDate <> source.DocDate OR
        target.DiscPrcnt <> source.DiscPrcnt OR
        target.ObjType <> source.ObjType OR
        target.Series <> source.Series OR
        target.DocType IS NULL AND source.DocType IS NOT NULL OR
        target.DocType IS NOT NULL AND source.DocType IS NULL OR
        target.ObjType IS NULL AND source.ObjType IS NOT NULL OR
        target.ObjType IS NOT NULL AND source.ObjType IS NULL
    )
    THEN UPDATE SET
        target.DocNum = source.DocNum,
        target.DocType = source.DocType,
        target.DocDueDate = source.DocDueDate,
        target.DocTotal = source.DocTotal,
        target.VatSum = source.VatSum,
        target.CardCode = source.CardCode,
        target.DocDate = source.DocDate,
        target.DiscPrcnt = source.DiscPrcnt,
        target.ObjType = source.ObjType,
        target.Series = source.Series

    WHEN NOT MATCHED THEN
    INSERT (DocEntry, DocNum, DocType, DocDueDate, DocTotal, VatSum, CardCode, DocDate, DiscPrcnt, ObjType, Series)
    VALUES (source.DocEntry, source.DocNum, source.DocType, source.DocDueDate, source.DocTotal, source.VatSum, source.CardCode, source.DocDate, source.DiscPrcnt, source.ObjType, source.Series);

    PRINT 'Sincronización de ORDR completada exitosamente';
END;

GO
/****** Object:  StoredProcedure [dbo].[SYNC_ORIN]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SYNC_ORIN]
AS
BEGIN


DECLARE @periodo INT = YEAR(DATEADD(YEAR, -5, GETDATE()));

    SET NOCOUNT ON;

    -- *** Sincronización de ORIN (Notas de Crédito) ***
    MERGE INTO DATANWO.dbo.app_orin AS target
    USING (
        SELECT 
            CAST(o.DocEntry AS INT) AS DocEntry,  -- Clave primaria
            CAST(o.DocNum AS INT) AS DocNum,
            o.DocType COLLATE SQL_Latin1_General_CP1_CI_AS AS DocType,
            o.DocDueDate,
            CAST(o.DocTotal AS NUMERIC(19,6)) AS DocTotal,
            CAST(o.VatSum AS NUMERIC(19,6)) AS VatSum,
            o.CardCode COLLATE SQL_Latin1_General_CP1_CI_AS AS CardCode,  -- FK correcta
            o.DocDate,
            CAST(o.DiscPrcnt AS NUMERIC(16,6)) AS DiscPrcnt,
            o.ObjType COLLATE SQL_Latin1_General_CP1_CI_AS AS ObjType,
            CAST(o.Series AS INT) AS Series
        FROM [serv-sap].anwo_produccion.dbo.ORIN o
		where year(o.DocDate) >= @periodo
       
    ) AS source
    ON target.DocEntry = source.DocEntry
    WHEN MATCHED AND (
    target.DocNum <> source.DocNum OR
    target.DocNum IS NULL AND source.DocNum IS NOT NULL OR
    target.DocNum IS NOT NULL AND source.DocNum IS NULL OR

    target.DocType COLLATE SQL_Latin1_General_CP1_CI_AS <> source.DocType OR
    target.DocType IS NULL AND source.DocType IS NOT NULL OR
    target.DocType IS NOT NULL AND source.DocType IS NULL OR

    target.DocDueDate <> source.DocDueDate OR
    target.DocDueDate IS NULL AND source.DocDueDate IS NOT NULL OR
    target.DocDueDate IS NOT NULL AND source.DocDueDate IS NULL OR

    target.DocTotal <> source.DocTotal OR
    target.DocTotal IS NULL AND source.DocTotal IS NOT NULL OR
    target.DocTotal IS NOT NULL AND source.DocTotal IS NULL OR

    target.VatSum <> source.VatSum OR
    target.VatSum IS NULL AND source.VatSum IS NOT NULL OR
    target.VatSum IS NOT NULL AND source.VatSum IS NULL OR

    target.CardCode COLLATE SQL_Latin1_General_CP1_CI_AS <> source.CardCode OR
    target.CardCode IS NULL AND source.CardCode IS NOT NULL OR
    target.CardCode IS NOT NULL AND source.CardCode IS NULL OR

    target.DocDate <> source.DocDate OR
    target.DocDate IS NULL AND source.DocDate IS NOT NULL OR
    target.DocDate IS NOT NULL AND source.DocDate IS NULL OR

    target.DiscPrcnt <> source.DiscPrcnt OR
    target.DiscPrcnt IS NULL AND source.DiscPrcnt IS NOT NULL OR
    target.DiscPrcnt IS NOT NULL AND source.DiscPrcnt IS NULL OR

    target.ObjType COLLATE SQL_Latin1_General_CP1_CI_AS <> source.ObjType OR
    target.ObjType IS NULL AND source.ObjType IS NOT NULL OR
    target.ObjType IS NOT NULL AND source.ObjType IS NULL OR

    target.Series <> source.Series OR
    target.Series IS NULL AND source.Series IS NOT NULL OR
    target.Series IS NOT NULL AND source.Series IS NULL
)

    THEN UPDATE SET
        target.DocNum = source.DocNum,
        target.DocType = source.DocType,
        target.DocDueDate = source.DocDueDate,
        target.DocTotal = source.DocTotal,
        target.VatSum = source.VatSum,
        target.CardCode = source.CardCode,
        target.DocDate = source.DocDate,
        target.DiscPrcnt = source.DiscPrcnt,
        target.ObjType = source.ObjType,
        target.Series = source.Series
    WHEN NOT MATCHED THEN 
    INSERT (DocEntry, DocNum, DocType, DocDueDate, DocTotal, VatSum, CardCode, DocDate, DiscPrcnt, ObjType, Series)
    VALUES (source.DocEntry, source.DocNum, source.DocType, source.DocDueDate, source.DocTotal, source.VatSum, source.CardCode, source.DocDate, source.DiscPrcnt, source.ObjType, source.Series);

    PRINT 'Sincronización de ORIN completada exitosamente';
END;
GO
/****** Object:  StoredProcedure [dbo].[SYNC_ORTT]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SYNC_ORTT]
AS
BEGIN
DECLARE @periodo INT = YEAR(DATEADD(YEAR, -5, GETDATE()));

    SET NOCOUNT ON;

    -- *** 2? ORTT (Maestro de Tipo de Cambio) ***
    MERGE DATANWO.dbo.app_ortt AS target
    USING (
        SELECT 
            RateDate, 
            Currency COLLATE SQL_Latin1_General_CP1_CI_AS AS Currency, 
            CAST(Rate AS NUMERIC(19,6)) AS Rate
        FROM [serv-sap].anwo_produccion.dbo.ORTT as o
		 WHERE year(o.RateDate) >= @periodo 
    ) AS source
    ON target.RateDate = source.RateDate AND target.Currency = source.Currency
    WHEN MATCHED AND target.Rate <> source.Rate
    THEN UPDATE SET
        target.Rate = source.Rate
    WHEN NOT MATCHED THEN 
    INSERT (RateDate, Currency, Rate)
    VALUES (source.RateDate, source.Currency, source.Rate);

    PRINT 'Sincronización de ORTT completada exitosamente';

END;
GO
/****** Object:  StoredProcedure [dbo].[SYNC_OSLP]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[SYNC_OSLP]
AS
BEGIN
    SET NOCOUNT ON;

        MERGE dbo.app_OSLP AS target
        USING (
            SELECT 
                SlpCode,
                SlpName COLLATE DATABASE_DEFAULT AS SlpName,
                Memo COLLATE DATABASE_DEFAULT AS Memo,
                Commission,
                GroupCode,
                Locked COLLATE DATABASE_DEFAULT AS Locked,
                DataSource COLLATE DATABASE_DEFAULT AS DataSource,
                UserSign,
                EmpID,
                Active COLLATE DATABASE_DEFAULT AS Active,
                Telephone COLLATE DATABASE_DEFAULT AS Telephone,
                Mobil COLLATE DATABASE_DEFAULT AS Mobil,
                Fax COLLATE DATABASE_DEFAULT AS Fax,
                Email COLLATE DATABASE_DEFAULT AS Email,
                DPPStatus COLLATE DATABASE_DEFAULT AS DPPStatus,
                EncryptIV COLLATE DATABASE_DEFAULT AS EncryptIV,
                U_CostoPersona
            FROM [serv-sap].Anwo_Produccion.dbo.OSLP
			WHERE LTRIM(RTRIM(ISNULL(Active, ''))) = 'Y'

        ) AS source
        ON target.SlpCode = source.SlpCode

        -- Condiciones para actualización: valores distintos o nullidad cambiante
        WHEN MATCHED AND (
            ISNULL(NULLIF(target.SlpName, ''), '') <> ISNULL(NULLIF(source.SlpName, ''), '') OR
            ISNULL(NULLIF(target.Memo, ''), '') <> ISNULL(NULLIF(source.Memo, ''), '') OR
            ISNULL(target.Commission, 0) <> ISNULL(source.Commission, 0) OR
            ISNULL(target.GroupCode, -1) <> ISNULL(source.GroupCode, -1) OR
            ISNULL(NULLIF(target.Locked, ''), '') <> ISNULL(NULLIF(source.Locked, ''), '') OR
            ISNULL(NULLIF(target.DataSource, ''), '') <> ISNULL(NULLIF(source.DataSource, ''), '') OR
            ISNULL(target.UserSign, -1) <> ISNULL(source.UserSign, -1) OR
            ISNULL(target.EmpID, -1) <> ISNULL(source.EmpID, -1) OR
            ISNULL(NULLIF(target.Active, ''), '') <> ISNULL(NULLIF(source.Active, ''), '') OR
            ISNULL(NULLIF(target.Telephone, ''), '') <> ISNULL(NULLIF(source.Telephone, ''), '') OR
            ISNULL(NULLIF(target.Mobil, ''), '') <> ISNULL(NULLIF(source.Mobil, ''), '') OR
            ISNULL(NULLIF(target.Fax, ''), '') <> ISNULL(NULLIF(source.Fax, ''), '') OR
            ISNULL(NULLIF(target.Email, ''), '') <> ISNULL(NULLIF(source.Email, ''), '') OR
            ISNULL(NULLIF(target.DPPStatus, ''), '') <> ISNULL(NULLIF(source.DPPStatus, ''), '') OR
            ISNULL(NULLIF(target.EncryptIV, ''), '') <> ISNULL(NULLIF(source.EncryptIV, ''), '') OR
            ISNULL(target.U_CostoPersona, -1) <> ISNULL(source.U_CostoPersona, -1)
        )
        THEN UPDATE SET
            target.SlpName = source.SlpName,
            target.Memo = source.Memo,
            target.Commission = source.Commission,
            target.GroupCode = source.GroupCode,
            target.Locked = source.Locked,
            target.DataSource = source.DataSource,
            target.UserSign = source.UserSign,
            target.EmpID = source.EmpID,
            target.Active = source.Active,
            target.Telephone = source.Telephone,
            target.Mobil = source.Mobil,
            target.Fax = source.Fax,
            target.Email = source.Email,
            target.DPPStatus = source.DPPStatus,
            target.EncryptIV = source.EncryptIV,
            target.U_CostoPersona = source.U_CostoPersona

        WHEN NOT MATCHED BY TARGET THEN
            INSERT (SlpCode, SlpName, Memo, Commission, GroupCode, Locked,
                DataSource, UserSign, EmpID, Active, Telephone, Mobil,
                Fax, Email, DPPStatus, EncryptIV, U_CostoPersona)
            VALUES (
                source.SlpCode, source.SlpName, source.Memo, source.Commission, source.GroupCode,
                source.Locked, source.DataSource, source.UserSign, source.EmpID, source.Active,
                source.Telephone, source.Mobil, source.Fax, source.Email,source.DPPStatus,
                source.EncryptIV, source.U_CostoPersona
            );

    PRINT 'Sincronización de OSLP completada exitosamente';
END
GO
/****** Object:  StoredProcedure [dbo].[SYNC_OWHS]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SYNC_OWHS]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO DATANWO.dbo.app_owhs target
    USING (
        -- Agrupar por WhsCode para garantizar unicidad
        SELECT 
            ow.WhsCode COLLATE SQL_Latin1_General_CP1_CI_AS AS WhsCode,
            MAX(ow.WhsName) COLLATE SQL_Latin1_General_CP1_CI_AS AS WhsName,  -- Evita valores nulos
            SUM(oitw.OnHand) AS OnHand  
        FROM [serv-sap].anwo_produccion.dbo.OWHS ow
        LEFT JOIN [serv-sap].anwo_produccion.dbo.OITW oitw
            ON ow.WhsCode COLLATE SQL_Latin1_General_CP1_CI_AS = oitw.WhsCode
        GROUP BY ow.WhsCode
    ) AS source
    ON target.WhsCode = source.WhsCode

    WHEN MATCHED AND (
        target.WhsName <> source.WhsName OR
        (target.WhsName IS NULL AND source.WhsName IS NOT NULL) OR
        (target.WhsName IS NOT NULL AND source.WhsName IS NULL) OR
        target.OnHand <> source.OnHand OR
        (target.OnHand IS NULL AND source.OnHand IS NOT NULL) OR
        (target.OnHand IS NOT NULL AND source.OnHand IS NULL)
    )
    THEN UPDATE SET
        target.WhsName = source.WhsName,
        target.OnHand = source.OnHand

    WHEN NOT MATCHED THEN 
    INSERT (WhsCode, OnHand, WhsName)
    VALUES (source.WhsCode, source.OnHand, source.WhsName);

    PRINT 'Sincronización de OWHS completada exitosamente';
END;
GO
/****** Object:  StoredProcedure [dbo].[SYNC_PRESUPUESTO_B1]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SYNC_PRESUPUESTO_B1]
AS
BEGIN


DECLARE @periodo INT = YEAR(DATEADD(YEAR, -5, GETDATE()));

    SET NOCOUNT ON;

    -- *** Sincronización de PRESUPUESTO_B1 ***
    MERGE INTO DATANWO.dbo.app_presupuesto_b1 AS target
    USING (
        SELECT 
            p.U_Sucursal COLLATE SQL_Latin1_General_CP1_CI_AS AS U_Sucursal,
            p.U_Linea COLLATE SQL_Latin1_General_CP1_CI_AS AS U_Linea,
            CAST(p.U_Periodo AS INT) AS U_Periodo,
            CAST(p.U_Enero AS NUMERIC(19,6)) AS U_Enero,
            CAST(p.U_Febrero AS NUMERIC(19,6)) AS U_Febrero,
            CAST(p.U_Marzo AS NUMERIC(19,6)) AS U_Marzo,
            CAST(p.U_Abril AS NUMERIC(19,6)) AS U_Abril,
            CAST(p.U_Mayo AS NUMERIC(19,6)) AS U_Mayo,
            CAST(p.U_Junio AS NUMERIC(19,6)) AS U_Junio,
            CAST(p.U_Julio AS NUMERIC(19,6)) AS U_Julio,
            CAST(p.U_Agosto AS NUMERIC(19,6)) AS U_Agosto,
            CAST(p.U_Septiembre AS NUMERIC(19,6)) AS U_Septiembre,
            CAST(p.U_Octubre AS NUMERIC(19,6)) AS U_Octubre,
            CAST(p.U_Noviembre AS NUMERIC(19,6)) AS U_Noviembre,
            CAST(p.U_Diciembre AS NUMERIC(19,6)) AS U_Diciembre
        FROM [serv-sap].[Anwo_Produccion].[dbo].[@PRESUPUESTOS] p
		WHERE CAST(p.U_Periodo AS INT) >= @periodo

    ) AS source
    ON target.U_Sucursal = source.U_Sucursal AND target.U_Linea = source.U_Linea AND target.U_Periodo = source.U_Periodo
	WHEN MATCHED AND (
		target.U_Enero <> source.U_Enero OR (target.U_Enero IS NULL AND source.U_Enero IS NOT NULL) OR (target.U_Enero IS NOT NULL AND source.U_Enero IS NULL) OR
		target.U_Febrero <> source.U_Febrero OR (target.U_Febrero IS NULL AND source.U_Febrero IS NOT NULL) OR (target.U_Febrero IS NOT NULL AND source.U_Febrero IS NULL) OR
		target.U_Marzo <> source.U_Marzo OR (target.U_Marzo IS NULL AND source.U_Marzo IS NOT NULL) OR (target.U_Marzo IS NOT NULL AND source.U_Marzo IS NULL) OR
		target.U_Abril <> source.U_Abril OR (target.U_Abril IS NULL AND source.U_Abril IS NOT NULL) OR (target.U_Abril IS NOT NULL AND source.U_Abril IS NULL) OR
		target.U_Mayo <> source.U_Mayo OR (target.U_Mayo IS NULL AND source.U_Mayo IS NOT NULL) OR (target.U_Mayo IS NOT NULL AND source.U_Mayo IS NULL) OR
		target.U_Junio <> source.U_Junio OR (target.U_Junio IS NULL AND source.U_Junio IS NOT NULL) OR (target.U_Junio IS NOT NULL AND source.U_Junio IS NULL) OR
		target.U_Julio <> source.U_Julio OR (target.U_Julio IS NULL AND source.U_Julio IS NOT NULL) OR (target.U_Julio IS NOT NULL AND source.U_Julio IS NULL) OR
		target.U_Agosto <> source.U_Agosto OR (target.U_Agosto IS NULL AND source.U_Agosto IS NOT NULL) OR (target.U_Agosto IS NOT NULL AND source.U_Agosto IS NULL) OR
		target.U_Septiembre <> source.U_Septiembre OR (target.U_Septiembre IS NULL AND source.U_Septiembre IS NOT NULL) OR (target.U_Septiembre IS NOT NULL AND source.U_Septiembre IS NULL) OR
		target.U_Octubre <> source.U_Octubre OR (target.U_Octubre IS NULL AND source.U_Octubre IS NOT NULL) OR (target.U_Octubre IS NOT NULL AND source.U_Octubre IS NULL) OR
		target.U_Noviembre <> source.U_Noviembre OR (target.U_Noviembre IS NULL AND source.U_Noviembre IS NOT NULL) OR (target.U_Noviembre IS NOT NULL AND source.U_Noviembre IS NULL) OR
		target.U_Diciembre <> source.U_Diciembre OR (target.U_Diciembre IS NULL AND source.U_Diciembre IS NOT NULL) OR (target.U_Diciembre IS NOT NULL AND source.U_Diciembre IS NULL)
	)

    THEN UPDATE SET
        target.U_Enero = source.U_Enero,
        target.U_Febrero = source.U_Febrero,
        target.U_Marzo = source.U_Marzo,
        target.U_Abril = source.U_Abril,
        target.U_Mayo = source.U_Mayo,
        target.U_Junio = source.U_Junio,
        target.U_Julio = source.U_Julio,
        target.U_Agosto = source.U_Agosto,
        target.U_Septiembre = source.U_Septiembre,
        target.U_Octubre = source.U_Octubre,
        target.U_Noviembre = source.U_Noviembre,
        target.U_Diciembre = source.U_Diciembre
    WHEN NOT MATCHED THEN 
    INSERT (U_Sucursal, U_Linea, U_Periodo, U_Enero, U_Febrero, U_Marzo, U_Abril, U_Mayo, U_Junio, U_Julio, U_Agosto, U_Septiembre, U_Octubre, U_Noviembre, U_Diciembre)
    VALUES (source.U_Sucursal, source.U_Linea, source.U_Periodo, source.U_Enero, source.U_Febrero, source.U_Marzo, source.U_Abril, source.U_Mayo, source.U_Junio, source.U_Julio, source.U_Agosto, source.U_Septiembre, source.U_Octubre, source.U_Noviembre, source.U_Diciembre);

    PRINT 'Sincronización de PRESUPUESTO_B1 completada exitosamente';
END;
GO
/****** Object:  StoredProcedure [dbo].[SYNC_QUT1]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SYNC_QUT1]
AS
BEGIN
    DECLARE @periodo INT = YEAR(DATEADD(YEAR, -5, GETDATE()));
    SET NOCOUNT ON;

    MERGE DATANWO.dbo.app_qut1 AS target
    USING (
        SELECT
            TRY_CAST(qut1.DocEntry AS BIGINT) AS DocEntry,
            TRY_CAST(qut1.LineNum AS INT) AS LineNum,
            TRY_CAST(qut1.TargetType AS INT) AS TargetType,
            TRY_CAST(qut1.TrgetEntry AS BIGINT) AS TrgetEntry,
            ISNULL(qut1.BaseRef, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS BaseRef,
            TRY_CAST(qut1.BaseType AS INT) AS BaseType,
            TRY_CAST(qut1.BaseEntry AS BIGINT) AS BaseEntry,
            TRY_CAST(qut1.BaseLine AS INT) AS BaseLine,
            ISNULL(qut1.LineStatus, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS LineStatus,
            ISNULL(qut1.Dscription, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS Dscription,
            TRY_CAST(qut1.Quantity AS DECIMAL(19,6)) AS Quantity,
            qut1.ShipDate AS ShipDate,
            TRY_CAST(qut1.OpenQty AS DECIMAL(19,6)) AS OpenQty,
            TRY_CAST(qut1.Price AS DECIMAL(19,6)) AS Price,
            ISNULL(qut1.Currency, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS Currency,
            TRY_CAST(qut1.Rate AS DECIMAL(19,6)) AS Rate,
            TRY_CAST(qut1.DiscPrcnt AS DECIMAL(19,6)) AS DiscPrcnt,
            TRY_CAST(qut1.LineTotal AS DECIMAL(19,6)) AS LineTotal,
            TRY_CAST(qut1.TotalFrgn AS DECIMAL(19,6)) AS TotalFrgn,
            TRY_CAST(qut1.OpenSum AS DECIMAL(19,6)) AS OpenSum,
            TRY_CAST(qut1.OpenSumFC AS DECIMAL(19,6)) AS OpenSumFC,
            ISNULL(qut1.VendorNum, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS VendorNum,
            ISNULL(qut1.SerialNum, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS SerialNum,
            ISNULL(qut1.WhsCode, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS WhsCode,
            TRY_CAST(qut1.SlpCode AS INT) AS SlpCode,
            TRY_CAST(qut1.Commission AS DECIMAL(19,6)) AS Commission,
            ISNULL(qut1.TreeType, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS TreeType,
            ISNULL(qut1.AcctCode, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS AcctCode,
            ISNULL(qut1.TaxStatus, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS TaxStatus,
            TRY_CAST(qut1.GrossBuyPr AS DECIMAL(19,6)) AS GrossBuyPr,
            TRY_CAST(qut1.PriceBefDi AS DECIMAL(19,6)) AS PriceBefDi,
            qut1.DocDate AS DocDate,
            TRY_CAST(qut1.Flags AS INT) AS Flags,
            TRY_CAST(qut1.OpenCreQty AS DECIMAL(19,6)) AS OpenCreQty,
            ISNULL(qut1.UseBaseUn, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS UseBaseUn,
            TRY_CAST(qut1.SubCatNum AS INT) AS SubCatNum,
            ISNULL(qut1.BaseCard, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS BaseCard,
            TRY_CAST(qut1.TotalSumSy AS DECIMAL(19,6)) AS TotalSumSy,
            TRY_CAST(qut1.OpenSumSys AS DECIMAL(19,6)) AS OpenSumSys,
            ISNULL(qut1.InvntSttus, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS InvntSttus,
            ISNULL(qut1.OcrCode, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS OcrCode,
            ISNULL(qut1.Project, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS Project,
            ISNULL(qut1.CodeBars, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS CodeBars,
            TRY_CAST(qut1.VatPrcnt AS DECIMAL(19,6)) AS VatPrcnt,
            ISNULL(qut1.VatGroup, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS VatGroup
        FROM [serv-sap].anwo_produccion.dbo.QUT1 qut1
        INNER JOIN DATANWO.dbo.app_oqut oqut ON qut1.DocEntry = oqut.DocEntry
        WHERE YEAR(qut1.DocDate) >= @periodo
    ) AS source
    ON target.DocEntry = source.DocEntry AND target.LineNum = source.LineNum
       WHEN MATCHED AND (
        target.TargetType <> source.TargetType OR target.TargetType IS NULL AND source.TargetType IS NOT NULL OR target.TargetType IS NOT NULL AND source.TargetType IS NULL OR
        target.TrgetEntry <> source.TrgetEntry OR target.TrgetEntry IS NULL AND source.TrgetEntry IS NOT NULL OR target.TrgetEntry IS NOT NULL AND source.TrgetEntry IS NULL OR
        target.BaseRef <> source.BaseRef OR target.BaseRef IS NULL AND source.BaseRef IS NOT NULL OR target.BaseRef IS NOT NULL AND source.BaseRef IS NULL OR
        target.BaseType <> source.BaseType OR target.BaseType IS NULL AND source.BaseType IS NOT NULL OR target.BaseType IS NOT NULL AND source.BaseType IS NULL OR
        target.BaseEntry <> source.BaseEntry OR target.BaseEntry IS NULL AND source.BaseEntry IS NOT NULL OR target.BaseEntry IS NOT NULL AND source.BaseEntry IS NULL OR
        target.BaseLine <> source.BaseLine OR target.BaseLine IS NULL AND source.BaseLine IS NOT NULL OR target.BaseLine IS NOT NULL AND source.BaseLine IS NULL OR
        target.LineStatus <> source.LineStatus OR target.LineStatus IS NULL AND source.LineStatus IS NOT NULL OR target.LineStatus IS NOT NULL AND source.LineStatus IS NULL OR
        target.Dscription <> source.Dscription OR target.Dscription IS NULL AND source.Dscription IS NOT NULL OR target.Dscription IS NOT NULL AND source.Dscription IS NULL OR
        target.Quantity <> source.Quantity OR target.Quantity IS NULL AND source.Quantity IS NOT NULL OR target.Quantity IS NOT NULL AND source.Quantity IS NULL OR
        target.ShipDate <> source.ShipDate OR target.ShipDate IS NULL AND source.ShipDate IS NOT NULL OR target.ShipDate IS NOT NULL AND source.ShipDate IS NULL OR
        target.OpenQty <> source.OpenQty OR target.OpenQty IS NULL AND source.OpenQty IS NOT NULL OR target.OpenQty IS NOT NULL AND source.OpenQty IS NULL OR
        target.Price <> source.Price OR target.Price IS NULL AND source.Price IS NOT NULL OR target.Price IS NOT NULL AND source.Price IS NULL OR
        target.Currency <> source.Currency OR target.Currency IS NULL AND source.Currency IS NOT NULL OR target.Currency IS NOT NULL AND source.Currency IS NULL OR
        target.Rate <> source.Rate OR target.Rate IS NULL AND source.Rate IS NOT NULL OR target.Rate IS NOT NULL AND source.Rate IS NULL OR
        target.DiscPrcnt <> source.DiscPrcnt OR target.DiscPrcnt IS NULL AND source.DiscPrcnt IS NOT NULL OR target.DiscPrcnt IS NOT NULL AND source.DiscPrcnt IS NULL OR
        target.LineTotal <> source.LineTotal OR target.LineTotal IS NULL AND source.LineTotal IS NOT NULL OR target.LineTotal IS NOT NULL AND source.LineTotal IS NULL OR
        target.TotalFrgn <> source.TotalFrgn OR target.TotalFrgn IS NULL AND source.TotalFrgn IS NOT NULL OR target.TotalFrgn IS NOT NULL AND source.TotalFrgn IS NULL OR
        target.OpenSum <> source.OpenSum OR target.OpenSum IS NULL AND source.OpenSum IS NOT NULL OR target.OpenSum IS NOT NULL AND source.OpenSum IS NULL OR
        target.OpenSumFC <> source.OpenSumFC OR target.OpenSumFC IS NULL AND source.OpenSumFC IS NOT NULL OR target.OpenSumFC IS NOT NULL AND source.OpenSumFC IS NULL OR
        target.VendorNum <> source.VendorNum OR target.VendorNum IS NULL AND source.VendorNum IS NOT NULL OR target.VendorNum IS NOT NULL AND source.VendorNum IS NULL OR
        target.SerialNum <> source.SerialNum OR target.SerialNum IS NULL AND source.SerialNum IS NOT NULL OR target.SerialNum IS NOT NULL AND source.SerialNum IS NULL OR
        target.WhsCode <> source.WhsCode OR target.WhsCode IS NULL AND source.WhsCode IS NOT NULL OR target.WhsCode IS NOT NULL AND source.WhsCode IS NULL OR
        target.SlpCode <> source.SlpCode OR target.SlpCode IS NULL AND source.SlpCode IS NOT NULL OR target.SlpCode IS NOT NULL AND source.SlpCode IS NULL OR
        target.Commission <> source.Commission OR target.Commission IS NULL AND source.Commission IS NOT NULL OR target.Commission IS NOT NULL AND source.Commission IS NULL OR
        target.TreeType <> source.TreeType OR target.TreeType IS NULL AND source.TreeType IS NOT NULL OR target.TreeType IS NOT NULL AND source.TreeType IS NULL OR
        target.AcctCode <> source.AcctCode OR target.AcctCode IS NULL AND source.AcctCode IS NOT NULL OR target.AcctCode IS NOT NULL AND source.AcctCode IS NULL OR
        target.TaxStatus <> source.TaxStatus OR target.TaxStatus IS NULL AND source.TaxStatus IS NOT NULL OR target.TaxStatus IS NOT NULL AND source.TaxStatus IS NULL OR
        target.GrossBuyPr <> source.GrossBuyPr OR target.GrossBuyPr IS NULL AND source.GrossBuyPr IS NOT NULL OR target.GrossBuyPr IS NOT NULL AND source.GrossBuyPr IS NULL OR
        target.PriceBefDi <> source.PriceBefDi OR target.PriceBefDi IS NULL AND source.PriceBefDi IS NOT NULL OR target.PriceBefDi IS NOT NULL AND source.PriceBefDi IS NULL OR
        target.DocDate <> source.DocDate OR target.DocDate IS NULL AND source.DocDate IS NOT NULL OR target.DocDate IS NOT NULL AND source.DocDate IS NULL OR
        target.Flags <> source.Flags OR target.Flags IS NULL AND source.Flags IS NOT NULL OR target.Flags IS NOT NULL AND source.Flags IS NULL OR
        target.OpenCreQty <> source.OpenCreQty OR target.OpenCreQty IS NULL AND source.OpenCreQty IS NOT NULL OR target.OpenCreQty IS NOT NULL AND source.OpenCreQty IS NULL OR
        target.UseBaseUn <> source.UseBaseUn OR target.UseBaseUn IS NULL AND source.UseBaseUn IS NOT NULL OR target.UseBaseUn IS NOT NULL AND source.UseBaseUn IS NULL OR
        target.SubCatNum <> source.SubCatNum OR target.SubCatNum IS NULL AND source.SubCatNum IS NOT NULL OR target.SubCatNum IS NOT NULL AND source.SubCatNum IS NULL OR
        target.BaseCard <> source.BaseCard OR target.BaseCard IS NULL AND source.BaseCard IS NOT NULL OR target.BaseCard IS NOT NULL AND source.BaseCard IS NULL OR
        target.TotalSumSy <> source.TotalSumSy OR target.TotalSumSy IS NULL AND source.TotalSumSy IS NOT NULL OR target.TotalSumSy IS NOT NULL AND source.TotalSumSy IS NULL OR
        target.OpenSumSys <> source.OpenSumSys OR target.OpenSumSys IS NULL AND source.OpenSumSys IS NOT NULL OR target.OpenSumSys IS NOT NULL AND source.OpenSumSys IS NULL OR
        target.InvntSttus <> source.InvntSttus OR target.InvntSttus IS NULL AND source.InvntSttus IS NOT NULL OR target.InvntSttus IS NOT NULL AND source.InvntSttus IS NULL OR
        target.OcrCode <> source.OcrCode OR target.OcrCode IS NULL AND source.OcrCode IS NOT NULL OR target.OcrCode IS NOT NULL AND source.OcrCode IS NULL OR
        target.Project <> source.Project OR target.Project IS NULL AND source.Project IS NOT NULL OR target.Project IS NOT NULL AND source.Project IS NULL OR
        target.CodeBars <> source.CodeBars OR target.CodeBars IS NULL AND source.CodeBars IS NOT NULL OR target.CodeBars IS NOT NULL AND source.CodeBars IS NULL OR
        target.VatPrcnt <> source.VatPrcnt OR target.VatPrcnt IS NULL AND source.VatPrcnt IS NOT NULL OR target.VatPrcnt IS NOT NULL AND source.VatPrcnt IS NULL OR
        target.VatGroup <> source.VatGroup OR target.VatGroup IS NULL AND source.VatGroup IS NOT NULL OR target.VatGroup IS NOT NULL AND source.VatGroup IS NULL
    )
    THEN UPDATE SET
        target.TargetType = source.TargetType,
        target.TrgetEntry = source.TrgetEntry,
        target.BaseRef = source.BaseRef,
        target.BaseType = source.BaseType,
        target.BaseEntry = source.BaseEntry,
        target.BaseLine = source.BaseLine,
        target.LineStatus = source.LineStatus,
        target.Dscription = source.Dscription,
        target.Quantity = source.Quantity,
        target.ShipDate = source.ShipDate,
        target.OpenQty = source.OpenQty,
        target.Price = source.Price,
        target.Currency = source.Currency,
        target.Rate = source.Rate,
        target.DiscPrcnt = source.DiscPrcnt,
        target.LineTotal = source.LineTotal,
        target.TotalFrgn = source.TotalFrgn,
        target.OpenSum = source.OpenSum,
        target.OpenSumFC = source.OpenSumFC,
        target.VendorNum = source.VendorNum,
        target.SerialNum = source.SerialNum,
        target.WhsCode = source.WhsCode,
        target.SlpCode = source.SlpCode,
        target.Commission = source.Commission,
        target.TreeType = source.TreeType,
        target.AcctCode = source.AcctCode,
        target.TaxStatus = source.TaxStatus,
        target.GrossBuyPr = source.GrossBuyPr,
        target.PriceBefDi = source.PriceBefDi,
        target.DocDate = source.DocDate,
        target.Flags = source.Flags,
        target.OpenCreQty = source.OpenCreQty,
        target.UseBaseUn = source.UseBaseUn,
        target.SubCatNum = source.SubCatNum,
        target.BaseCard = source.BaseCard,
        target.TotalSumSy = source.TotalSumSy,
        target.OpenSumSys = source.OpenSumSys,
        target.InvntSttus = source.InvntSttus,
        target.OcrCode = source.OcrCode,
        target.Project = source.Project,
        target.CodeBars = source.CodeBars,
        target.VatPrcnt = source.VatPrcnt,
        target.VatGroup = source.VatGroup
    WHEN NOT MATCHED THEN
    INSERT (DocEntry, LineNum, TargetType, TrgetEntry, BaseRef, BaseType, BaseEntry, BaseLine, LineStatus, Dscription,
            Quantity, ShipDate, OpenQty, Price, Currency, Rate, DiscPrcnt, LineTotal, TotalFrgn, OpenSum, OpenSumFC,
            VendorNum, SerialNum, WhsCode, SlpCode, Commission, TreeType, AcctCode, TaxStatus, GrossBuyPr, PriceBefDi,
            DocDate, Flags, OpenCreQty, UseBaseUn, SubCatNum, BaseCard, TotalSumSy, OpenSumSys, InvntSttus, OcrCode,
            Project, CodeBars, VatPrcnt, VatGroup)
    VALUES (source.DocEntry, source.LineNum, source.TargetType, source.TrgetEntry, source.BaseRef, source.BaseType,
            source.BaseEntry, source.BaseLine, source.LineStatus, source.Dscription, source.Quantity, source.ShipDate,
            source.OpenQty, source.Price, source.Currency, source.Rate, source.DiscPrcnt, source.LineTotal,
            source.TotalFrgn, source.OpenSum, source.OpenSumFC, source.VendorNum, source.SerialNum, source.WhsCode,
            source.SlpCode, source.Commission, source.TreeType, source.AcctCode, source.TaxStatus, source.GrossBuyPr,
            source.PriceBefDi, source.DocDate, source.Flags, source.OpenCreQty, source.UseBaseUn, source.SubCatNum,
            source.BaseCard, source.TotalSumSy, source.OpenSumSys, source.InvntSttus, source.OcrCode, source.Project,
            source.CodeBars, source.VatPrcnt, source.VatGroup);

    PRINT 'Sincronización de app_qut1 completada exitosamente';
END;

GO
/****** Object:  StoredProcedure [dbo].[SYNC_RDR1]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[SYNC_RDR1]
AS
BEGIN

 	DECLARE @periodo INT = YEAR(DATEADD(YEAR, -5, GETDATE()));
    SET NOCOUNT ON;

    MERGE DATANWO.dbo.app_rdr1 AS target
    USING (
        SELECT
		TRY_CAST(rdr1.DocEntry AS BIGINT) AS DocEntry,
		TRY_CAST(rdr1.LineNum AS INT) AS LineNum,
		TRY_CAST(rdr1.TargetType AS INT) AS TargetType,
		TRY_CAST(rdr1.TrgetEntry AS BIGINT) AS TrgetEntry,
		ISNULL(rdr1.BaseRef, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS BaseRef,
		TRY_CAST(rdr1.BaseType AS INT) AS BaseType,
		TRY_CAST(rdr1.BaseEntry AS BIGINT) AS BaseEntry,
		TRY_CAST(rdr1.BaseLine AS INT) AS BaseLine,
		ISNULL(rdr1.LineStatus, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS LineStatus,
		ISNULL(rdr1.Dscription, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS Dscription,
		TRY_CAST(rdr1.Quantity AS DECIMAL(19,6)) AS Quantity,
		rdr1.ShipDate AS ShipDate,
		TRY_CAST(rdr1.OpenQty AS DECIMAL(19,6)) AS OpenQty,
		TRY_CAST(rdr1.Price AS DECIMAL(19,6)) AS Price,
		ISNULL(rdr1.Currency, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS Currency,
		TRY_CAST(rdr1.Rate AS DECIMAL(19,6)) AS Rate,
		TRY_CAST(rdr1.DiscPrcnt AS DECIMAL(19,6)) AS DiscPrcnt,
		TRY_CAST(rdr1.LineTotal AS DECIMAL(19,6)) AS LineTotal,
		TRY_CAST(rdr1.TotalFrgn AS DECIMAL(19,6)) AS TotalFrgn,
		TRY_CAST(rdr1.OpenSum AS DECIMAL(19,6)) AS OpenSum,
		TRY_CAST(rdr1.OpenSumFC AS DECIMAL(19,6)) AS OpenSumFC,
		ISNULL(rdr1.VendorNum, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS VendorNum,
		ISNULL(rdr1.SerialNum, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS SerialNum,
		ISNULL(rdr1.WhsCode, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS WhsCode,
		TRY_CAST(rdr1.SlpCode AS INT) AS SlpCode,
		TRY_CAST(rdr1.Commission AS DECIMAL(19,6)) AS Commission,
		ISNULL(rdr1.TreeType, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS TreeType,
		ISNULL(rdr1.AcctCode, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS AcctCode,
		ISNULL(rdr1.TaxStatus, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS TaxStatus,
		TRY_CAST(rdr1.GrossBuyPr AS DECIMAL(19,6)) AS GrossBuyPr,
		TRY_CAST(rdr1.PriceBefDi AS DECIMAL(19,6)) AS PriceBefDi,
		rdr1.DocDate AS DocDate,
		TRY_CAST(rdr1.Flags AS INT) AS Flags,
		TRY_CAST(rdr1.OpenCreQty AS DECIMAL(19,6)) AS OpenCreQty,
		ISNULL(rdr1.UseBaseUn, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS UseBaseUn,
		TRY_CAST(rdr1.SubCatNum AS INT) AS SubCatNum,
		ISNULL(rdr1.BaseCard, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS BaseCard,
		TRY_CAST(rdr1.TotalSumSy AS DECIMAL(19,6)) AS TotalSumSy,
		TRY_CAST(rdr1.OpenSumSys AS DECIMAL(19,6)) AS OpenSumSys,
		ISNULL(rdr1.InvntSttus, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS InvntSttus,
		ISNULL(rdr1.OcrCode, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS OcrCode,
		ISNULL(rdr1.Project, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS Project,
		ISNULL(rdr1.CodeBars, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS CodeBars,
		TRY_CAST(rdr1.VatPrcnt AS DECIMAL(19,6)) AS VatPrcnt,
		ISNULL(rdr1.VatGroup, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS VatGroup

		FROM [serv-sap].anwo_produccion.dbo.RDR1 rdr1
	    INNER JOIN DATANWO.dbo.app_ordr ordr ON rdr1.DocEntry = ordr.DocEntry
		
        WHERE year(rdr1.DocDate) >= @periodo
    ) AS source
    ON target.DocEntry = source.DocEntry AND target.LineNum = source.LineNum

    WHEN MATCHED AND (
        (target.DocEntry <> source.DocEntry OR target.DocEntry IS NULL AND source.DocEntry IS NOT NULL OR target.DocEntry IS NOT NULL AND source.DocEntry IS NULL) OR 
        (target.LineNum <> source.LineNum OR target.LineNum IS NULL AND source.LineNum IS NOT NULL OR target.LineNum IS NOT NULL AND source.LineNum IS NULL) OR 
        (target.TargetType <> source.TargetType OR target.TargetType IS NULL AND source.TargetType IS NOT NULL OR target.TargetType IS NOT NULL AND source.TargetType IS NULL) OR 
        (target.TrgetEntry <> source.TrgetEntry OR target.TrgetEntry IS NULL AND source.TrgetEntry IS NOT NULL OR target.TrgetEntry IS NOT NULL AND source.TrgetEntry IS NULL) OR 
        (target.BaseRef <> source.BaseRef OR target.BaseRef IS NULL AND source.BaseRef IS NOT NULL OR target.BaseRef IS NOT NULL AND source.BaseRef IS NULL) OR 
        (target.BaseType <> source.BaseType OR target.BaseType IS NULL AND source.BaseType IS NOT NULL OR target.BaseType IS NOT NULL AND source.BaseType IS NULL) OR 
        (target.BaseEntry <> source.BaseEntry OR target.BaseEntry IS NULL AND source.BaseEntry IS NOT NULL OR target.BaseEntry IS NOT NULL AND source.BaseEntry IS NULL) OR 
        (target.BaseLine <> source.BaseLine OR target.BaseLine IS NULL AND source.BaseLine IS NOT NULL OR target.BaseLine IS NOT NULL AND source.BaseLine IS NULL) OR 
        (target.LineStatus <> source.LineStatus OR target.LineStatus IS NULL AND source.LineStatus IS NOT NULL OR target.LineStatus IS NOT NULL AND source.LineStatus IS NULL) OR 
        --(target.ItemCode <> source.ItemCode OR target.ItemCode IS NULL AND source.ItemCode IS NOT NULL OR target.ItemCode IS NOT NULL AND source.ItemCode IS NULL) OR 
        (target.Dscription <> source.Dscription OR target.Dscription IS NULL AND source.Dscription IS NOT NULL OR target.Dscription IS NOT NULL AND source.Dscription IS NULL) OR 
        (target.Quantity <> source.Quantity OR target.Quantity IS NULL AND source.Quantity IS NOT NULL OR target.Quantity IS NOT NULL AND source.Quantity IS NULL) OR 
        (target.ShipDate <> source.ShipDate OR target.ShipDate IS NULL AND source.ShipDate IS NOT NULL OR target.ShipDate IS NOT NULL AND source.ShipDate IS NULL) OR 
        (target.OpenQty <> source.OpenQty OR target.OpenQty IS NULL AND source.OpenQty IS NOT NULL OR target.OpenQty IS NOT NULL AND source.OpenQty IS NULL) OR 
        (target.Price <> source.Price OR target.Price IS NULL AND source.Price IS NOT NULL OR target.Price IS NOT NULL AND source.Price IS NULL) OR 
        (target.Currency <> source.Currency OR target.Currency IS NULL AND source.Currency IS NOT NULL OR target.Currency IS NOT NULL AND source.Currency IS NULL) OR 
        (target.Rate <> source.Rate OR target.Rate IS NULL AND source.Rate IS NOT NULL OR target.Rate IS NOT NULL AND source.Rate IS NULL) OR 
        (target.DiscPrcnt <> source.DiscPrcnt OR target.DiscPrcnt IS NULL AND source.DiscPrcnt IS NOT NULL OR target.DiscPrcnt IS NOT NULL AND source.DiscPrcnt IS NULL) OR 
        (target.LineTotal <> source.LineTotal OR target.LineTotal IS NULL AND source.LineTotal IS NOT NULL OR target.LineTotal IS NOT NULL AND source.LineTotal IS NULL) OR 
        (target.TotalFrgn <> source.TotalFrgn OR target.TotalFrgn IS NULL AND source.TotalFrgn IS NOT NULL OR target.TotalFrgn IS NOT NULL AND source.TotalFrgn IS NULL) OR 
        (target.OpenSum <> source.OpenSum OR target.OpenSum IS NULL AND source.OpenSum IS NOT NULL OR target.OpenSum IS NOT NULL AND source.OpenSum IS NULL) OR 
        (target.OpenSumFC <> source.OpenSumFC OR target.OpenSumFC IS NULL AND source.OpenSumFC IS NOT NULL OR target.OpenSumFC IS NOT NULL AND source.OpenSumFC IS NULL) OR 
        (target.VendorNum <> source.VendorNum OR target.VendorNum IS NULL AND source.VendorNum IS NOT NULL OR target.VendorNum IS NOT NULL AND source.VendorNum IS NULL) OR 
        (target.SerialNum <> source.SerialNum OR target.SerialNum IS NULL AND source.SerialNum IS NOT NULL OR target.SerialNum IS NOT NULL AND source.SerialNum IS NULL) OR 
        (target.WhsCode <> source.WhsCode OR target.WhsCode IS NULL AND source.WhsCode IS NOT NULL OR target.WhsCode IS NOT NULL AND source.WhsCode IS NULL) OR 
        (target.SlpCode <> source.SlpCode OR target.SlpCode IS NULL AND source.SlpCode IS NOT NULL OR target.SlpCode IS NOT NULL AND source.SlpCode IS NULL) OR 
        (target.Commission <> source.Commission OR target.Commission IS NULL AND source.Commission IS NOT NULL OR target.Commission IS NOT NULL AND source.Commission IS NULL) OR 
        (target.TreeType <> source.TreeType OR target.TreeType IS NULL AND source.TreeType IS NOT NULL OR target.TreeType IS NOT NULL AND source.TreeType IS NULL) OR 
        (target.AcctCode <> source.AcctCode OR target.AcctCode IS NULL AND source.AcctCode IS NOT NULL OR target.AcctCode IS NOT NULL AND source.AcctCode IS NULL) OR 
        (target.TaxStatus <> source.TaxStatus OR target.TaxStatus IS NULL AND source.TaxStatus IS NOT NULL OR target.TaxStatus IS NOT NULL AND source.TaxStatus IS NULL) OR 
        (target.GrossBuyPr <> source.GrossBuyPr OR target.GrossBuyPr IS NULL AND source.GrossBuyPr IS NOT NULL OR target.GrossBuyPr IS NOT NULL AND source.GrossBuyPr IS NULL) OR 
        (target.PriceBefDi <> source.PriceBefDi OR target.PriceBefDi IS NULL AND source.PriceBefDi IS NOT NULL OR target.PriceBefDi IS NOT NULL AND source.PriceBefDi IS NULL) OR 
        (target.DocDate <> source.DocDate OR target.DocDate IS NULL AND source.DocDate IS NOT NULL OR target.DocDate IS NOT NULL AND source.DocDate IS NULL) OR 
        (target.Flags <> source.Flags OR target.Flags IS NULL AND source.Flags IS NOT NULL OR target.Flags IS NOT NULL AND source.Flags IS NULL) OR 
        (target.OpenCreQty <> source.OpenCreQty OR target.OpenCreQty IS NULL AND source.OpenCreQty IS NOT NULL OR target.OpenCreQty IS NOT NULL AND source.OpenCreQty IS NULL) OR 
        (target.UseBaseUn <> source.UseBaseUn OR target.UseBaseUn IS NULL AND source.UseBaseUn IS NOT NULL OR target.UseBaseUn IS NOT NULL AND source.UseBaseUn IS NULL) OR 
        (target.SubCatNum <> source.SubCatNum OR target.SubCatNum IS NULL AND source.SubCatNum IS NOT NULL OR target.SubCatNum IS NOT NULL AND source.SubCatNum IS NULL) OR 
        (target.BaseCard <> source.BaseCard OR target.BaseCard IS NULL AND source.BaseCard IS NOT NULL OR target.BaseCard IS NOT NULL AND source.BaseCard IS NULL) OR 
        (target.TotalSumSy <> source.TotalSumSy OR target.TotalSumSy IS NULL AND source.TotalSumSy IS NOT NULL OR target.TotalSumSy IS NOT NULL AND source.TotalSumSy IS NULL) OR 
        (target.OpenSumSys <> source.OpenSumSys OR target.OpenSumSys IS NULL AND source.OpenSumSys IS NOT NULL OR target.OpenSumSys IS NOT NULL AND source.OpenSumSys IS NULL) OR 
        (target.InvntSttus <> source.InvntSttus OR target.InvntSttus IS NULL AND source.InvntSttus IS NOT NULL OR target.InvntSttus IS NOT NULL AND source.InvntSttus IS NULL) OR 
        (target.OcrCode <> source.OcrCode OR target.OcrCode IS NULL AND source.OcrCode IS NOT NULL OR target.OcrCode IS NOT NULL AND source.OcrCode IS NULL) OR 
        (target.Project <> source.Project OR target.Project IS NULL AND source.Project IS NOT NULL OR target.Project IS NOT NULL AND source.Project IS NULL) OR 
        (target.CodeBars <> source.CodeBars OR target.CodeBars IS NULL AND source.CodeBars IS NOT NULL OR target.CodeBars IS NOT NULL AND source.CodeBars IS NULL) OR 
        (target.VatPrcnt <> source.VatPrcnt OR target.VatPrcnt IS NULL AND source.VatPrcnt IS NOT NULL OR target.VatPrcnt IS NOT NULL AND source.VatPrcnt IS NULL) OR 
        (target.VatGroup <> source.VatGroup OR target.VatGroup IS NULL AND source.VatGroup IS NOT NULL OR target.VatGroup IS NOT NULL AND source.VatGroup IS NULL)
    )
    THEN UPDATE SET
        target.DocEntry = source.DocEntry,
        target.LineNum = source.LineNum,
        target.TargetType = source.TargetType,
        target.TrgetEntry = source.TrgetEntry,
        target.BaseRef = source.BaseRef,
        target.BaseType = source.BaseType,
        target.BaseEntry = source.BaseEntry,
        target.BaseLine = source.BaseLine,
        target.LineStatus = source.LineStatus,
        --target.ItemCode = source.ItemCode,
        target.Dscription = source.Dscription,
        target.Quantity = source.Quantity,
        target.ShipDate = source.ShipDate,
        target.OpenQty = source.OpenQty,
        target.Price = source.Price,
        target.Currency = source.Currency,
        target.Rate = source.Rate,
        target.DiscPrcnt = source.DiscPrcnt,
        target.LineTotal = source.LineTotal,
        target.TotalFrgn = source.TotalFrgn,
        target.OpenSum = source.OpenSum,
        target.OpenSumFC = source.OpenSumFC,
        target.VendorNum = source.VendorNum,
        target.SerialNum = source.SerialNum,
        target.WhsCode = source.WhsCode,
        target.SlpCode = source.SlpCode,
        target.Commission = source.Commission,
        target.TreeType = source.TreeType,
        target.AcctCode = source.AcctCode,
        target.TaxStatus = source.TaxStatus,
        target.GrossBuyPr = source.GrossBuyPr,
        target.PriceBefDi = source.PriceBefDi,
        target.DocDate = source.DocDate,
        target.Flags = source.Flags,
        target.OpenCreQty = source.OpenCreQty,
        target.UseBaseUn = source.UseBaseUn,
        target.SubCatNum = source.SubCatNum,
        target.BaseCard = source.BaseCard,
        target.TotalSumSy = source.TotalSumSy,
        target.OpenSumSys = source.OpenSumSys,
        target.InvntSttus = source.InvntSttus,
        target.OcrCode = source.OcrCode,
        target.Project = source.Project,
        target.CodeBars = source.CodeBars,
        target.VatPrcnt = source.VatPrcnt,
        target.VatGroup = source.VatGroup

    WHEN NOT MATCHED THEN
    INSERT (DocEntry, LineNum, TargetType, TrgetEntry, BaseRef, BaseType, BaseEntry, BaseLine, LineStatus, Dscription, Quantity, ShipDate, OpenQty, Price, Currency, Rate, DiscPrcnt, LineTotal, TotalFrgn, OpenSum, OpenSumFC, VendorNum, SerialNum, WhsCode, SlpCode, Commission, TreeType, AcctCode, TaxStatus, GrossBuyPr, PriceBefDi, DocDate, Flags, OpenCreQty, UseBaseUn, SubCatNum, BaseCard, TotalSumSy, OpenSumSys, InvntSttus, OcrCode, Project, CodeBars, VatPrcnt, VatGroup)
    VALUES (source.DocEntry, source.LineNum, source.TargetType, source.TrgetEntry, source.BaseRef, source.BaseType, source.BaseEntry, source.BaseLine, source.LineStatus, source.Dscription, source.Quantity, source.ShipDate, source.OpenQty, source.Price, source.Currency, source.Rate, source.DiscPrcnt, source.LineTotal, source.TotalFrgn, source.OpenSum, source.OpenSumFC, source.VendorNum, source.SerialNum, source.WhsCode, source.SlpCode, source.Commission, source.TreeType, source.AcctCode, source.TaxStatus, source.GrossBuyPr, source.PriceBefDi, source.DocDate, source.Flags, source.OpenCreQty, source.UseBaseUn, source.SubCatNum, source.BaseCard, source.TotalSumSy, source.OpenSumSys, source.InvntSttus, source.OcrCode, source.Project, source.CodeBars, source.VatPrcnt, source.VatGroup);

    PRINT 'Sincronización de app_rdr1 completada exitosamente';
END;


GO
/****** Object:  StoredProcedure [dbo].[SYNC_RIN1]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SYNC_RIN1]
AS
BEGIN

 	DECLARE @periodo INT = YEAR(DATEADD(YEAR, -5, GETDATE()));
    SET NOCOUNT ON;

    MERGE DATANWO.dbo.app_rin1 AS target
    USING (
        SELECT
		TRY_CAST(rin1.DocEntry AS BIGINT) AS DocEntry,
		TRY_CAST(rin1.LineNum AS INT) AS LineNum,
		TRY_CAST(rin1.TargetType AS INT) AS TargetType,
		TRY_CAST(rin1.TrgetEntry AS BIGINT) AS TrgetEntry,
		ISNULL(rin1.BaseRef, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS BaseRef,
		TRY_CAST(rin1.BaseType AS INT) AS BaseType,
		TRY_CAST(rin1.BaseEntry AS BIGINT) AS BaseEntry,
		TRY_CAST(rin1.BaseLine AS INT) AS BaseLine,
		ISNULL(rin1.LineStatus, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS LineStatus,
		ISNULL(rin1.Dscription, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS Dscription,
		TRY_CAST(rin1.Quantity AS DECIMAL(19,6)) AS Quantity,
		rin1.ShipDate AS ShipDate,
		TRY_CAST(rin1.OpenQty AS DECIMAL(19,6)) AS OpenQty,
		TRY_CAST(rin1.Price AS DECIMAL(19,6)) AS Price,
		ISNULL(rin1.Currency, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS Currency,
		TRY_CAST(rin1.Rate AS DECIMAL(19,6)) AS Rate,
		TRY_CAST(rin1.DiscPrcnt AS DECIMAL(19,6)) AS DiscPrcnt,
		TRY_CAST(rin1.LineTotal AS DECIMAL(19,6)) AS LineTotal,
		TRY_CAST(rin1.TotalFrgn AS DECIMAL(19,6)) AS TotalFrgn,
		TRY_CAST(rin1.OpenSum AS DECIMAL(19,6)) AS OpenSum,
		TRY_CAST(rin1.OpenSumFC AS DECIMAL(19,6)) AS OpenSumFC,
		ISNULL(rin1.VendorNum, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS VendorNum,
		ISNULL(rin1.SerialNum, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS SerialNum,
		ISNULL(rin1.WhsCode, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS WhsCode,
		TRY_CAST(rin1.SlpCode AS INT) AS SlpCode,
		TRY_CAST(rin1.Commission AS DECIMAL(19,6)) AS Commission,
		ISNULL(rin1.TreeType, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS TreeType,
		ISNULL(rin1.AcctCode, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS AcctCode,
		ISNULL(rin1.TaxStatus, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS TaxStatus,
		TRY_CAST(rin1.GrossBuyPr AS DECIMAL(19,6)) AS GrossBuyPr,
		TRY_CAST(rin1.PriceBefDi AS DECIMAL(19,6)) AS PriceBefDi,
		rin1.DocDate AS DocDate,
		TRY_CAST(rin1.Flags AS INT) AS Flags,
		TRY_CAST(rin1.OpenCreQty AS DECIMAL(19,6)) AS OpenCreQty,
		ISNULL(rin1.UseBaseUn, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS UseBaseUn,
		TRY_CAST(rin1.SubCatNum AS INT) AS SubCatNum,
		ISNULL(rin1.BaseCard, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS BaseCard,
		TRY_CAST(rin1.TotalSumSy AS DECIMAL(19,6)) AS TotalSumSy,
		TRY_CAST(rin1.OpenSumSys AS DECIMAL(19,6)) AS OpenSumSys,
		ISNULL(rin1.InvntSttus, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS InvntSttus,
		ISNULL(rin1.OcrCode, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS OcrCode,
		ISNULL(rin1.Project, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS Project,
		ISNULL(rin1.CodeBars, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS CodeBars,
		TRY_CAST(rin1.VatPrcnt AS DECIMAL(19,6)) AS VatPrcnt,
		ISNULL(rin1.VatGroup, '') COLLATE SQL_Latin1_General_CP1_CI_AS AS VatGroup

		FROM [serv-sap].anwo_produccion.dbo.RIN1 rin1
	    INNER JOIN DATANWO.dbo.app_orin orin ON rin1.DocEntry = orin.DocEntry
		
        WHERE year(rin1.DocDate) >= @periodo
    ) AS source
    ON target.DocEntry = source.DocEntry AND target.LineNum = source.LineNum

    WHEN MATCHED AND (
        (target.DocEntry <> source.DocEntry OR target.DocEntry IS NULL AND source.DocEntry IS NOT NULL OR target.DocEntry IS NOT NULL AND source.DocEntry IS NULL) OR 
        (target.LineNum <> source.LineNum OR target.LineNum IS NULL AND source.LineNum IS NOT NULL OR target.LineNum IS NOT NULL AND source.LineNum IS NULL) OR 
        (target.TargetType <> source.TargetType OR target.TargetType IS NULL AND source.TargetType IS NOT NULL OR target.TargetType IS NOT NULL AND source.TargetType IS NULL) OR 
        (target.TrgetEntry <> source.TrgetEntry OR target.TrgetEntry IS NULL AND source.TrgetEntry IS NOT NULL OR target.TrgetEntry IS NOT NULL AND source.TrgetEntry IS NULL) OR 
        (target.BaseRef <> source.BaseRef OR target.BaseRef IS NULL AND source.BaseRef IS NOT NULL OR target.BaseRef IS NOT NULL AND source.BaseRef IS NULL) OR 
        (target.BaseType <> source.BaseType OR target.BaseType IS NULL AND source.BaseType IS NOT NULL OR target.BaseType IS NOT NULL AND source.BaseType IS NULL) OR 
        (target.BaseEntry <> source.BaseEntry OR target.BaseEntry IS NULL AND source.BaseEntry IS NOT NULL OR target.BaseEntry IS NOT NULL AND source.BaseEntry IS NULL) OR 
        (target.BaseLine <> source.BaseLine OR target.BaseLine IS NULL AND source.BaseLine IS NOT NULL OR target.BaseLine IS NOT NULL AND source.BaseLine IS NULL) OR 
        (target.LineStatus <> source.LineStatus OR target.LineStatus IS NULL AND source.LineStatus IS NOT NULL OR target.LineStatus IS NOT NULL AND source.LineStatus IS NULL) OR 
        --(target.ItemCode <> source.ItemCode OR target.ItemCode IS NULL AND source.ItemCode IS NOT NULL OR target.ItemCode IS NOT NULL AND source.ItemCode IS NULL) OR 
        (target.Dscription <> source.Dscription OR target.Dscription IS NULL AND source.Dscription IS NOT NULL OR target.Dscription IS NOT NULL AND source.Dscription IS NULL) OR 
        (target.Quantity <> source.Quantity OR target.Quantity IS NULL AND source.Quantity IS NOT NULL OR target.Quantity IS NOT NULL AND source.Quantity IS NULL) OR 
        (target.ShipDate <> source.ShipDate OR target.ShipDate IS NULL AND source.ShipDate IS NOT NULL OR target.ShipDate IS NOT NULL AND source.ShipDate IS NULL) OR 
        (target.OpenQty <> source.OpenQty OR target.OpenQty IS NULL AND source.OpenQty IS NOT NULL OR target.OpenQty IS NOT NULL AND source.OpenQty IS NULL) OR 
        (target.Price <> source.Price OR target.Price IS NULL AND source.Price IS NOT NULL OR target.Price IS NOT NULL AND source.Price IS NULL) OR 
        (target.Currency <> source.Currency OR target.Currency IS NULL AND source.Currency IS NOT NULL OR target.Currency IS NOT NULL AND source.Currency IS NULL) OR 
        (target.Rate <> source.Rate OR target.Rate IS NULL AND source.Rate IS NOT NULL OR target.Rate IS NOT NULL AND source.Rate IS NULL) OR 
        (target.DiscPrcnt <> source.DiscPrcnt OR target.DiscPrcnt IS NULL AND source.DiscPrcnt IS NOT NULL OR target.DiscPrcnt IS NOT NULL AND source.DiscPrcnt IS NULL) OR 
        (target.LineTotal <> source.LineTotal OR target.LineTotal IS NULL AND source.LineTotal IS NOT NULL OR target.LineTotal IS NOT NULL AND source.LineTotal IS NULL) OR 
        (target.TotalFrgn <> source.TotalFrgn OR target.TotalFrgn IS NULL AND source.TotalFrgn IS NOT NULL OR target.TotalFrgn IS NOT NULL AND source.TotalFrgn IS NULL) OR 
        (target.OpenSum <> source.OpenSum OR target.OpenSum IS NULL AND source.OpenSum IS NOT NULL OR target.OpenSum IS NOT NULL AND source.OpenSum IS NULL) OR 
        (target.OpenSumFC <> source.OpenSumFC OR target.OpenSumFC IS NULL AND source.OpenSumFC IS NOT NULL OR target.OpenSumFC IS NOT NULL AND source.OpenSumFC IS NULL) OR 
        (target.VendorNum <> source.VendorNum OR target.VendorNum IS NULL AND source.VendorNum IS NOT NULL OR target.VendorNum IS NOT NULL AND source.VendorNum IS NULL) OR 
        (target.SerialNum <> source.SerialNum OR target.SerialNum IS NULL AND source.SerialNum IS NOT NULL OR target.SerialNum IS NOT NULL AND source.SerialNum IS NULL) OR 
        (target.WhsCode <> source.WhsCode OR target.WhsCode IS NULL AND source.WhsCode IS NOT NULL OR target.WhsCode IS NOT NULL AND source.WhsCode IS NULL) OR 
        (target.SlpCode <> source.SlpCode OR target.SlpCode IS NULL AND source.SlpCode IS NOT NULL OR target.SlpCode IS NOT NULL AND source.SlpCode IS NULL) OR 
        (target.Commission <> source.Commission OR target.Commission IS NULL AND source.Commission IS NOT NULL OR target.Commission IS NOT NULL AND source.Commission IS NULL) OR 
        (target.TreeType <> source.TreeType OR target.TreeType IS NULL AND source.TreeType IS NOT NULL OR target.TreeType IS NOT NULL AND source.TreeType IS NULL) OR 
        (target.AcctCode <> source.AcctCode OR target.AcctCode IS NULL AND source.AcctCode IS NOT NULL OR target.AcctCode IS NOT NULL AND source.AcctCode IS NULL) OR 
        (target.TaxStatus <> source.TaxStatus OR target.TaxStatus IS NULL AND source.TaxStatus IS NOT NULL OR target.TaxStatus IS NOT NULL AND source.TaxStatus IS NULL) OR 
        (target.GrossBuyPr <> source.GrossBuyPr OR target.GrossBuyPr IS NULL AND source.GrossBuyPr IS NOT NULL OR target.GrossBuyPr IS NOT NULL AND source.GrossBuyPr IS NULL) OR 
        (target.PriceBefDi <> source.PriceBefDi OR target.PriceBefDi IS NULL AND source.PriceBefDi IS NOT NULL OR target.PriceBefDi IS NOT NULL AND source.PriceBefDi IS NULL) OR 
        (target.DocDate <> source.DocDate OR target.DocDate IS NULL AND source.DocDate IS NOT NULL OR target.DocDate IS NOT NULL AND source.DocDate IS NULL) OR 
        (target.Flags <> source.Flags OR target.Flags IS NULL AND source.Flags IS NOT NULL OR target.Flags IS NOT NULL AND source.Flags IS NULL) OR 
        (target.OpenCreQty <> source.OpenCreQty OR target.OpenCreQty IS NULL AND source.OpenCreQty IS NOT NULL OR target.OpenCreQty IS NOT NULL AND source.OpenCreQty IS NULL) OR 
        (target.UseBaseUn <> source.UseBaseUn OR target.UseBaseUn IS NULL AND source.UseBaseUn IS NOT NULL OR target.UseBaseUn IS NOT NULL AND source.UseBaseUn IS NULL) OR 
        (target.SubCatNum <> source.SubCatNum OR target.SubCatNum IS NULL AND source.SubCatNum IS NOT NULL OR target.SubCatNum IS NOT NULL AND source.SubCatNum IS NULL) OR 
        (target.BaseCard <> source.BaseCard OR target.BaseCard IS NULL AND source.BaseCard IS NOT NULL OR target.BaseCard IS NOT NULL AND source.BaseCard IS NULL) OR 
        (target.TotalSumSy <> source.TotalSumSy OR target.TotalSumSy IS NULL AND source.TotalSumSy IS NOT NULL OR target.TotalSumSy IS NOT NULL AND source.TotalSumSy IS NULL) OR 
        (target.OpenSumSys <> source.OpenSumSys OR target.OpenSumSys IS NULL AND source.OpenSumSys IS NOT NULL OR target.OpenSumSys IS NOT NULL AND source.OpenSumSys IS NULL) OR 
        (target.InvntSttus <> source.InvntSttus OR target.InvntSttus IS NULL AND source.InvntSttus IS NOT NULL OR target.InvntSttus IS NOT NULL AND source.InvntSttus IS NULL) OR 
        (target.OcrCode <> source.OcrCode OR target.OcrCode IS NULL AND source.OcrCode IS NOT NULL OR target.OcrCode IS NOT NULL AND source.OcrCode IS NULL) OR 
        (target.Project <> source.Project OR target.Project IS NULL AND source.Project IS NOT NULL OR target.Project IS NOT NULL AND source.Project IS NULL) OR 
        (target.CodeBars <> source.CodeBars OR target.CodeBars IS NULL AND source.CodeBars IS NOT NULL OR target.CodeBars IS NOT NULL AND source.CodeBars IS NULL) OR 
        (target.VatPrcnt <> source.VatPrcnt OR target.VatPrcnt IS NULL AND source.VatPrcnt IS NOT NULL OR target.VatPrcnt IS NOT NULL AND source.VatPrcnt IS NULL) OR 
        (target.VatGroup <> source.VatGroup OR target.VatGroup IS NULL AND source.VatGroup IS NOT NULL OR target.VatGroup IS NOT NULL AND source.VatGroup IS NULL)
    )
    THEN UPDATE SET
        target.DocEntry = source.DocEntry,
        target.LineNum = source.LineNum,
        target.TargetType = source.TargetType,
        target.TrgetEntry = source.TrgetEntry,
        target.BaseRef = source.BaseRef,
        target.BaseType = source.BaseType,
        target.BaseEntry = source.BaseEntry,
        target.BaseLine = source.BaseLine,
        target.LineStatus = source.LineStatus,
        --        target.Dscription = source.Dscription,
        target.Quantity = source.Quantity,
        target.ShipDate = source.ShipDate,
        target.OpenQty = source.OpenQty,
        target.Price = source.Price,
        target.Currency = source.Currency,
        target.Rate = source.Rate,
        target.DiscPrcnt = source.DiscPrcnt,
        target.LineTotal = source.LineTotal,
        target.TotalFrgn = source.TotalFrgn,
        target.OpenSum = source.OpenSum,
        target.OpenSumFC = source.OpenSumFC,
        target.VendorNum = source.VendorNum,
        target.SerialNum = source.SerialNum,
        target.WhsCode = source.WhsCode,
        target.SlpCode = source.SlpCode,
        target.Commission = source.Commission,
        target.TreeType = source.TreeType,
        target.AcctCode = source.AcctCode,
        target.TaxStatus = source.TaxStatus,
        target.GrossBuyPr = source.GrossBuyPr,
        target.PriceBefDi = source.PriceBefDi,
        target.DocDate = source.DocDate,
        target.Flags = source.Flags,
        target.OpenCreQty = source.OpenCreQty,
        target.UseBaseUn = source.UseBaseUn,
        target.SubCatNum = source.SubCatNum,
        target.BaseCard = source.BaseCard,
        target.TotalSumSy = source.TotalSumSy,
        target.OpenSumSys = source.OpenSumSys,
        target.InvntSttus = source.InvntSttus,
        target.OcrCode = source.OcrCode,
        target.Project = source.Project,
        target.CodeBars = source.CodeBars,
        target.VatPrcnt = source.VatPrcnt,
        target.VatGroup = source.VatGroup

    WHEN NOT MATCHED THEN
    INSERT (DocEntry, LineNum, TargetType, TrgetEntry, BaseRef, BaseType, BaseEntry, BaseLine, LineStatus, Dscription, Quantity, ShipDate, OpenQty, Price, Currency, Rate, DiscPrcnt, LineTotal, TotalFrgn, OpenSum, OpenSumFC, VendorNum, SerialNum, WhsCode, SlpCode, Commission, TreeType, AcctCode, TaxStatus, GrossBuyPr, PriceBefDi, DocDate, Flags, OpenCreQty, UseBaseUn, SubCatNum, BaseCard, TotalSumSy, OpenSumSys, InvntSttus, OcrCode, Project, CodeBars, VatPrcnt, VatGroup)
    VALUES (source.DocEntry, source.LineNum, source.TargetType, source.TrgetEntry, source.BaseRef, source.BaseType, source.BaseEntry, source.BaseLine, source.LineStatus, source.Dscription, source.Quantity, source.ShipDate, source.OpenQty, source.Price, source.Currency, source.Rate, source.DiscPrcnt, source.LineTotal, source.TotalFrgn, source.OpenSum, source.OpenSumFC, source.VendorNum, source.SerialNum, source.WhsCode, source.SlpCode, source.Commission, source.TreeType, source.AcctCode, source.TaxStatus, source.GrossBuyPr, source.PriceBefDi, source.DocDate, source.Flags, source.OpenCreQty, source.UseBaseUn, source.SubCatNum, source.BaseCard, source.TotalSumSy, source.OpenSumSys, source.InvntSttus, source.OcrCode, source.Project, source.CodeBars, source.VatPrcnt, source.VatGroup);

    PRINT 'Sincronización de app_rin1 completada exitosamente';
END;


GO
/****** Object:  StoredProcedure [dbo].[SYNC_Series]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SYNC_Series]
AS
BEGIN
    SET NOCOUNT ON;

    -- *** Llenar la tabla NNM1 desde la base de datos de origen ***
    MERGE INTO DATANWO.dbo.app_series AS target
    USING (
        SELECT 
            ObjectCode COLLATE SQL_Latin1_General_CP1_CI_AS AS ObjectCode,
            Series,
            SeriesName COLLATE SQL_Latin1_General_CP1_CI_AS AS SeriesName
        FROM [serv-sap].anwo_produccion.dbo.NNM1  -- Base de datos origen
    ) AS source
    ON target.ObjectCode COLLATE SQL_Latin1_General_CP1_CI_AS = source.ObjectCode 
       AND target.Series = source.Series  

    WHEN MATCHED AND (
        target.SeriesName <> source.SeriesName  
    ) THEN
        UPDATE SET 
            target.SeriesName = source.SeriesName   

    WHEN NOT MATCHED THEN
        INSERT (ObjectCode, Series, SeriesName)
        VALUES (source.ObjectCode, source.Series, source.SeriesName);

    PRINT 'Series llenadas exitosamente';
END;
GO
/****** Object:  StoredProcedure [dbo].[SYNC_USUARIOS_FROM_SAP]    Script Date: 11-04-2025 17:17:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SYNC_USUARIOS_FROM_SAP]
AS
BEGIN
    SET NOCOUNT ON;

    -- Cargar datos desde SAP a tabla temporal
    IF OBJECT_ID('tempdb..#SAP_Usuarios') IS NOT NULL DROP TABLE #SAP_Usuarios;

    SELECT 
        T0.[USERID],
        T0.[USER_CODE] COLLATE SQL_Latin1_General_CP1_CI_AS AS USER_CODE,
        T0.[U_NAME] COLLATE SQL_Latin1_General_CP1_CI_AS AS U_NAME,
        T0.[E_Mail] COLLATE SQL_Latin1_General_CP1_CI_AS AS E_Mail,
        T0.[Branch],
        T1.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS AS BranchName,
        T0.[Department],
        T2.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS AS DepartmentName
    INTO #SAP_Usuarios
    FROM [serv-sap].anwo_produccion.dbo.OUSR T0  
    INNER JOIN [serv-sap].anwo_produccion.dbo.OUBR T1 ON T0.[Branch] = T1.[Code]
    INNER JOIN [serv-sap].anwo_produccion.dbo.OUDP T2 ON T0.[Department] = T2.[Code]
    WHERE T0.[Locked] = 'N'
      AND T0.[E_Mail] IS NOT NULL
      AND LTRIM(RTRIM(T0.[E_Mail])) <> '';

    ----------------------------------------------------------------------------------
    -- Sincronización con app_usuarios
    MERGE DATANWO.dbo.app_usuarios AS target
    USING #SAP_Usuarios AS source
    ON target.USERID = source.USERID

    WHEN MATCHED AND 
    (
        ISNULL(target.USER_CODE, '') COLLATE SQL_Latin1_General_CP1_CI_AS <> ISNULL(source.USER_CODE, '') OR
        ISNULL(target.first_name, '') COLLATE SQL_Latin1_General_CP1_CI_AS <> ISNULL(source.U_NAME, '') OR
        ISNULL(target.email, '') COLLATE SQL_Latin1_General_CP1_CI_AS <> ISNULL(source.E_Mail, '') OR
        ISNULL(target.Branch, -1) <> ISNULL(source.Branch, -1) OR
        ISNULL(target.BranchName, '') COLLATE SQL_Latin1_General_CP1_CI_AS <> ISNULL(source.BranchName, '') OR
        ISNULL(target.Department, -1) <> ISNULL(source.Department, -1) OR
        ISNULL(target.DepartmentName, '') COLLATE SQL_Latin1_General_CP1_CI_AS <> ISNULL(source.DepartmentName, '')
    )
    THEN
        UPDATE SET
            target.USER_CODE = source.USER_CODE,
            target.first_name = source.U_NAME,
            target.email = source.E_Mail,
            target.Branch = source.Branch,
            target.BranchName = source.BranchName,
            target.Department = source.Department,
            target.DepartmentName = source.DepartmentName

    WHEN NOT MATCHED BY TARGET THEN
        INSERT (
            USERID, USER_CODE, email, Branch, BranchName, Department, DepartmentName,
            username, password, is_active, is_staff, is_superuser, date_joined,
            first_name, last_name
        )
        VALUES (
            source.USERID, source.USER_CODE, source.E_Mail,
            source.Branch, source.BranchName, source.Department, source.DepartmentName,
            ISNULL(NULLIF(LTRIM(RTRIM(source.U_NAME)), ''), 'usuario_' + CAST(source.USERID AS VARCHAR)),
            'ANWO1234',
            1, 0, 0, GETDATE(),
            ISNULL(NULLIF(LTRIM(RTRIM(source.U_NAME)), ''), 'Nombre_' + CAST(source.USERID AS VARCHAR)),
            'No_Aplica'
        );

    DROP TABLE #SAP_Usuarios;

    PRINT 'Sincronización de usuarios completada correctamente.';
END;
GO
