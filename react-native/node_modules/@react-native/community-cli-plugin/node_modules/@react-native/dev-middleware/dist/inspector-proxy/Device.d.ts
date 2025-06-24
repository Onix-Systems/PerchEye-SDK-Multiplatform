/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 *
 * @format
 * @oncall react_native
 */

import type { EventReporter } from "../types/EventReporter";
import type { CreateCustomMessageHandlerFn } from "./CustomMessageHandler";
import type { Page } from "./types";
import WS from "ws";
export declare const WS_CLOSE_REASON: {
  PAGE_NOT_FOUND: "Debugger Page Not Found";
  DEVICE_DISCONNECTED: "Corresponding Device Disconnected";
  RECREATING_DEVICE: "Recreating Device Connection";
  RECREATING_DEBUGGER: "Recreating Debugger Connection";
};
export declare type WS_CLOSE_REASON = typeof WS_CLOSE_REASON;
export type DeviceOptions = Readonly<{
  id: string;
  name: string;
  app: string;
  socket: WS;
  projectRoot: string;
  eventReporter: null | undefined | EventReporter;
  createMessageMiddleware: null | undefined | CreateCustomMessageHandlerFn;
  deviceRelativeBaseUrl: URL;
  serverRelativeBaseUrl: URL;
  isProfilingBuild: boolean;
}>;
/**
 * Device class represents single device connection to Inspector Proxy. Each device
 * can have multiple inspectable pages.
 */
declare class Device {
  constructor(deviceOptions: DeviceOptions);
  dangerouslyRecreateDevice(deviceOptions: DeviceOptions): void;
  getName(): string;
  getApp(): string;
  getPagesList(): ReadonlyArray<Page>;
  handleDebuggerConnection(
    socket: WS,
    pageId: string,
    $$PARAM_2$$: Readonly<{
      debuggerRelativeBaseUrl: URL;
      userAgent: string | null;
    }>
  ): void;
  dangerouslyGetSocket(): WS;
}
export default Device;
