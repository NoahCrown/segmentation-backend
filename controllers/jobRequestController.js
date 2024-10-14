const {PrismaClient} = require('@prisma/client')
const prisma = new PrismaClient();

// Create a job request
async function createJobRequest(req, res) {
  try {
    const {
      userId,
      seniorityLevelId,
      salaryMin,
      salaryMax,
      roleId,
      departmentId,
      customTypeIds,
      locationIds,
      skillIds,
    } = req.body;

    if ((roleId && departmentId) || (!roleId && !departmentId)) {
      throw new Error("Either roleId or departmentId must be set, but not both.");
    }

    const jobRequest = await prisma.jobRequest.create({
      data: {
        userId,
        seniorityLevelId,
        salaryMin,
        salaryMax,
        customTypesOnJobRequest: {
          create: customTypeIds.map((customTypeId) => ({
            customType: { connect: { id: customTypeId } },
          })),
        },
        locationsOnJobRequest: {
          create: locationIds.map((locationId) => ({
            location: { connect: { id: locationId } },
          })),
        },
        skillsOnJobRequest: {
          create: skillIds.map((skillId) => ({
            skill: { connect: { id: skillId } },
          })),
        },
        rolesOnJobRequest: {
          create: {
            ...(roleId && { role: { connect: { id: roleId } } }),
            ...(departmentId && {
              department: { connect: { id: departmentId } },
            }),
          },
        },
      },
    });

    res.status(201).json(jobRequest);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
}

// Get all job requests
async function getAllJobRequests(req, res) {
  try {
    const jobRequests = await prisma.jobRequest.findMany({
      include: {
        user: true,
        seniorityLevel: true,
        customTypesOnJobRequest: {
          include: {
            customType: true,
          },
        },
        locationsOnJobRequest: {
          include: {
            location: true,
          },
        },
        skillsOnJobRequest: {
          include: {
            skill: true,
          },
        },
        rolesOnJobRequest: {
          include: {
            role: {
              include: {
                department: {
                  include: {
                    parentDepartment: true,
                  },
                },
              },
            },
          },
        },
      },
    });

    res.status(200).json(jobRequests);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

module.exports = {
  createJobRequest,
  getAllJobRequests,
};
