exports.onExecutePostLogin = async (event, api) => {
  const namespace = "https://projsoft.com/";

  api.accessToken.setCustomClaim(
    `${namespace}email`,
    event.user.email
  );

  api.accessToken.setCustomClaim(
    `${namespace}roles`,
    event.authorization?.roles ?? []
  );
};
