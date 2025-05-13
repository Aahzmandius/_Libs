---@alias Scheduler CooperativeScheduler|ImmediateScheduler|TimerScheduler

---@module "util"
local util = Ext.Require("Lib/ReactiveX/reactivex/util.lua")
---@module "subscription"
local Subscription = Ext.Require("Lib/ReactiveX/reactivex/subscription.lua")
---@module "observer"
local Observer = Ext.Require("Lib/ReactiveX/reactivex/observer.lua")
---@module "observable"
local Observable = Ext.Require("Lib/ReactiveX/reactivex/observable.lua")
---@module "immediatescheduler"
local ImmediateScheduler = Ext.Require("Lib/ReactiveX/reactivex/schedulers/immediatescheduler.lua")
---@module "cooperativescheduler"
local CooperativeScheduler = Ext.Require("Lib/ReactiveX/reactivex/schedulers/cooperativescheduler.lua")
---@module "timeoutscheduler"
local TimerScheduler = Ext.Require("Lib/ReactiveX/reactivex/schedulers/timerscheduler.lua")
---@module "subject"
local Subject = Ext.Require("Lib/ReactiveX/reactivex/subjects/subject.lua")
---@module "asyncsubject"
local AsyncSubject = Ext.Require("Lib/ReactiveX/reactivex/subjects/asyncsubject.lua")
---@module "behaviorsubject"
local BehaviorSubject = Ext.Require("Lib/ReactiveX/reactivex/subjects/behaviorsubject.lua")
---@module "replaysubject"
local ReplaySubject = Ext.Require("Lib/ReactiveX/reactivex/subjects/replaysubject.lua")

-- just need to touch a lift() to trigger AnonymousSubject's lazy load, only needed because separated library dependency
local lazyLoadFix = Subject.Create():Count(function() return 42 end)

---@class RX
---@field Subscription Subscription
---@field Observer Observer
---@field Observable Observable
---@field ImmediateScheduler ImmediateScheduler
---@field CooperativeScheduler CooperativeScheduler
---@field TimerScheduler TimerScheduler
---@field Subject Subject
---@field AsyncSubject AsyncSubject
---@field BehaviorSubject BehaviorSubject
---@field ReplaySubject ReplaySubject
---@field util table Internal utilities
return {
    util = util,
    Subscription = Subscription,
    Observer = Observer,
    Observable = Observable,
    ImmediateScheduler = ImmediateScheduler,
    CooperativeScheduler = CooperativeScheduler,
    TimerScheduler = TimerScheduler,
    Subject = Subject,
    AsyncSubject = AsyncSubject,
    BehaviorSubject = BehaviorSubject,
    ReplaySubject = ReplaySubject
}
