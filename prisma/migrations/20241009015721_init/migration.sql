-- CreateTable
CREATE TABLE "TeamMatrix" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "TeamMatrix_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "department" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "parentDepartmentId" INTEGER,
    "industryId" INTEGER NOT NULL,

    CONSTRAINT "department_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Role" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "departmentId" INTEGER NOT NULL,
    "isManagementRole" BOOLEAN NOT NULL,
    "managementRoleId" INTEGER,

    CONSTRAINT "Role_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ManagementRole" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "ManagementRole_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SeniorityLevel" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "SeniorityLevel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "JobRequest" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "seniorityLevelId" INTEGER NOT NULL,
    "salaryMin" INTEGER NOT NULL,
    "salaryMax" INTEGER NOT NULL,

    CONSTRAINT "JobRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Location" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Location_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CustomType" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "CustomType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CustomTypeChildren" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "customTypeId" INTEGER NOT NULL,

    CONSTRAINT "CustomTypeChildren_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Skill" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Skill_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SkillOnJobRequest" (
    "id" SERIAL NOT NULL,
    "skillId" INTEGER NOT NULL,
    "jobRequestId" INTEGER NOT NULL,

    CONSTRAINT "SkillOnJobRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LocationOnJobRequest" (
    "id" SERIAL NOT NULL,
    "locationId" INTEGER NOT NULL,
    "jobRequestId" INTEGER NOT NULL,

    CONSTRAINT "LocationOnJobRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CustomTypeOnJobRequest" (
    "id" SERIAL NOT NULL,
    "customTypeId" INTEGER NOT NULL,
    "jobRequestId" INTEGER NOT NULL,

    CONSTRAINT "CustomTypeOnJobRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ManagementRolesOnIndustry" (
    "id" SERIAL NOT NULL,
    "industryId" INTEGER NOT NULL,
    "managementRoleId" INTEGER NOT NULL,

    CONSTRAINT "ManagementRolesOnIndustry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RolesOnJobRequest" (
    "id" SERIAL NOT NULL,
    "roleId" INTEGER,
    "jobRequestId" INTEGER NOT NULL,
    "departmentId" INTEGER,

    CONSTRAINT "RolesOnJobRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Client" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "teamMatrixId" INTEGER NOT NULL,

    CONSTRAINT "Client_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "department" ADD CONSTRAINT "department_parentDepartmentId_fkey" FOREIGN KEY ("parentDepartmentId") REFERENCES "department"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "department" ADD CONSTRAINT "department_industryId_fkey" FOREIGN KEY ("industryId") REFERENCES "TeamMatrix"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Role" ADD CONSTRAINT "Role_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "department"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Role" ADD CONSTRAINT "Role_managementRoleId_fkey" FOREIGN KEY ("managementRoleId") REFERENCES "ManagementRole"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JobRequest" ADD CONSTRAINT "JobRequest_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JobRequest" ADD CONSTRAINT "JobRequest_seniorityLevelId_fkey" FOREIGN KEY ("seniorityLevelId") REFERENCES "SeniorityLevel"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CustomTypeChildren" ADD CONSTRAINT "CustomTypeChildren_customTypeId_fkey" FOREIGN KEY ("customTypeId") REFERENCES "CustomType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SkillOnJobRequest" ADD CONSTRAINT "SkillOnJobRequest_skillId_fkey" FOREIGN KEY ("skillId") REFERENCES "Skill"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SkillOnJobRequest" ADD CONSTRAINT "SkillOnJobRequest_jobRequestId_fkey" FOREIGN KEY ("jobRequestId") REFERENCES "JobRequest"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LocationOnJobRequest" ADD CONSTRAINT "LocationOnJobRequest_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "Location"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LocationOnJobRequest" ADD CONSTRAINT "LocationOnJobRequest_jobRequestId_fkey" FOREIGN KEY ("jobRequestId") REFERENCES "JobRequest"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CustomTypeOnJobRequest" ADD CONSTRAINT "CustomTypeOnJobRequest_customTypeId_fkey" FOREIGN KEY ("customTypeId") REFERENCES "CustomType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CustomTypeOnJobRequest" ADD CONSTRAINT "CustomTypeOnJobRequest_jobRequestId_fkey" FOREIGN KEY ("jobRequestId") REFERENCES "JobRequest"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ManagementRolesOnIndustry" ADD CONSTRAINT "ManagementRolesOnIndustry_industryId_fkey" FOREIGN KEY ("industryId") REFERENCES "TeamMatrix"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ManagementRolesOnIndustry" ADD CONSTRAINT "ManagementRolesOnIndustry_managementRoleId_fkey" FOREIGN KEY ("managementRoleId") REFERENCES "ManagementRole"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RolesOnJobRequest" ADD CONSTRAINT "RolesOnJobRequest_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "Role"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RolesOnJobRequest" ADD CONSTRAINT "RolesOnJobRequest_jobRequestId_fkey" FOREIGN KEY ("jobRequestId") REFERENCES "JobRequest"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RolesOnJobRequest" ADD CONSTRAINT "RolesOnJobRequest_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "department"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Client" ADD CONSTRAINT "Client_teamMatrixId_fkey" FOREIGN KEY ("teamMatrixId") REFERENCES "TeamMatrix"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
