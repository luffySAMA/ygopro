--銀河眼の光子竜
function c93717133.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c93717133.spcon)
	e1:SetOperation(c93717133.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(93717133,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(TIMING_BATTLE_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c93717133.rmcon)
	e2:SetTarget(c93717133.rmtg)
	e2:SetOperation(c93717133.rmop)
	c:RegisterEffect(e2)
end
function c93717133.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsAttackAbove,2,nil,2000)
end
function c93717133.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsAttackAbove,2,2,nil,2000)
	Duel.Release(g,REASON_COST)
end
function c93717133.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c93717133.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if chk==0 then return (a==e:GetHandler() and d and d:IsOnField() and d:IsCanBeEffectTarget(e) and a:IsAbleToRemove() and d:IsAbleToRemove())
		or (d==e:GetHandler() and a:IsOnField() and a:IsCanBeEffectTarget(e) and a:IsAbleToRemove() and d:IsAbleToRemove()) end
	if a==e:GetHandler() then Duel.SetTargetCard(d)
	else Duel.SetTargetCard(a) end
	local g=Group.FromCards(a,d)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c93717133.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local g=Group.FromCards(c,tc)
	local mcount=0
	if tc:IsFaceup() then mcount=tc:GetOverlayCount() end
	Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	e1:SetLabelObject(c)
	e1:SetLabel(mcount)
	e1:SetCountLimit(1)
	e1:SetOperation(c93717133.retop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	e2:SetLabelObject(tc)
	e2:SetLabel(0)
	e2:SetCountLimit(1)
	e2:SetOperation(c93717133.retop)
	tc:RegisterEffect(e2)
end
function c93717133.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	Duel.ReturnToField(c)
	if c:IsOnField() and c:IsFaceup() and e:GetLabel()~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(e:GetLabel()*500)
		c:RegisterEffect(e1)
	end
end
