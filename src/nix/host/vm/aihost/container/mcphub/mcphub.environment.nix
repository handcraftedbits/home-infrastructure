{ vars, ... }:
''
ADMIN_PASSWORD=$(cat ${vars.mcphub.adminPassword})
GITHUB_PERSONAL_ACCESS_TOKEN=$(cat ${vars.github.pat.mcp})
TAVILY_API_KEY=$(cat ${vars.tavily.apiKey})
''
