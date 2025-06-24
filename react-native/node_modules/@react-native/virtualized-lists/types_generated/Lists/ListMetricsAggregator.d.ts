/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @generated SignedSource<<efe8dde9ac891832f483def06363281e>>
 *
 * This file was translated from Flow by scripts/build-types/index.js.
 * Original file: packages/virtualized-lists/Lists/ListMetricsAggregator.js
 */

import type { VirtualizedListProps } from "./VirtualizedListProps";
import type { LayoutRectangle } from "react-native";
export type CellMetrics = {
  /**
   * Index of the item in the list
   */
  index: number;
  /**
   * Length of the cell along the scrolling axis
   */
  length: number;
  /**
   * Distance between this cell and the start of the list along the scrolling
   * axis
   */
  offset: number;
  /**
   * Whether the cell is last known to be mounted
   */
  isMounted: boolean;
};
export type ListOrientation = {
  horizontal: boolean;
  rtl: boolean;
};
/**
 * Subset of VirtualizedList props needed to calculate cell metrics
 */
export type CellMetricProps = {
  data: VirtualizedListProps["data"];
  getItemCount: VirtualizedListProps["getItemCount"];
  getItem: VirtualizedListProps["getItem"];
  getItemLayout?: VirtualizedListProps["getItemLayout"];
  keyExtractor?: VirtualizedListProps["keyExtractor"];
};
/**
 * Provides an interface to query information about the metrics of a list and its cells.
 */
declare class ListMetricsAggregator {
  notifyCellLayout($$PARAM_0$$: {
    cellIndex: number;
    cellKey: string;
    orientation: ListOrientation;
    layout: LayoutRectangle;
  }): boolean;
  notifyCellUnmounted(cellKey: string): void;
  notifyListContentLayout($$PARAM_0$$: {
    orientation: ListOrientation;
    layout: Readonly<{
      width: number;
      height: number;
    }>;
  }): void;
  getAverageCellLength(): number;
  getHighestMeasuredCellIndex(): number;
  getCellMetricsApprox(index: number, props: CellMetricProps): CellMetrics;
  getCellMetrics(index: number, props: CellMetricProps): null | undefined | CellMetrics;
  getCellOffsetApprox(index: number, props: CellMetricProps): number;
  getContentLength(): number;
  hasContentLength(): boolean;
  flowRelativeOffset(layout: LayoutRectangle, referenceContentLength?: null | undefined | number): number;
  cartesianOffset(flowRelativeOffset: number): number;
}
export default ListMetricsAggregator;
