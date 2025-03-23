import { describe, it } from "node:test";
import assert from "node:assert";
import { handler } from "./index.js";

describe("handler", () => {
  it("must not throw error when receives valid event", async () => {
    const event = {
      message: "Hello",
    };

    await assert.doesNotReject(async () => {
      const result = await handler(event);

      assert.equal(result.message, "HELLO")
    });
  });

  it("must throw error when receives invalid event", async () => {
    const event = {
      msg: "Hello",
    };

    await assert.rejects(async () => {
      await handler(event);
    });
  });
});
