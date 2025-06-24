/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @generated SignedSource<<f516b2ab67480168bb76a1be41b99d5c>>
 *
 * This file was translated from Flow by scripts/build-types/index.js.
 * Original file: packages/virtualized-lists/Lists/VirtualizedSectionList.js
 */

import type { VirtualizedListProps } from "./VirtualizedListProps";
import VirtualizedList from "./VirtualizedList";
import * as React from "react";
type DefaultSectionT = {
  data: any;
  [key: string]: any;
};
export type SectionData<SectionItemT, SectionT = DefaultSectionT> = (Readonly<SectionBase<SectionItemT, SectionT>> & SectionT) | (SectionBase<SectionItemT, SectionT> & SectionT) | SectionT;
export type SectionBase<SectionItemT, SectionT = DefaultSectionT> = {
  /**
   * The data for rendering items in this section.
   */
  data: ReadonlyArray<SectionItemT>;
  /**
   * Optional key to keep track of section re-ordering. If you don't plan on re-ordering sections,
   * the array index will be used by default.
   */
  key?: string;
  renderItem?: ((info: {
    item: SectionItemT;
    index: number;
    section: SectionData<SectionItemT, SectionT>;
    separators: {
      highlight: () => void;
      unhighlight: () => void;
      updateProps: (select: "leading" | "trailing", newProps: Object) => void;
    };
  }) => null | React.JSX.Element) | undefined;
  ItemSeparatorComponent?: React.ComponentType<any> | undefined;
  keyExtractor?: (item: SectionItemT | undefined, index?: number | undefined) => string;
};
type RequiredProps<ItemT, SectionT = DefaultSectionT> = {
  sections: ReadonlyArray<SectionData<ItemT, SectionT>>;
};
type OptionalProps<ItemT, SectionT = DefaultSectionT> = {
  /**
   * Default renderer for every item in every section.
   */
  renderItem?: (info: {
    item: ItemT;
    index: number;
    section: SectionT;
    separators: {
      highlight: () => void;
      unhighlight: () => void;
      updateProps: (select: "leading" | "trailing", newProps: Object) => void;
    };
  }) => null | React.ReactNode;
  /**
   * Rendered at the top of each section. These stick to the top of the `ScrollView` by default on
   * iOS. See `stickySectionHeadersEnabled`.
   */
  renderSectionHeader?: ((info: {
    section: SectionT;
  }) => null | React.ReactNode) | undefined;
  /**
   * Rendered at the bottom of each section.
   */
  renderSectionFooter?: ((info: {
    section: SectionT;
  }) => null | React.ReactNode) | undefined;
  /**
   * Rendered at the top and bottom of each section (note this is different from
   * `ItemSeparatorComponent` which is only rendered between items). These are intended to separate
   * sections from the headers above and below and typically have the same highlight response as
   * `ItemSeparatorComponent`. Also receives `highlighted`, `[leading/trailing][Item/Separator]`,
   * and any custom props from `separators.updateProps`.
   */
  SectionSeparatorComponent?: React.ComponentType<any> | undefined;
  /**
   * Makes section headers stick to the top of the screen until the next one pushes it off. Only
   * enabled by default on iOS because that is the platform standard there.
   */
  stickySectionHeadersEnabled?: boolean;
  onEndReached?: (($$PARAM_0$$: {
    distanceFromEnd: number;
  }) => void) | undefined;
};
export type VirtualizedSectionListProps<ItemT, SectionT = DefaultSectionT> = Omit<RequiredProps<ItemT, SectionT>, keyof OptionalProps<ItemT, SectionT> | keyof Omit<VirtualizedListProps, "data" | "renderItem"> | keyof {}> & Omit<OptionalProps<ItemT, SectionT>, keyof Omit<VirtualizedListProps, "data" | "renderItem"> | keyof {}> & Omit<Omit<VirtualizedListProps, "data" | "renderItem">, keyof {}> & {};
export type ScrollToLocationParamsType = {
  animated?: boolean | undefined;
  itemIndex: number;
  sectionIndex: number;
  viewOffset?: number;
  viewPosition?: number;
};
declare const VirtualizedSectionListComponent: <ItemT, SectionT extends SectionBase<ItemT, DefaultSectionT> = DefaultSectionT>(props: Omit<VirtualizedSectionListProps<ItemT, SectionT>, keyof {
  ref: React.Ref<{
    getListRef(): VirtualizedList | undefined;
    scrollToLocation(params: ScrollToLocationParamsType): void;
  }>;
}> & {
  ref: React.Ref<{
    getListRef(): VirtualizedList | undefined;
    scrollToLocation(params: ScrollToLocationParamsType): void;
  }>;
}) => React.ReactNode;
declare const $$VirtualizedSectionList: typeof VirtualizedSectionListComponent;
declare type $$VirtualizedSectionList = typeof $$VirtualizedSectionList;
export default $$VirtualizedSectionList;
export type AnyVirtualizedSectionList = typeof VirtualizedSectionListComponent;
