/**
 * @param {any} event 
 * @returns {Promise<any>}
 * @throws {Error}
 */
export async function handler(event) {
  console.log("Received request");

  console.log(event, event?.message)

  if (typeof event?.message !== "string" || event?.message === "") {
    console.error("Message must not be empty");
    throw new Error("Message must not be empty");
  }

  console.log("Received message", event.message);

  return {
    message: event.message.toUpperCase(),
  };
}
