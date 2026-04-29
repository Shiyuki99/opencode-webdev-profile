import type { Plugin } from "@opencode-ai/plugin";

interface ProfileConfig {
  mcp?: Record<string, { enabled: boolean }>;
  disabled_skills?: string[];
  enabled_skills?: string[];
}

interface Profiles {
  [key: string]: ProfileConfig;
}

const DEFAULT_PROFILE = "webdev";
const PROFILE_ENV = "OPENCODE_PROFILE";

const profiles: Profiles = {
  webdev: {
    mcp: {
      supabase: { enabled: true },
      github: { enabled: true },
      "21st-dev-magic": { enabled: true },
      "sequential-thinking": { enabled: true },
    },
    enabled_skills: [
      "api-patterns",
      "architecture-review",
      "brainstorming",
      "bug-hunter",
      "ckm:design",
      "codex-review",
      "context-manager",
      "database-optimizer",
      "frontend-ui-dark-ts",
      "supabase",
      "ui-styling",
      "ui-ux-pro-max",
      "writing-plans",
    ],
  },
};

export const ProfilePlugin: Plugin = async () => {
  return {
    config: async (config) => {
      const profileName = process.env[PROFILE_ENV] ?? DEFAULT_PROFILE;
      const profile = profiles[profileName];
      if (!profile) return;

      if (profile.mcp) {
        for (const [server, settings] of Object.entries(profile.mcp)) {
          if (config.mcp && config.mcp[server]) {
            config.mcp[server].enabled = settings.enabled;
          }
        }
      }

      if (profile.disabled_skills || profile.enabled_skills) {
        config.skills = config.skills || {};
        config.skills.permissions = config.skills.permissions || {};

        for (const skill of profile.enabled_skills || []) {
          config.skills.permissions[skill] = "allow";
        }
        for (const skill of profile.disabled_skills || []) {
          config.skills.permissions[skill] = "deny";
        }
      }
    },
  };
};

export default ProfilePlugin;