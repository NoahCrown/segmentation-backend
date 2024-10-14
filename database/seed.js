const { PrismaClient } = require("@prisma/client");
const { faker } = require("@faker-js/faker");

const prisma = new PrismaClient();

async function clearDatabase() {
  await prisma.rolesOnJobRequest.deleteMany();
  await prisma.skillOnJobRequest.deleteMany();
  await prisma.locationOnJobRequest.deleteMany();
  await prisma.customTypeOnJobRequest.deleteMany();
  await prisma.jobRequest.deleteMany();
  await prisma.user.deleteMany();
  await prisma.seniorityLevel.deleteMany();
  await prisma.managementRolesOnIndustry.deleteMany();
  await prisma.managementRole.deleteMany();
  await prisma.role.deleteMany();
  await prisma.department.deleteMany();
  await prisma.teamMatrix.deleteMany();
  await prisma.location.deleteMany();
  await prisma.customType.deleteMany();
  await prisma.customTypeChildren.deleteMany();
  await prisma.skill.deleteMany();
  await prisma.client.deleteMany();
}

async function createDepartments(
  industryId,
  parentDepartmentId = null,
  depth = 0
) {
  if (depth > 3) return []; // Limit depth for simplicity

  const departments = [];
  for (let i = 0; i < 2; i++) {
    const department = await prisma.department.create({
      data: {
        name: faker.company.name(),
        industryId,
        parentDepartmentId,
      },
    });
    departments.push(department);
    const subDepartments = await createDepartments(
      industryId,
      department.id,
      depth + 1
    );
    departments.push(...subDepartments);
  }
  return departments;
}

async function main() {
  await clearDatabase();

  // Seed TeamMatrix
  const teamMatrices = ["Technology", "Finance", "Healthcare", "Education"];
  const createdTeamMatrices = await Promise.all(
    teamMatrices.map((name) => prisma.teamMatrix.create({ data: { name } }))
  );

  // Seed Departments
  const createdDepartments = [];
  for (const teamMatrix of createdTeamMatrices) {
    const departments = await createDepartments(teamMatrix.id);
    createdDepartments.push(...departments);
  }

  // Seed Roles
  const roles = [
    { name: "Software Engineer", departmentId: createdDepartments[0].id },
    { name: "Product Manager", departmentId: createdDepartments[1].id },
    { name: "Marketing Specialist", departmentId: createdDepartments[2].id },
    { name: "Sales Representative", departmentId: createdDepartments[3].id },
    { name: "HR Manager", departmentId: createdDepartments[4].id },
  ];
  const createdRoles = await Promise.all(
    roles.map((role) =>
      prisma.role.create({
        data: {
          name: role.name,
          departmentId: role.departmentId,
          isManagementRole: faker.datatype.boolean(),
        },
      })
    )
  );

  // Seed ManagementRoles
  const managementRoles = ["Team Lead", "Project Manager", "Director"];
  const createdManagementRoles = await Promise.all(
    managementRoles.map((name) =>
      prisma.managementRole.create({ data: { name } })
    )
  );

  // Seed SeniorityLevels
  const seniorityLevels = ["Entry", "Mid", "Senior", "Lead"];
  const createdSeniorityLevels = await Promise.all(
    seniorityLevels.map((name) =>
      prisma.seniorityLevel.create({ data: { name } })
    )
  );

  // Seed CustomTypes
  const customTypes = ["Type A", "Type B", "Type C", "Type D"];
  const createdCustomTypes = await Promise.all(
    customTypes.map((name) => prisma.customType.create({ data: { name } }))
  );

  // Seed Locations
  const locations = ["New York", "San Francisco", "London", "Tokyo", "Remote"];
  const createdLocations = await Promise.all(
    locations.map((name) => prisma.location.create({ data: { name } }))
  );

  // Seed Skills
  const skills = ["JavaScript", "Python", "React", "SQL", "Project Management"];
  const createdSkills = await Promise.all(
    skills.map((name) => prisma.skill.create({ data: { name } }))
  );

  // Seed Users
  const users = Array(10)
    .fill(null)
    .map(() => ({
      name: faker.person.fullName(),
    }));
  const createdUsers = await Promise.all(
    users.map((user) => prisma.user.create({ data: user }))
  );

  // Seed JobRequests and related entities
  const jobRequests = await Promise.all(
    Array(20)
      .fill(null)
      .map(async () => {
        const jobRequest = await prisma.jobRequest.create({
          data: {
            user: {
              connect: { id: faker.helpers.arrayElement(createdUsers).id },
            },
            seniorityLevel: {
              connect: {
                id: faker.helpers.arrayElement(createdSeniorityLevels).id,
              },
            },
            salaryMin: faker.number.int({ min: 30000, max: 80000 }),
            salaryMax: faker.number.int({ min: 80001, max: 150000 }),
            customTypesOnJobRequest: {
              create: {
                customType: {
                  connect: {
                    id: faker.helpers.arrayElement(createdCustomTypes).id,
                  },
                },
              },
            },
            locationsOnJobRequest: {
              create: {
                location: {
                  connect: {
                    id: faker.helpers.arrayElement(createdLocations).id,
                  },
                },
              },
            },
            skillsOnJobRequest: {
              create: {
                skill: {
                  connect: {
                    id: faker.helpers.arrayElement(createdSkills).id,
                  },
                },
              },
            },
            rolesOnJobRequest: {
              create: {
                ...(Math.random() > 0.5
                  ? {
                      role: {
                        connect: {
                          id: faker.helpers.arrayElement(createdRoles).id,
                        },
                      },
                    }
                  : {
                      department: {
                        connect: {
                          id: faker.helpers.arrayElement(createdDepartments).id,
                        },
                      },
                    }),
              },
            },
          },
        });

        return jobRequest;
      })
  );

  // Seed Clients
  const clients = ["Client A", "Client B", "Client C"];
  const createdClients = await Promise.all(
    clients.map((name) =>
      prisma.client.create({
        data: {
          name,
          teamMatrixId: faker.helpers.arrayElement(createdTeamMatrices).id,
        },
      })
    )
  );

  console.log("Seeding completed successfully!");
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
