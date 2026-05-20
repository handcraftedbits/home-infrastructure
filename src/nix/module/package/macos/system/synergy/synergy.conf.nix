{ vars, ... }:
''
section: screens
  ${vars.hostName}:
  ${vars.synergy.allowedClient}:
end

section: links
  ${vars.hostName}:
    right = ${vars.synergy.allowedClient}
  ${vars.synergy.allowedClient}:
    left = ${vars.hostName}
end
''
