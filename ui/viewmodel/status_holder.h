// Copyright 2018 The Beam Team
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
#pragma once

#include <QObject>
#include <functional>
#include "model/wallet_model.h"
#include "wallet/wallet_client.h"

class StatusHolder final: public QObject
{
    Q_OBJECT
public:
    StatusHolder();
    ~StatusHolder() override = default;

    beam::Amount getAvailable() const {return _status.available;}
    beam::Amount getReceiving() const {return _status.receiving;}
    beam::Amount getReceivingIncoming() const { return _status.receivingIncoming; }
    beam::Amount getReceivingChange() const { return _status.receivingChange; }
    beam::Amount getSending()   const {return _status.sending;}
    beam::Amount getMaturing()  const {return _status.maturing;}

    beam::Height getCurrentHeight() const { return _status.stateID.m_Height; }

    void setOnChanged(std::function<void()>&& cb) { _changedCB = std::move(cb); }
    void refresh();

public slots:
    void onStatusChanged(const beam::wallet::WalletStatus& status);

private:
    std::function<void()> _changedCB;
    WalletModel& _model;
    beam::wallet::WalletStatus _status;
};
